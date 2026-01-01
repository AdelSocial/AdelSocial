<?php

use Illuminate\Database\Migrations\Migration;
use Illuminate\Database\Schema\Blueprint;
use Illuminate\Support\Facades\Schema;

return new class extends Migration
{
    /**
     * Run the migrations.
     */
    public function up(): void
    {
        Schema::create('payments', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();

            // Payments can apply to an Order or an Invoice
            $table->morphs('payable');

            $table->string('gateway')->index(); // stripe|razorpay|paypal
            $table->string('status')->index();  // requires_action|succeeded|failed

            $table->char('currency', 3)->default('USD');
            $table->unsignedBigInteger('amount_cents')->default(0);

            $table->string('gateway_payment_id')->nullable();
            $table->string('gateway_payment_intent_id')->nullable();

            $table->string('failure_code')->nullable();
            $table->text('failure_message')->nullable();

            $table->json('raw_response')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('payments');
    }
};
