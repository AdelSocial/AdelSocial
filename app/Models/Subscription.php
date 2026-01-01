<?php

namespace App\Models;

use App\Enums\SubscriptionStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Subscription extends Model
{
    protected $fillable = [
        'user_id',
        'plan_id',
        'status',
        'auto_renew',
        'current_period_start',
        'current_period_end',
        'renew_at',
        'cancelled_at',
        'suspended_at',
        'gateway',
        'gateway_customer_id',
        'gateway_subscription_id',
        'metadata',
    ];

    protected $casts = [
        'status' => SubscriptionStatus::class,
        'auto_renew' => 'boolean',
        'current_period_start' => 'datetime',
        'current_period_end' => 'datetime',
        'renew_at' => 'datetime',
        'cancelled_at' => 'datetime',
        'suspended_at' => 'datetime',
        'metadata' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    public function invoices(): HasMany
    {
        return $this->hasMany(Invoice::class);
    }
}
