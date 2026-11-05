#!/usr/bin/env bash
# Claude Code pluginy podle Petrova setupu (stav 29. 10. 2026).
# Alternativa: v Claude Code spusť /plugin a přidej marketplace + plugin ručně.
set -euo pipefail

add_mp() { claude plugin marketplace add "$1" || echo "!! marketplace $1 se nepřidal"; }
inst()   { claude plugin install "$1" || echo "!! plugin $1 se nenainstaloval"; }

echo "== Marketplaces"
add_mp anthropics/claude-plugins-official
add_mp forrestchang/andrej-karpathy-skills
add_mp n8n-io/skills
add_mp ChromeDevTools/chrome-devtools-mcp
add_mp thedotmack/claude-mem

echo "== CORE: doporučuju všem"
inst context7@claude-plugins-official            # aktuální dokumentace knihoven
inst skill-creator@claude-plugins-official       # stavba vlastních skills
inst claude-md-management@claude-plugins-official
inst claude-code-setup@claude-plugins-official
inst mattpocock-skills@claude-plugins-official   # TDD, spec, refactor workflow
inst andrej-karpathy-skills@karpathy-skills      # disciplína pro AI kód
inst chrome-devtools-mcp@chrome-devtools-plugins # debug webu z agenta

if [[ "${WITH_OPTIONAL:-0}" == "1" ]]; then
  echo "== OPTIONAL"
  add_mp JuliusBrussee/caveman
  add_mp seyedehsanhadi/sloptrim
  add_mp typesafe-ai/skills
  add_mp devdotfast/whiteboard
  add_mp heygen-com/hyperframes
  inst claude-mem@thedotmack                     # paměť napříč sessions
  inst n8n-skills@n8n-io                         # n8n workflow + MCP
  inst mcp-server-dev@claude-plugins-official    # psaní MCP serverů
  inst plugin-dev@claude-plugins-official
  inst vercel@claude-plugins-official
  inst caveman@caveman                           # úsporné odpovědi, méně tokenů
  inst sloptrim@sloptrim                         # čištění AI slopu z textů
  inst typesafe@typesafe-ai
  inst whiteboard@devfast
  inst hyperframes@hyperframes                   # video/motion z kódu
fi
echo "Hotovo. Restartuj Claude Code."
