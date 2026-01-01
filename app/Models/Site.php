<?php

namespace App\Models;

use App\Enums\SiteStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;

class Site extends Model
{
    protected $fillable = [
        'user_id',
        'order_id',
        'subscription_id',
        'plan_id',
        'server_id',
        'primary_domain',
        'status',
        'wp_admin_user',
        'wp_admin_password',
        'wp_admin_email',
        'db_name',
        'db_user',
        'db_password',
        'stack_path',
        'container_name',
        'provisioned_at',
        'suspended_at',
        'deleted_at',
        'failed_reason',
    ];

    protected $casts = [
        'status' => SiteStatus::class,
        'wp_admin_password' => 'encrypted',
        'db_password' => 'encrypted',
        'provisioned_at' => 'datetime',
        'suspended_at' => 'datetime',
        'deleted_at' => 'datetime',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    public function subscription(): BelongsTo
    {
        return $this->belongsTo(Subscription::class);
    }

    public function plan(): BelongsTo
    {
        return $this->belongsTo(Plan::class);
    }

    public function server(): BelongsTo
    {
        return $this->belongsTo(Server::class);
    }
}
