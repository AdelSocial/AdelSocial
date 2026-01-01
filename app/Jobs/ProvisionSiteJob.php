<?php

namespace App\Jobs;

use App\Enums\SiteStatus;
use App\Models\Order;
use App\Models\Site;
use App\Services\Provisioning\ServerPlacementService;
use App\Services\Provisioning\SshProvisioner;
use Illuminate\Bus\Queueable;
use Illuminate\Contracts\Queue\ShouldQueue;
use Illuminate\Foundation\Bus\Dispatchable;
use Illuminate\Queue\InteractsWithQueue;
use Illuminate\Queue\SerializesModels;
use Illuminate\Support\Facades\DB;
use Illuminate\Support\Str;

class ProvisionSiteJob implements ShouldQueue
{
    use Dispatchable, InteractsWithQueue, Queueable, SerializesModels;

    public function __construct(
        public readonly int $orderId,
    ) {
    }

    public function handle(ServerPlacementService $placement, SshProvisioner $provisioner): void
    {
        /** @var Order $order */
        $order = Order::query()->with(['user', 'plan'])->findOrFail($this->orderId);

        /** @var Site $site */
        $site = DB::transaction(function () use ($order, $placement) {
            $existing = Site::query()->where('order_id', $order->id)->first();

            if (! $existing) {
                $domain = $order->domain_name ?: ('store-'.$order->id.'.example.test');

                $existing = Site::create([
                    'user_id' => $order->user_id,
                    'order_id' => $order->id,
                    'subscription_id' => null,
                    'plan_id' => $order->plan_id,
                    'server_id' => null,
                    'primary_domain' => $domain,
                    'status' => SiteStatus::Provisioning,
                    'wp_admin_user' => 'admin',
                    'wp_admin_password' => Str::password(16),
                    'wp_admin_email' => $order->user->email,
                    'db_name' => 'wp_'.$order->id,
                    'db_user' => 'wp_'.$order->id,
                    'db_password' => Str::password(24),
                ]);
            }

            if (! $existing->server_id) {
                $server = $placement->selectServerForPlan($order->plan);
                $existing->server()->associate($server);
                $existing->save();
            }

            return $existing;
        });

        $server = $site->server()->firstOrFail();

        // Remote provisioning (host-agent)
        $provisioner->provisionSite($server, $site);

        $site->forceFill([
            'status' => SiteStatus::Active,
            'provisioned_at' => now(),
            'stack_path' => "/opt/waas/sites/{$site->id}",
            'container_name' => "waas-site-{$site->id}",
        ])->save();
    }
}

