# Changelog

Breaking changes are listed first in each entry. n8n runs database migrations on start: back up Postgres before applying an update, and update `n8n` and `n8n-worker` together.

## Unreleased (2026-11-16)

- README: Deploy on Railway button for the published template `n8n-11`. No change to the n8n services.

## 2.47.7 (2026-11-16)

- n8n 2.47.5 → 2.47.7 (`n8nio/n8n:2.47.7@sha256:b4b90747b81fcda7e76550c0d3aa7f0f64917a1e9573cff40d6834eaf2e0f8ea`), patch releases. Release notes: https://github.com/n8n-io/n8n/releases/tag/n8n%402.47.7 and https://github.com/n8n-io/n8n/releases/tag/n8n%402.47.6
- Removed `n8n/railway.json` and `n8n-worker/railway.json`. Railway stops reading `railway.json` on 2026-12-01; the health check and restart policy now live in the template's service settings. Nothing changes for running deployments.

## 2.47.5 (2026-11-12)

- First version of this repo-based template: n8n 2.47.5 (`n8nio/n8n:2.47.5@sha256:e29e9cc965a16d07d989f115f729f8a1c7aff58688d4850247fa495d4d7aae2f`) in queue mode with a separate worker, Railway Postgres and Redis.
- The owner account comes from `N8N_INSTANCE_OWNER_EMAIL` and the generated `N8N_OWNER_PASSWORD`, so there is no public owner-setup page on a fresh instance.
- Upstream release notes: https://github.com/n8n-io/n8n/releases/tag/n8n%402.47.5
