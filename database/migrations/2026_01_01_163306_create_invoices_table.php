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
        Schema::create('invoices', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('subscription_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('order_id')->nullable()->constrained()->nullOnDelete();

            $table->string('number')->unique();
            $table->string('status')->index(); // open|paid|void|uncollectible

            $table->char('currency', 3)->default('USD');
            $table->unsignedBigInteger('amount_due_cents')->default(0);
            $table->unsignedBigInteger('amount_paid_cents')->default(0);

            $table->timestamp('period_start')->nullable();
            $table->timestamp('period_end')->nullable();

            $table->timestamp('due_at')->nullable()->index();
            $table->timestamp('paid_at')->nullable()->index();

            $table->unsignedInteger('attempt_count')->default(0);
            $table->timestamp('next_attempt_at')->nullable();

            $table->json('metadata')->nullable();
            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('invoices');
    }
};
