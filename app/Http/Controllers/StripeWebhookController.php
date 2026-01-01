<?php

namespace App\Http\Controllers;

use App\Enums\InvoiceStatus;
use App\Enums\OrderStatus;
use App\Enums\PaymentStatus;
use App\Jobs\ProvisionSiteJob;
use App\Models\Invoice;
use App\Models\Order;
use App\Models\Payment;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Facades\Log;
use Stripe\Exception\SignatureVerificationException;
use Stripe\Webhook;

class StripeWebhookController extends Controller
{
    public function __invoke(Request $request)
    {
        $secret = (string) Config::get('services.stripe.webhook_secret');

        if ($secret === '') {
            return response('Stripe webhook secret not configured.', 500);
        }

        $payload = $request->getContent();
        $sigHeader = (string) $request->header('Stripe-Signature');

        try {
            $event = Webhook::constructEvent($payload, $sigHeader, $secret);
        } catch (SignatureVerificationException $e) {
            return response('Invalid signature.', 400);
        } catch (\UnexpectedValueException $e) {
            return response('Invalid payload.', 400);
        }

        // We only implement the minimal events needed for an MVP.
        if ($event->type === 'payment_intent.succeeded') {
            $pi = $event->data->object;
            $paymentIntentId = $pi->id ?? null;
            $orderId = $pi->metadata->order_id ?? null;

            if (! $paymentIntentId || ! $orderId) {
                Log::warning('Stripe PI succeeded missing order metadata.', ['event_id' => $event->id]);
                return response('ok', 200);
            }

            /** @var Order|null $order */
            $order = Order::query()->whereKey($orderId)->first();
            if (! $order) {
                Log::warning('Stripe PI succeeded for unknown order.', ['order_id' => $orderId]);
                return response('ok', 200);
            }

            /** @var Payment|null $payment */
            $payment = Payment::query()
                ->where('gateway', 'stripe')
                ->where('gateway_payment_intent_id', $paymentIntentId)
                ->first();

            // Idempotency: if already paid, ack.
            if ($order->status === OrderStatus::Paid) {
                return response('ok', 200);
            }

            $order->forceFill([
                'status' => OrderStatus::Paid,
                'paid_at' => now(),
            ])->save();

            ProvisionSiteJob::dispatch($order->id);

            if ($payment) {
                $payment->forceFill([
                    'status' => PaymentStatus::Succeeded,
                    'raw_response' => is_object($pi) && method_exists($pi, 'toArray') ? $pi->toArray() : $payment->raw_response,
                ])->save();
            }

            /** @var Invoice|null $invoice */
            $invoice = Invoice::query()->where('order_id', $order->id)->first();
            if ($invoice && $invoice->status !== InvoiceStatus::Paid) {
                $invoice->forceFill([
                    'status' => InvoiceStatus::Paid,
                    'amount_paid_cents' => $order->total_cents,
                    'paid_at' => now(),
                ])->save();
            }
        }

        if ($event->type === 'payment_intent.payment_failed') {
            $pi = $event->data->object;
            $paymentIntentId = $pi->id ?? null;
            $orderId = $pi->metadata->order_id ?? null;

            if ($paymentIntentId && $orderId) {
                $order = Order::query()->whereKey($orderId)->first();
                if ($order && $order->status === OrderStatus::Pending) {
                    $order->forceFill([
                        'status' => OrderStatus::Failed,
                        'failed_at' => now(),
                    ])->save();
                }

                $payment = Payment::query()
                    ->where('gateway', 'stripe')
                    ->where('gateway_payment_intent_id', $paymentIntentId)
                    ->first();

                if ($payment && $payment->status !== PaymentStatus::Failed) {
                    $payment->forceFill([
                        'status' => PaymentStatus::Failed,
                        'failure_code' => $pi->last_payment_error->code ?? null,
                        'failure_message' => $pi->last_payment_error->message ?? null,
                        'raw_response' => is_object($pi) && method_exists($pi, 'toArray') ? $pi->toArray() : $payment->raw_response,
                    ])->save();
                }
            }
        }

        return response('ok', 200);
    }
}

