<?php

namespace App\Support;

use App\Models\Invoice;
use Illuminate\Support\Str;

class InvoiceNumberGenerator
{
    public static function generate(): string
    {
        // Human-friendly, sortable-ish invoice number.
        // Example: INV-20260101-AB12CD34
        return 'INV-'.now()->format('Ymd').'-'.Str::upper(Str::random(8));
    }

    public static function generateUnique(): string
    {
        do {
            $number = self::generate();
        } while (Invoice::query()->where('number', $number)->exists());

        return $number;
    }
}

