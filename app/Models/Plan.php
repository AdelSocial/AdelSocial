<?php

namespace App\Models;

use App\Enums\BillingInterval;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;
use Illuminate\Database\Eloquent\SoftDeletes;

class Plan extends Model
{
    use SoftDeletes;

    protected $fillable = [
        'name',
        'slug',
        'description',
        'currency',
        'amount_cents',
        'interval',
        'interval_count',
        'trial_days',
        'setup_fee_cents',
        'limits',
        'requires_dedicated_server',
        'is_active',
        'sort_order',
    ];

    protected $casts = [
        'amount_cents' => 'integer',
        'interval' => BillingInterval::class,
        'interval_count' => 'integer',
        'trial_days' => 'integer',
        'setup_fee_cents' => 'integer',
        'limits' => 'array',
        'requires_dedicated_server' => 'boolean',
        'is_active' => 'boolean',
        'sort_order' => 'integer',
        'deleted_at' => 'datetime',
    ];

    public function subscriptions(): HasMany
    {
        return $this->hasMany(Subscription::class);
    }

    public function orders(): HasMany
    {
        return $this->hasMany(Order::class);
    }
}
