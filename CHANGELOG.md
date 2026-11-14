# Changelog

Breaking changes are listed first in each entry. n8n runs database migrations on start: back up Postgres before applying an update, and update `n8n` and `n8n-worker` together.

## 2.47.5 (2026-11-12)

- First version of this repo-based template: n8n 2.47.5 (`n8nio/n8n:2.47.5@sha256:e29e9cc965a16d07d989f115f729f8a1c7aff58688d4850247fa495d4d7aae2f`) in queue mode with a separate worker, Railway Postgres and Redis.
- The owner account comes from `N8N_INSTANCE_OWNER_EMAIL` and the generated `N8N_OWNER_PASSWORD`, so there is no public owner-setup page on a fresh instance.
- Health check `/healthz/readiness` and restart policy (on failure, 10 retries) on both `n8n` and `n8n-worker` are set on the Railway template; the repo has no `railway.json`.
- Upstream release notes: https://github.com/n8n-io/n8n/releases/tag/n8n%402.47.5
