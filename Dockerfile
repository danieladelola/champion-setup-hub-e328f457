# Self-hosted (Coolify/Docker) build of the TanStack Start app.
# Builds a Node server bundle via nitro's node-server preset.
FROM oven/bun:1 AS build
WORKDIR /app

COPY package.json bun.lock* bunfig.toml ./
RUN bun install --frozen-lockfile || bun install

COPY . .
ENV NODE_ENV=production
ENV NITRO_PRESET=node-server
RUN bun run build

FROM node:22-alpine AS runtime
WORKDIR /app
ENV NODE_ENV=production
ENV PORT=3000
COPY --from=build /app/.output ./.output
EXPOSE 3000
CMD ["node", ".output/server/index.mjs"]
