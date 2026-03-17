-- Prosody configuration for vox.rootplane.dev

admins = {}

-- Network
interfaces = { "*" }

-- Modules
modules_enabled = {
    "roster";
    "saslauth";
    -- "tls";  -- TLS terminated at Traefik
    "dialback";
    "disco";
    "posix";
    "ping";
    "register";
    "admin_shell";
    "cron";
}

-- Allow plaintext connections (internal Docker network)
c2s_require_encryption = false
s2s_require_encryption = false
allow_unencrypted_plain_auth = true

-- Authentication
authentication = "internal_hashed"

-- Storage
storage = "internal"
data_path = "/var/lib/prosody"

-- PID file (required for prosodyctl status)
pidfile = "/var/run/prosody/prosody.pid"

-- Logging
log = {
    info = "*console";
}

-- TLS is terminated at Traefik (port 5223 Direct TLS)
-- Prosody receives plain TCP from Traefik and internal clients

-- Virtual host
VirtualHost "vox.rootplane.dev"
