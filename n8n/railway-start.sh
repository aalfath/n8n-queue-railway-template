#!/bin/sh
# Wrapper for the n8n main service on Railway.
set -e

# Listen on the port Railway routes the public domain to.
export N8N_PORT="${PORT:-5678}"

# Fallbacks in case a database variable resolves empty.
export DB_POSTGRESDB_USER="${DB_POSTGRESDB_USER:-postgres}"
export DB_POSTGRESDB_DATABASE="${DB_POSTGRESDB_DATABASE:-railway}"

# Owner account from variables, so a fresh instance never shows a public
# "set up owner" page that the first visitor could claim. n8n wants a bcrypt
# hash, which Railway can't generate, so hash the generated password here.
# Remove N8N_OWNER_PASSWORD (or set N8N_INSTANCE_OWNER_MANAGED_BY_ENV=false)
# to manage the owner in the n8n UI instead.
if [ -n "${N8N_INSTANCE_OWNER_EMAIL:-}" ] && [ -n "${N8N_OWNER_PASSWORD:-}" ] \
   && [ -z "${N8N_INSTANCE_OWNER_MANAGED_BY_ENV:-}" ]; then
  export N8N_INSTANCE_OWNER_MANAGED_BY_ENV=true
  export N8N_INSTANCE_OWNER_FIRST_NAME="${N8N_INSTANCE_OWNER_FIRST_NAME:-Instance}"
  export N8N_INSTANCE_OWNER_LAST_NAME="${N8N_INSTANCE_OWNER_LAST_NAME:-Owner}"
  N8N_INSTANCE_OWNER_PASSWORD_HASH="$(node -e 'process.stdout.write(require("/usr/local/lib/node_modules/n8n/node_modules/bcryptjs").hashSync(process.env.N8N_OWNER_PASSWORD, 10))')"
  export N8N_INSTANCE_OWNER_PASSWORD_HASH
fi
unset N8N_OWNER_PASSWORD

# The volume at /home/node/.n8n is mounted root-owned: give it to node.
data="${N8N_USER_FOLDER:-/home/node}/.n8n"
mkdir -p "$data"
rm -rf "$data/lost+found"
chown -R node:node "$data"

exec su node -s /bin/sh -c 'exec /docker-entrypoint.sh "$@"' -- n8n "$@"
