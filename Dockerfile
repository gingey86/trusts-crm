# Bootstrap image contract; application/schemas/scripts are not implemented yet.
# Configure Next output: 'standalone' during implementation. Build must not
# connect to production databases or require production secrets.
# Runtime/package-manager versions are initial candidates; align them with
# the tested manifest and generated lockfile during implementation.
FROM node:24-bookworm-slim AS base
RUN apt-get update && apt-get install -y --no-install-recommends openssl ca-certificates \
    && rm -rf /var/lib/apt/lists/*
RUN corepack enable && corepack prepare pnpm@10.18.3 --activate
ENV NEXT_TELEMETRY_DISABLED=1
WORKDIR /app

FROM base AS dependencies
# Generated only by normal installation; absence intentionally blocks a
# supposedly reproducible image until pnpm install has completed.
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile

FROM dependencies AS build
COPY . .
RUN pnpm db:generate
RUN pnpm build

FROM build AS operator
# One-use CLI only, no HTTP listener. scripts manage private volume ownership.
# PostgreSQL elevated privileges come from operator environment, not runtime.
CMD ["pnpm", "db:migrate"]

FROM base AS runtime
ENV NODE_ENV=production
ENV NEXT_TELEMETRY_DISABLED=1
COPY --from=build --chown=node:node /app/.next/standalone ./
COPY --from=build --chown=node:node /app/.next/static ./.next/static
# Ensure implementation creates public/ even when no public assets are needed.
COPY --from=build --chown=node:node /app/public ./public
USER node
CMD ["node", "server.js"]
