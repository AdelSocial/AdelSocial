<?php

namespace App\Contracts\Payments;

use App\Models\Order;
use App\Models\Payment;

interface PaymentGateway
{
    /**
     * Create a payment attempt for an Order and return gateway-specific client data.
     *
     * Example: Stripe PaymentIntent client_secret for frontend confirmation.
     *
     * @return array{payment: Payment, client: array<string, mixed>}
     */
    public function createOrderPayment(Order $order): array;
}

