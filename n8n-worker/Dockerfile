# n8n queue-mode worker: runs workflow executions taken from Redis.
# Keep this pin identical to n8n/Dockerfile: main and worker must run the same version.
FROM n8nio/n8n:2.47.7@sha256:b4b90747b81fcda7e76550c0d3aa7f0f64917a1e9573cff40d6834eaf2e0f8ea

ENV DB_TYPE=postgresdb \
    DB_POSTGRESDB_PORT=5432 \
    EXECUTIONS_MODE=queue \
    QUEUE_BULL_REDIS_PORT=6379 \
    QUEUE_BULL_REDIS_DUALSTACK=true \
    QUEUE_HEALTH_CHECK_ACTIVE=true \
    N8N_DIAGNOSTICS_ENABLED=false \
    N8N_ENFORCE_SETTINGS_FILE_PERMISSIONS=true

COPY --chmod=755 railway-start.sh /railway-start.sh
ENTRYPOINT ["tini", "--", "/railway-start.sh"]
