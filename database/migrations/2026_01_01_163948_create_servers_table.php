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
        Schema::create('servers', function (Blueprint $table) {
            $table->id();
            $table->string('name');
            $table->string('type')->index(); // shared|dedicated
            $table->string('provider')->nullable(); // aws|lightsail|hetzner|...
            $table->string('region')->nullable();

            // SSH access (used by the Laravel provisioner to run Docker commands remotely)
            $table->string('ssh_host');
            $table->unsignedInteger('ssh_port')->default(22);
            $table->string('ssh_user')->default('ubuntu');
            $table->text('ssh_private_key')->nullable(); // store encrypted at rest at app layer

            // Host-level services config
            $table->boolean('traefik_enabled')->default(true);
            $table->string('letsencrypt_email')->nullable();
            $table->string('docker_network')->default('waas');

            // Shared MariaDB (one per server) used by "one container per customer" WordPress sites
            $table->boolean('shared_db_enabled')->default(true);
            $table->string('shared_db_host')->default('mariadb');
            $table->string('shared_db_root_password')->nullable(); // store encrypted at rest at app layer

            // Placement / capacity
            $table->unsignedInteger('max_sites')->default(200);
            $table->unsignedInteger('active_sites_count')->default(0);

            $table->boolean('is_active')->default(true);
            $table->timestamp('last_heartbeat_at')->nullable();

            $table->timestamps();
        });
    }

    /**
     * Reverse the migrations.
     */
    public function down(): void
    {
        Schema::dropIfExists('servers');
    }
};
