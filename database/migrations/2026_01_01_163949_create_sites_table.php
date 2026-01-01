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
        Schema::create('sites', function (Blueprint $table) {
            $table->id();
            $table->foreignId('user_id')->constrained()->cascadeOnDelete();
            $table->foreignId('order_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('subscription_id')->nullable()->constrained()->nullOnDelete();
            $table->foreignId('plan_id')->constrained()->restrictOnDelete();
            $table->foreignId('server_id')->nullable()->constrained()->nullOnDelete();

            $table->string('primary_domain')->index();
            $table->string('status')->index(); // provisioning|active|suspended|failed|deleted

            // WordPress credentials generated during provisioning
            $table->string('wp_admin_user')->nullable();
            $table->text('wp_admin_password')->nullable(); // store encrypted at rest at app layer
            $table->string('wp_admin_email')->nullable();

            // Shared DB credentials (created per site on the server's shared DB)
            $table->string('db_name')->nullable();
            $table->string('db_user')->nullable();
            $table->text('db_password')->nullable(); // store encrypted at rest at app layer

            // Deployment details
            $table->string('stack_path')->nullable(); // e.g. /opt/waas/sites/<id>
            $table->string('container_name')->nullable();

            $table->timestamp('provisioned_at')->nullable();
            $table->timestamp('suspended_at')->nullable();
            $table->timestamp('deleted_at')->nullable();
            $table->text('failed_reason')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('sites');
    }
};
