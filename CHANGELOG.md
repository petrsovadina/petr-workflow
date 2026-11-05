# Changelog

## 0.1.0 – 2026-11-05

První release.

- Plugin `petr-workflow` se 7 skills: `petr-workflow`, `/pw-spec`, `/pw-plan`, `/pw-implement`, `/pw-review`, `/pw-adr`, `/pw-handoff`.
- Marketplace pro Claude Code: `claude plugin marketplace add petrsovadina/petr-workflow`.
- `install.sh`: skills a globální pravidla do `~/.claude` se zálohou; `--all` přidá pluginy, skill balíky a MCP (REA).
- Dokumentace: `ONBOARDING.md`, `README.md`, REA playbook a patterny z agentních aplikací.
- CI: validace pluginu a marketplace, test instalace v čisté domovské složce.
