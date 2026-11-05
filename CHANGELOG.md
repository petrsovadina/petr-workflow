# Changelog

## Neuvolněno

- README, Aktualizace: verze je v proměnné `V`, tag se skládá jako `v$V`. Dřív placeholder `<nová-verze>` vedl na `gh release download 0.1.1`, které tag `v0.1.1` nenajde.

## 0.1.1 – 2026-11-05

- README přepsané jako příručka: stažení a ověření releasu, tři cesty instalace, ověření, všechny příkazy `/pw-*`, aktualizace, odinstalace do koše, REA a řešení problémů. Každý blok příkazů otestovaný v čisté domovské složce.
- ONBOARDING: instalace rozbaluje do `~` a bloky s `--all` začínají `cd ~/petr-workflow`, stejně jako README.
- REA všude pinnutý na `rea-agents@6.5.0` (PLAYBOOK, `setup/mcp.sh`).

## 0.1.0 – 2026-11-05

První release.

- Plugin `petr-workflow` se 7 skills: `petr-workflow`, `/pw-spec`, `/pw-plan`, `/pw-implement`, `/pw-review`, `/pw-adr`, `/pw-handoff`.
- Marketplace pro Claude Code: `claude plugin marketplace add petrsovadina/petr-workflow`.
- `install.sh`: skills a globální pravidla do `~/.claude` se zálohou; `--all` přidá pluginy, skill balíky a MCP (REA).
- Dokumentace: `ONBOARDING.md`, `README.md`, REA playbook a patterny z agentních aplikací.
- CI: validace pluginu a marketplace, test instalace v čisté domovské složce.
