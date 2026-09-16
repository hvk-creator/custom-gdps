#!/bin/bash
set -e

# Disable all MPM modules at startup to purge duplicate loads
a2dismod mpm_event 2>/dev/null || true
a2dismod mpm_worker 2>/dev/null || true
a2dismod mpm_prefork 2>/dev/null || true

# Force enable ONLY prefork (required by mod_php)
a2enmod mpm_prefork

# Hand execution back to apache
exec "$@"
