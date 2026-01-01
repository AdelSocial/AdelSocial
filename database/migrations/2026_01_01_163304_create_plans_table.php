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
        Schema::create('plans', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('slug')->unique();
            $table->text('description')->nullable();

            $table->char('currency', 3)->default('USD');
            $table->unsignedBigInteger('amount_cents');
            $table->string('interval')->default('month'); // month|year
            $table->unsignedInteger('interval_count')->default(1);
            $table->unsignedInteger('trial_days')->default(0);
            $table->unsignedBigInteger('setup_fee_cents')->default(0);

            // Hosting limits and flags used by server placement logic
            $table->json('limits')->nullable(); // { cpu, memory_mb, storage_gb, visits, ... }
            $table->boolean('requires_dedicated_server')->default(false);

            $table->boolean('is_active')->default(true);
            $table->unsignedInteger('sort_order')->default(0);

            $table->timestamps();
            $table->softDeletes();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('plans');
    }
};
