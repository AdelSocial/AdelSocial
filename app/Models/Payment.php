<?php

namespace App\Models;

use App\Enums\PaymentStatus;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\BelongsTo;
use Illuminate\Database\Eloquent\Relations\MorphTo;

class Payment extends Model
{
    protected $fillable = [
        'user_id',
        'payable_type',
        'payable_id',
        'gateway',
        'status',
        'currency',
        'amount_cents',
        'gateway_payment_id',
        'gateway_payment_intent_id',
        'failure_code',
        'failure_message',
        'raw_response',
    ];

    protected $casts = [
        'status' => PaymentStatus::class,
        'amount_cents' => 'integer',
        'raw_response' => 'array',
    ];

    public function user(): BelongsTo
    {
        return $this->belongsTo(User::class);
    }

    public function payable(): MorphTo
    {
        return $this->morphTo();
    }
}
