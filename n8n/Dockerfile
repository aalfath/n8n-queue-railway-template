# n8n main process: editor, REST API, webhook intake and scheduling (queue mode).
# Pinned by version and digest. Bump both together and add a CHANGELOG.md entry.
FROM n8nio/n8n:2.47.7@sha256:b4b90747b81fcda7e76550c0d3aa7f0f64917a1e9573cff40d6834eaf2e0f8ea

# Fixed settings live here, not in template variables: Railway's template
# generator drops literal variable values. Template variables still override these.
ENV DB_TYPE=postgresdb \
    DB_POSTGRESDB_PORT=5432 \
    EXECUTIONS_MODE=queue \
    OFFLOAD_MANUAL_EXECUTIONS_TO_WORKERS=true \
    QUEUE_BULL_REDIS_PORT=6379 \
    QUEUE_BULL_REDIS_DUALSTACK=true \
    QUEUE_HEALTH_CHECK_ACTIVE=true \
    N8N_PROTOCOL=https \
    N8N_PROXY_HOPS=1 \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true \
    N8N_USER_FOLDER=/home/node

# Start as root only to hand the Railway volume (mounted root-owned) to the
# node user; railway-start.sh then runs n8n as node (uid 1000).
USER root
COPY --chmod=755 railway-start.sh /railway-start.sh
ENTRYPOINT ["tini", "--", "/railway-start.sh"]
