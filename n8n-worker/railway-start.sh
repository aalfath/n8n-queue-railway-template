#!/bin/sh
# Wrapper for the n8n worker service on Railway.
set -e

# The worker's health server (/healthz, /healthz/readiness) listens on the
# port Railway health-checks.
export QUEUE_HEALTH_CHECK_PORT="${PORT:-5678}"

# Fallbacks in case a database variable resolves empty.
export DB_POSTGRESDB_USER="${DB_POSTGRESDB_USER:-postgres}"
export DB_POSTGRESDB_DATABASE="${DB_POSTGRESDB_DATABASE:-railway}"

exec /docker-entrypoint.sh worker "$@"
