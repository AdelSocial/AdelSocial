<?php

use Illuminate\Support\Facades\Route;

Route::get('/', function () {
    return view('welcome');
});

Route::get('/plans', [\App\Http\Controllers\PlanController::class, 'index']);

Route::prefix('checkout')->group(function () {
    Route::post('/orders', [\App\Http\Controllers\CheckoutController::class, 'createOrder']);
    Route::post('/orders/{order}/stripe/payment-intent', [\App\Http\Controllers\CheckoutController::class, 'createStripePaymentIntent']);
});

Route::post('/webhooks/stripe', \App\Http\Controllers\StripeWebhookController::class);
