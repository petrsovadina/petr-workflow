#!/usr/bin/env bash
# MCP servery pro Claude Code (scope user = dostupné ve všech projektech).
# Tokeny nikdy do repa. Doplň je jen lokálně přes env proměnné.
set -euo pipefail

echo "== CORE"
# Context7 (dokumentace knihoven) jde přes plugin v plugins.sh

# REA — reverse engineering appek, webů a binárek (https://rea.tools)
# Doporučený oficiální setup, ukáže plán a zeptá se na schválení:
#   npx rea-agents@latest setup
# Nebo ruční registrace pinnuté verze:
claude mcp add --scope user rea -- npx -y rea-agents@6.5.0 mcp || true

echo "== OPTIONAL (odkomentuj, co potřebuješ)"
# n8n (automatizace) — vyžaduje vlastní n8n instanci
# claude mcp add --scope user n8n-mcp --env N8N_API_URL=https://<tvoje-n8n> --env N8N_API_KEY=$N8N_API_KEY -- npx -y n8n-mcp

# Coolify (self-hosted PaaS) — deploye a logy z chatu
# claude mcp add --scope user --transport http coolify https://<tvoje-coolify>/mcp --header "Authorization: Bearer $COOLIFY_TOKEN"

# Hindsight — paměť pro agenty (retain/recall/reflect)
# viz https://github.com/vectorize-io/hindsight

claude mcp list
