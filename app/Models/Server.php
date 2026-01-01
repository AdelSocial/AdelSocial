<?php

namespace App\Models;

use App\Enums\ServerType;
use Illuminate\Database\Eloquent\Model;
use Illuminate\Database\Eloquent\Relations\HasMany;

class Server extends Model
{
    protected $fillable = [
        'name',
        'type',
        'provider',
        'region',
        'ssh_host',
        'ssh_port',
        'ssh_user',
        'ssh_private_key',
        'traefik_enabled',
        'letsencrypt_email',
        'docker_network',
        'shared_db_enabled',
        'shared_db_host',
        'shared_db_root_password',
        'max_sites',
        'active_sites_count',
        'is_active',
        'last_heartbeat_at',
    ];

    protected $casts = [
        'type' => ServerType::class,
        'ssh_port' => 'integer',
        'ssh_private_key' => 'encrypted',
        'traefik_enabled' => 'boolean',
        'shared_db_enabled' => 'boolean',
        'shared_db_root_password' => 'encrypted',
        'max_sites' => 'integer',
        'active_sites_count' => 'integer',
        'is_active' => 'boolean',
        'last_heartbeat_at' => 'datetime',
    ];

    public function sites(): HasMany
    {
        return $this->hasMany(Site::class);
    }
}
