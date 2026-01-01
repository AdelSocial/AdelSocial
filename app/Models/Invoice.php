<?php

namespace App\Models;

use App\Enums\InvoiceStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphMany;

class Invoice extends Model
{
    protected $fillable = [
        'user_id',
        'subscription_id',
        'order_id',
        'number',
        'status',
        'currency',
        'amount_due_cents',
        'amount_paid_cents',
        'period_start',
        'period_end',
        'due_at',
        'paid_at',
        'attempt_count',
        'next_attempt_at',
        'metadata',
    ];

    protected $casts = [
        'status' => InvoiceStatus::class,
        'amount_due_cents' => 'integer',
        'amount_paid_cents' => 'integer',
        'period_start' => 'datetime',
        'period_end' => 'datetime',
        'due_at' => 'datetime',
        'paid_at' => 'datetime',
        'attempt_count' => 'integer',
        'next_attempt_at' => 'datetime',
        'metadata' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function subscription(): BelongsTo
    {
        return $this->belongsTo(Subscription::class);
    }

    public function order(): BelongsTo
    {
        return $this->belongsTo(Order::class);
    }

    public function payments(): MorphMany
    {
        return $this->morphMany(Payment::class, 'payable');
    }
}
