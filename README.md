# petr-workflow

Balíček, se kterým Claude pracuje stejně jako u Petra: stejná metoda, stejné příkazy, stejné pluginy a MCP. Funguje v **Claude Code** i v **Claude aplikaci** (desktop chat). Vznikl rozborem Petrova skutečného `~/.claude` (29. 10. 2026) a analýzou jeho agentních appek přes [REA](https://rea.tools).

Verze 0.1.0 · licence Apache-2.0 · [CHANGELOG](CHANGELOG.md). Neobsahuje tokeny, klienty ani osobní data.

**Začni tady:** [ONBOARDING.md](ONBOARDING.md) tě provede instalací a první úlohou.

## Jádro: plugin `petr-workflow`

Jeden plugin, 7 skills:

| Skill | Co dělá |
| --- | --- |
| `petr-workflow` | Metoda a standardy: kontext před otázkami, max 3–4 kroky, rozhodovací pořadí, výstup bez omáčky. Načte se sám u netriviálních úkolů. |
| `/pw-spec` | Ze zadání udělá INITIAL.md: problém, cíl, non-goals, akceptační kritéria, blokery |
| `/pw-plan` | Ze specu PLAN.md ve fázích po max 3–4 krocích |
| `/pw-implement` | Jedna fáze, minimální diff, testy po každém kroku |
| `/pw-review` | Review proti specu, ideálně subagentem bez kontextu implementace |
| `/pw-adr` | Zapíše architektonické rozhodnutí |
| `/pw-handoff` | HANDOFF.md pro pokračování v jiné session nebo appce |

Prefix `pw-` je schválně: Claude Code má vestavěné `/review` a `/plan`.

## Instalace: Claude aplikace (desktop chat)

1. Stáhni `petr-workflow.plugin` z [releasu](https://github.com/petrsovadina/petr-workflow/releases), nahraj ho do chatu a potvrď instalaci tlačítkem v náhledu.
2. Do osobních preferencí v nastavení Clauda vlož obsah `claude/CLAUDE.md`. To jsou globální pravidla (čeština, zápis ven jen s potvrzením, žádné secrets).
3. Volitelně REA (Node.js 22.23.4+): `npx -y rea-agents@6.5.0 setup --client claude_desktop --dry-run --json` ukáže plán. Když s ním souhlasíš, spusť `npx -y rea-agents@6.5.0 setup --client claude_desktop --yes` a restartuj aplikaci.

V chatu bez připojené složky skills vrací spec, plán, ADR i handoff jako soubory v konverzaci. S připojenou složkou nebo repem pracují přímo v ní.

## Instalace: Claude Code

```bash
unzip petr-workflow-0.1.0.zip && cd petr-workflow
./install.sh                         # skills z pluginu + globální pravidla
./install.sh --all                   # + pluginy, skill balíky, MCP (core)
WITH_OPTIONAL=1 ./install.sh --all   # + volitelné (n8n, marketing, video, caveman…)
```

Potřebuješ Claude Code (ověříš `claude --version`) a pro `--all` Node.js s `npx`. Instalátor nic nepřepíše bez zálohy (do `~/.claude/backups/`) a tvoje `CLAUDE.md` jen doplní o import.

Jen plugin bez pravidel a extra balíků (repo je soukromé, potřebuješ k němu přístup):

```bash
claude plugin marketplace add petrsovadina/petr-workflow
claude plugin install petr-workflow@petr-workflow
```

Nekombinuj s `./install.sh`, skills by se načítaly dvakrát.

## Co je kde

| Část | K čemu |
| --- | --- |
| `plugin/petr-workflow/` | Zdroj pluginu (pro obě prostředí) |
| `claude/CLAUDE.md` | Globální pravidla: Claude Code je importuje, do aplikace je vlož do preferencí |
| `setup/plugins.sh` | Claude Code pluginy: Context7, mattpocock, Karpathy, skill-creator, chrome-devtools… |
| `setup/skills.sh` | Skill balíky: addyosmani/agent-skills (+ volitelné) |
| `setup/mcp.sh` | MCP pro Claude Code: REA (+ šablony pro n8n, Coolify, Hindsight) |
| `rea/PLAYBOOK.md` | Jak rozebrat cizí appku a postavit podobnou funkci |
| `rea/AGENT-APP-PATTERNS.md` | Co REA našel v agentních appkách a v Claude Desktop, Notion |
| `.claude-plugin/marketplace.json` | Marketplace pro `claude plugin marketplace add` |
| `CHANGELOG.md` | Co se změnilo v jednotlivých verzích |
| `LICENSE`, `NOTICE` | Apache-2.0 |

## Denní flow

```
/pw-spec přidej export pacientů do CSV   → INITIAL.md + blokery
/pw-plan                                 → PLAN.md ve fázích
/pw-implement 1                          → minimální diff + testy
/pw-review                               → review proti specu
/pw-adr volba knihovny pro CSV           → zapsané rozhodnutí
/pw-handoff                              → HANDOFF.md pro další session
```

## Pravidla, která dělají rozdíl

1. Spec před kódem. Bez INITIAL.md agent hádá.
2. Kontext žije v repu: CLAUDE.md, `examples/`, `docs/adr/`.
3. Co děláš podruhé, je skill (`skill-creator`).
4. MCP místo copy-paste.
5. Čtení volně, zápis ven s potvrzením.
6. Druhý model nebo subagent na review.
7. Secrets nikdy do chatu ani repa.

## Další krok

Po týdnu používání nech Clauda přes `skill-creator` zabalit tvůj nejčastější postup do vlastního skillu. Tak to vzniklo i u Petra.
