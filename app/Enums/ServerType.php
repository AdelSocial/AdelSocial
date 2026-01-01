<?php

namespace App\Enums;

enum ServerType: string
{
    case Shared = 'shared';
    case Dedicated = 'dedicated';
}

