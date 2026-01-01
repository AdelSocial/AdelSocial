<?php

namespace Database\Seeders;

use App\Enums\BillingInterval;
use App\Models\Plan;
use App\Models\User;
use Illuminate\Database\Console\Seeds\WithoutModelEvents;
use Illuminate\Database\Seeder;
use Illuminate\Support\Facades\Hash;

class DatabaseSeeder extends Seeder
{
    use WithoutModelEvents;

    /**
     * Seed the application's database.
     */
    public function run(): void
    {
        // User::factory(10)->create();

        User::factory()->create([
            'name' => 'Admin',
            'email' => 'admin@example.com',
            'password' => Hash::make('password'),
            'is_admin' => true,
        ]);

        User::factory()->create([
            'name' => 'Customer',
            'email' => 'customer@example.com',
            'password' => Hash::make('password'),
            'is_admin' => false,
        ]);

        Plan::updateOrCreate(
            ['slug' => 'starter-monthly'],
            [
                'name' => 'Starter',
                'description' => 'Shared server plan for small stores.',
                'currency' => 'USD',
                'amount_cents' => 1900,
                'interval' => BillingInterval::Month,
                'interval_count' => 1,
                'trial_days' => 0,
                'setup_fee_cents' => 0,
                'limits' => ['cpu' => 1, 'memory_mb' => 1024, 'storage_gb' => 10],
                'requires_dedicated_server' => false,
                'is_active' => true,
                'sort_order' => 10,
            ],
        );

        Plan::updateOrCreate(
            ['slug' => 'growth-monthly'],
            [
                'name' => 'Growth',
                'description' => 'Shared server plan with higher limits.',
                'currency' => 'USD',
                'amount_cents' => 4900,
                'interval' => BillingInterval::Month,
                'interval_count' => 1,
                'trial_days' => 0,
                'setup_fee_cents' => 0,
                'limits' => ['cpu' => 2, 'memory_mb' => 2048, 'storage_gb' => 25],
                'requires_dedicated_server' => false,
                'is_active' => true,
                'sort_order' => 20,
            ],
        );

        Plan::updateOrCreate(
            ['slug' => 'enterprise-monthly'],
            [
                'name' => 'Enterprise',
                'description' => 'Dedicated server plan for high-resource customers.',
                'currency' => 'USD',
                'amount_cents' => 19900,
                'interval' => BillingInterval::Month,
                'interval_count' => 1,
                'trial_days' => 0,
                'setup_fee_cents' => 0,
                'limits' => ['cpu' => 4, 'memory_mb' => 8192, 'storage_gb' => 80],
                'requires_dedicated_server' => true,
                'is_active' => true,
                'sort_order' => 30,
            ],
        );
    }
}
