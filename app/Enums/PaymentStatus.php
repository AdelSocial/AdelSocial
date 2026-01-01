<?php

namespace App\Enums;

enum PaymentStatus: string
{
    case RequiresAction = 'requires_action';
    case Succeeded = 'succeeded';
    case Failed = 'failed';
}

