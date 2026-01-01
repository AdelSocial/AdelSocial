<?php

namespace App\Services\Payments;

use App\Contracts\Payments\PaymentGateway;
use App\Enums\OrderStatus;
use App\Enums\PaymentStatus;
use App\Models\Order;
use App\Models\Payment;
use Illuminate\Support\Facades\Config;
use Illuminate\Support\Str;
use Stripe\StripeClient;

class StripeGateway implements PaymentGateway
{
    public function __construct(
        private readonly StripeClient $stripe,
    ) {
    }

    public static function fromConfig(): self
    {
        $secret = (string) Config::get('services.stripe.secret');
        if ($secret === '') {
            throw new \RuntimeException('STRIPE_SECRET is not configured.');
        }

        return new self(new StripeClient($secret));
    }

    public function createOrderPayment(Order $order): array
    {
        if ($order->status !== OrderStatus::Pending) {
            throw new \RuntimeException('Order must be pending to create a payment.');
        }

        $currency = $order->currency ?: (string) Config::get('services.stripe.currency', 'USD');

        $paymentIntent = $this->stripe->paymentIntents->create([
            'amount' => $order->total_cents,
            'currency' => Str::lower($currency),
            'metadata' => [
                'order_id' => (string) $order->id,
            ],
        ]);

        $payment = Payment::create([
            'user_id' => $order->user_id,
            'payable_type' => $order->getMorphClass(),
            'payable_id' => $order->id,
            'gateway' => 'stripe',
            'status' => PaymentStatus::RequiresAction,
            'currency' => $order->currency,
            'amount_cents' => $order->total_cents,
            'gateway_payment_intent_id' => $paymentIntent->id,
            'raw_response' => $paymentIntent->toArray(),
        ]);

        $order->forceFill([
            'gateway' => 'stripe',
            'gateway_reference' => $paymentIntent->id,
        ])->save();

        return [
            'payment' => $payment,
            'client' => [
                'client_secret' => $paymentIntent->client_secret,
                'payment_intent_id' => $paymentIntent->id,
            ],
        ];
    }
}

