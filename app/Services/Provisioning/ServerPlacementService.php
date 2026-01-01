<?php

namespace App\Services\Provisioning;

use App\Enums\ServerType;
use App\Models\Plan;
use App\Models\Server;

class ServerPlacementService
{
    public function selectServerForPlan(Plan $plan): Server
    {
        $type = $plan->requires_dedicated_server ? ServerType::Dedicated : ServerType::Shared;

        $server = Server::query()
            ->where('is_active', true)
            ->where('type', $type->value)
            ->whereColumn('active_sites_count', '<', 'max_sites')
            ->orderBy('active_sites_count')
            ->orderBy('id')
            ->first();

        if (! $server) {
            throw new \RuntimeException("No available {$type->value} servers for plan {$plan->slug}.");
        }

        return $server;
    }
}

