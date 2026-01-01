<?php

namespace App\Enums;

enum SiteStatus: string
{
    case Provisioning = 'provisioning';
    case Active = 'active';
    case Suspended = 'suspended';
    case Failed = 'failed';
    case Deleted = 'deleted';
}

