# n8n on Railway (queue mode)

[![Deploy on Railway](https://railway.com/button.svg)](https://railway.com/new/template/VmoGD3?utm_medium=integration&utm_source=button&utm_campaign=n8n)

A Railway template for [n8n](https://n8n.io), the workflow automation tool, running in queue mode:

| Service | Source | What it does |
|---|---|---|
| `n8n` | this repo, folder `n8n/` | Editor, REST API, webhook intake and scheduling. Public domain, volume at `/home/node/.n8n`, health check `/healthz/readiness` |
| `n8n-worker` | this repo, folder `n8n-worker/` | Runs workflow executions taken from the Redis queue. Health check `/healthz/readiness` |
| `Postgres` | Railway's Postgres | Workflows, credentials, executions, users |
| `Redis` | Railway's Redis | Bull queue between main and worker |

**Version:** n8n 2.47.5, `n8nio/n8n:2.47.5@sha256:e29e9cc965a16d07d989f115f729f8a1c7aff58688d4850247fa495d4d7aae2f` (pinned in both Dockerfiles).

## First login

The template creates the n8n owner account for you, so a new instance never shows a public "set up owner" page that a stranger could claim.

- **Email:** the address you enter at deploy time (`N8N_INSTANCE_OWNER_EMAIL`).
- **Password:** the generated `N8N_OWNER_PASSWORD` in the `n8n` service's Variables tab on Railway.

To change the password, change `N8N_OWNER_PASSWORD` and redeploy: the owner is managed by these variables, so the n8n UI won't change it. To manage the owner in the n8n UI instead, delete `N8N_OWNER_PASSWORD` (the account stays, with its last password) and redeploy.

## Variables

All but the owner email are set by the template.

| Service | Variable | Value |
|---|---|---|
| `n8n` | `N8N_INSTANCE_OWNER_EMAIL` | **You enter this at deploy time:** the owner's login email |
| `n8n` | `N8N_OWNER_PASSWORD` | `${{secret(24, …)}}`: the owner's password. The start script turns it into the bcrypt hash n8n needs and doesn't pass it on to n8n |
| `n8n` | `N8N_ENCRYPTION_KEY` | `${{secret(64, "abcdef0123456789")}}`: encrypts stored credentials. Keep it: losing it makes saved credentials unreadable |
| `n8n` | `N8N_HOST`, `WEBHOOK_URL`, `N8N_EDITOR_BASE_URL` | Built from `RAILWAY_PUBLIC_DOMAIN` |
| both | `DB_POSTGRESDB_HOST`, `_USER`, `_PASSWORD`, `_DATABASE` | References to the `Postgres` service |
| both | `QUEUE_BULL_REDIS_HOST`, `QUEUE_BULL_REDIS_PASSWORD` | References to the `Redis` service |
| `n8n-worker` | `N8N_ENCRYPTION_KEY` | `${{n8n.N8N_ENCRYPTION_KEY}}`: must match the main service |

Fixed settings (queue mode, Postgres, ports, proxy hops, telemetry off) are set as `ENV` in the Dockerfiles. Any service variable with the same name overrides them, so you can change them in Railway without forking. See n8n's [environment variable reference](https://docs.n8n.io/hosting/configuration/environment-variables/).

Each worker runs up to 10 executions at once. For more, add replicas to `n8n-worker` in Railway.

## Updates

This template builds from this repo's `main` branch. When a new n8n version is merged here, Railway shows "update available" on your deployed services, and you choose when to apply it. Read [CHANGELOG.md](CHANGELOG.md) first; n8n runs database migrations on start, so back up Postgres before major upgrades. Main and worker must always run the same version, so apply the update to both.

## Files

- `n8n/Dockerfile`, `n8n-worker/Dockerfile`: the pinned upstream image plus fixed settings
- `n8n/railway-start.sh`: hashes the owner password, hands the root-owned Railway volume to the `node` user, then starts n8n as `node` on `$PORT`
- `n8n-worker/railway-start.sh`: starts the worker with its health server on `$PORT`

There is no `railway.json`: Railway no longer reads it for new services. The health check (`/healthz/readiness` on both n8n services) and the restart policy (on failure, up to 10 retries) are part of the Railway template itself.
