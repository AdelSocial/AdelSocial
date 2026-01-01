<?php

namespace App\Http\Controllers;

use App\Enums\InvoiceStatus;
use App\Enums\OrderStatus;
use App\Models\Invoice;
use App\Models\Order;
use App\Models\Plan;
use App\Models\User;
use App\Services\Payments\StripeGateway;
use App\Support\InvoiceNumberGenerator;
use Illuminate\Http\JsonResponse;
use Illuminate\Http\Request;
use Illuminate\Support\Facades\Hash;
use Illuminate\Support\Str;

class CheckoutController extends Controller
{
    /**
     * Create a pending Order + open Invoice for a plan checkout.
     *
     * This is intentionally minimal: UI and full domain purchase flow will plug into this later.
     */
    public function createOrder(Request $request): JsonResponse
    {
        $data = $request->validate([
            'email' => ['required', 'email'],
            'name' => ['nullable', 'string', 'max:255'],
            'plan_id' => ['required', 'integer', 'exists:plans,id'],
            'domain_name' => ['nullable', 'string', 'max:255'],
            'design_key' => ['nullable', 'string', 'max:255'],
        ]);

        $plan = Plan::query()->whereKey($data['plan_id'])->firstOrFail();

        $user = User::query()->where('email', $data['email'])->first();
        if (! $user) {
            $user = User::create([
                'name' => $data['name'] ?: 'Customer',
                'email' => $data['email'],
                'password' => Hash::make(Str::password()),
            ]);
        }

        $subtotal = (int) $plan->amount_cents + (int) $plan->setup_fee_cents;
        $tax = 0;
        $total = $subtotal + $tax;

        $order = Order::create([
            'user_id' => $user->id,
            'plan_id' => $plan->id,
            'status' => OrderStatus::Pending,
            'currency' => $plan->currency,
            'subtotal_cents' => $subtotal,
            'tax_cents' => $tax,
            'total_cents' => $total,
            'domain_name' => $data['domain_name'] ?? null,
            'design_key' => $data['design_key'] ?? null,
        ]);

        $invoice = Invoice::create([
            'user_id' => $user->id,
            'subscription_id' => null,
            'order_id' => $order->id,
            'number' => InvoiceNumberGenerator::generateUnique(),
            'status' => InvoiceStatus::Open,
            'currency' => $order->currency,
            'amount_due_cents' => $order->total_cents,
            'amount_paid_cents' => 0,
            'due_at' => now()->addMinutes(30),
        ]);

        return response()->json([
            'data' => [
                'order' => $order,
                'invoice' => $invoice,
            ],
        ], 201);
    }

    /**
     * Create a Stripe PaymentIntent for a pending Order.
     */
    public function createStripePaymentIntent(Request $request, Order $order): JsonResponse
    {
        if ($order->status !== OrderStatus::Pending) {
            return response()->json([
                'message' => 'Order is not payable.',
            ], 409);
        }

        $gateway = StripeGateway::fromConfig();
        $result = $gateway->createOrderPayment($order);

        return response()->json([
            'data' => [
                'payment' => $result['payment'],
                'client' => $result['client'],
            ],
        ]);
    }
}

