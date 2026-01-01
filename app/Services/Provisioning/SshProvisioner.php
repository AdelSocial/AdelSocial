<?php

namespace App\Services\Provisioning;

use App\Models\Server;
use App\Models\Site;
use Illuminate\Support\Facades\Process;
use Illuminate\Support\Str;

class SshProvisioner
{
    /**
     * Provision a WordPress+WooCommerce site on a remote server via SSH.
     *
     * The remote server is expected to have the host-agent installed at:
     *   /opt/waas/bin/provision-site.sh
     */
    public function provisionSite(Server $server, Site $site): void
    {
        $target = sprintf('%s@%s', $server->ssh_user, $server->ssh_host);

        // Write a temporary key file if we have an encrypted private key stored.
        $keyPath = null;
        if ($server->ssh_private_key) {
            $keyPath = storage_path('app/private/ssh-keys/'.Str::uuid().'.pem');
            if (! is_dir(dirname($keyPath))) {
                mkdir(dirname($keyPath), 0700, true);
            }
            file_put_contents($keyPath, $server->ssh_private_key);
            chmod($keyPath, 0600);
        }

        $script = '/opt/waas/bin/provision-site.sh';

        $cmd = [
            'ssh',
            '-p', (string) $server->ssh_port,
            '-o', 'StrictHostKeyChecking=no',
        ];

        if ($keyPath) {
            $cmd[] = '-i';
            $cmd[] = $keyPath;
        }

        $cmd[] = $target;
        $cmd[] = $script.' '
            .'--site-id='.escapeshellarg((string) $site->id).' '
            .'--domain='.escapeshellarg($site->primary_domain).' '
            .'--wp-admin-user='.escapeshellarg((string) $site->wp_admin_user).' '
            .'--wp-admin-password='.escapeshellarg((string) $site->wp_admin_password).' '
            .'--wp-admin-email='.escapeshellarg((string) $site->wp_admin_email).' '
            .'--db-name='.escapeshellarg((string) $site->db_name).' '
            .'--db-user='.escapeshellarg((string) $site->db_user).' '
            .'--db-password='.escapeshellarg((string) $site->db_password);

        try {
            $result = Process::timeout(600)->run($cmd);
            if (! $result->successful()) {
                throw new \RuntimeException(trim($result->errorOutput() ?: $result->output()));
            }
        } finally {
            if ($keyPath && file_exists($keyPath)) {
                @unlink($keyPath);
            }
        }
    }
}

