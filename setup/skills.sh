#!/usr/bin/env bash
# Skill balíky, které Petr používá (instalace přes skills CLI: github.com/vercel-labs/skills).
# Každý balík se nainstaluje do ~/.claude/skills a Claude si skill načte sám, když úloha sedí.
set -euo pipefail
# -g = globálně (bez něj skončí v aktuálním projektu), -y = bez interaktivních dotazů
add() { npx -y skills add "$1" -g -y || echo "!! $1 se nenainstaloval"; }

echo "== CORE (inženýrský workflow)"
add addyosmani/agent-skills   # spec-driven, incremental implementation, TDD, code review, ADR
# mattpocock skills jdou přes plugin v plugins.sh

if [[ "${WITH_OPTIONAL:-0}" == "1" ]]; then
  echo "== OPTIONAL"
  add Leonxlnx/taste-skill      # frontend design taste
  add coreyhaines31/marketingskills   # marketing, SEO, copy, launch
  # n8n a caveman jdou přes plugins.sh, aby se skills nenačítaly dvakrát
fi
