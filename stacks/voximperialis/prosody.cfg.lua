-- Prosody configuration for vox.rootplane.dev

admins = {}

-- Network
interfaces = { "*" }

-- Modules
modules_enabled = {
    "roster";
    "saslauth";
    "tls";
    "dialback";
    "disco";
    "posix";
    "ping";
    "register";
    "admin_shell";
    "cron";
}

-- TLS: Prosody handles STARTTLS with self-signed cert
-- Generate cert: prosodyctl cert generate vox.rootplane.dev
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

-- Virtual host
VirtualHost "vox.rootplane.dev"
