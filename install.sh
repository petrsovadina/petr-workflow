#!/usr/bin/env bash
# Instalace Petrova workflow do ~/.claude. Nic nepřepisuje bez zálohy.
#   ./install.sh                 jen workflow (7 skills z pluginu + globální pravidla)
#   ./install.sh --all           + pluginy, skill balíky a MCP (core)
#   WITH_OPTIONAL=1 ./install.sh --all   + volitelné balíky
set -euo pipefail
KIT="$(cd "$(dirname "$0")" && pwd)"
DEST="${CLAUDE_HOME:-$HOME/.claude}"
STAMP="$(date +%Y%m%d-%H%M%S)"
mkdir -p "$DEST/skills"

BACKUP="$DEST/backups/petr-kit-$STAMP"
copy_safe() { # $1 src, $2 dst — zálohy mimo skills/commands, aby se nenačítaly dvakrát
  if [[ -e "$2" ]]; then
    if diff -rq "$1" "$2" >/dev/null 2>&1; then echo "  = $2 (beze změny)"; return; fi
    mkdir -p "$BACKUP"; mv "$2" "$BACKUP/"; echo "  záloha: $BACKUP/$(basename "$2")"
  fi
  cp -R "$1" "$2"; echo "  + $2"
}

echo "== Skills z pluginu petr-workflow (/pw-spec /pw-plan /pw-implement /pw-review /pw-adr /pw-handoff)"
for d in "$KIT"/plugin/petr-workflow/skills/*/; do copy_safe "${d%/}" "$DEST/skills/$(basename "$d")"; done

echo "== Globální pravidla"
copy_safe "$KIT/claude/CLAUDE.md" "$DEST/CLAUDE.petr.md"
touch "$DEST/CLAUDE.md"
grep -q "@~/.claude/CLAUDE.petr.md" "$DEST/CLAUDE.md" || printf '\n@~/.claude/CLAUDE.petr.md\n' >> "$DEST/CLAUDE.md"
echo "  import @~/.claude/CLAUDE.petr.md je v $DEST/CLAUDE.md (tvoje pravidla zůstala)"

if [[ "${1:-}" == "--all" ]]; then
  command -v claude >/dev/null || { echo "!! Chybí Claude Code CLI (příkaz claude). Nainstaluj ho a spusť znovu."; exit 1; }
  bash "$KIT/setup/plugins.sh"
  bash "$KIT/setup/skills.sh"
  bash "$KIT/setup/mcp.sh"
fi

echo
echo "Hotovo. Restartuj Claude Code a zkus v libovolném repu: /pw-spec <co chceš postavit>"
