# Onboarding: Petrův Claude kit

Tenhle návod tě provede instalací a první úlohou. Na konci budeš mít v Claude stejný pracovní postup jako Petr: spec → plán → implementace → review, s rozhodnutími zapsanými do ADR.

Postup má dvě varianty: **Claude Code** (terminál, práce v repu) a **Claude aplikace** (desktop chat). Můžeš nainstalovat obě, obsah je stejný.

## 1. Co budeš potřebovat

- Rozbalený `petr-workflow-0.1.0.zip` z [releasu](https://github.com/petrsovadina/petr-workflow/releases), nebo přístup k repu `petrsovadina/petr-workflow`.
- Pro Claude Code: nainstalovaný Claude Code. Ověříš ho příkazem `claude --version`.
- Pro `./install.sh --all`: Node.js a `npx`. Skripty přes ně instalují skill balíky a REA.
- Pro REA: Node.js 22.x od verze 22.23.4, 24.x od verze 24.22.1, nebo 26.12.1 a novější.
- Pro Claude aplikaci: soubor `petr-workflow.plugin` z [releasu](https://github.com/petrsovadina/petr-workflow/releases).

## 2. Kterou variantu zvolit

| Potřebuješ | Claude Code | Claude aplikace |
| --- | --- | --- |
| Psát a upravovat kód v repu | ano | jen s připojenou složkou |
| Skills `/pw-*` a metoda `petr-workflow` | ano | ano |
| Pluginy a skill balíky ze `setup/` | ano | ne, skripty jsou pro Claude Code |
| MCP přes `setup/mcp.sh` | ano | ne; REA má vlastní setup pro aplikaci (krok 4.3) |
| Spec, plán a ADR bez repa | ano | ano, jako soubory v konverzaci |

## 3. Instalace: Claude Code

### 3.0 Rychlý start: nech to udělat Clauda

Rozbal zip a vlož do Claude Code tenhle prompt. Claude spustí kroky z 3.1 a ověří výsledek:

```text
Rozbal petr-workflow-0.1.0.zip do domovské složky (vznikne ~/petr-workflow), přečti ONBOARDING.md a spusť ./install.sh. Ukaž mi výstup, ověř, že ~/.claude/skills obsahuje 7 skills (petr-workflow a pw-*), a navrhni první úlohu pro /pw-spec v mém aktuálním repu.
```

Claude se před spuštěním skriptu zeptá na povolení, pokud to tvoje nastavení vyžaduje.

### 3.1 Základ

```bash
cd petr-workflow
./install.sh
```

Skript udělá tři věci:

1. Zkopíruje 7 skills do `~/.claude/skills/`: `petr-workflow`, `pw-spec`, `pw-plan`, `pw-implement`, `pw-review`, `pw-adr`, `pw-handoff`.
2. Uloží globální pravidla do `~/.claude/CLAUDE.petr.md`.
3. Na konec tvého `~/.claude/CLAUDE.md` přidá řádek `@~/.claude/CLAUDE.petr.md`. Tvůj stávající obsah zůstane.

Když skill se stejným názvem už existuje a liší se, skript ho nejdřív přesune do `~/.claude/backups/petr-kit-<datum-čas>/`. Opakované spuštění bez změn nic nepřepíše a vypíše `beze změny`.

**Kontrola:** `ls ~/.claude/skills` vypíše všech 7 názvů. Restartuj Claude Code.

### 3.2 Pluginy, skill balíky a MCP (volitelné)

```bash
./install.sh --all
```

Kromě základu spustí:

- `setup/plugins.sh`: přidá marketplaces a nainstaluje pluginy přes `claude plugin install`, např. Context7, mattpocock-skills, andrej-karpathy-skills, skill-creator a chrome-devtools-mcp.
- `setup/skills.sh`: globálně nainstaluje balík `addyosmani/agent-skills` přes `npx skills add -g -y`.
- `setup/mcp.sh`: zaregistruje MCP server REA pro všechny projekty (`--scope user`) a vypíše `claude mcp list`.

Volitelné balíky (n8n, marketing, video, caveman a další) přidáš takhle:

```bash
WITH_OPTIONAL=1 ./install.sh --all
```

Když některý plugin nebo balík selže, skript vypíše řádek začínající `!!` a pokračuje dál. Viz [Řešení problémů](#7-řešení-problémů).

**Kontrola:** `claude plugin marketplace list` a `claude mcp list` ukážou nové položky. Restartuj Claude Code.

### 3.3 Alternativa: jen plugin přes marketplace

Když chceš jen 7 skills bez globálních pravidel a extra balíků, nainstaluj plugin přímo z repa:

```bash
claude plugin marketplace add petrsovadina/petr-workflow
claude plugin install petr-workflow@petr-workflow
```

Repo je soukromé, takže potřebuješ k němu přístup na GitHubu a přihlášený `git` (třeba přes `gh auth login`). Aktualizace pak stáhneš přes `claude plugin update petr-workflow@petr-workflow`.

Nekombinuj to s `./install.sh`: oba způsoby instalují stejné skills, takže by se načítaly dvakrát.

## 4. Instalace: Claude aplikace

### 4.1 Plugin

1. Otevři konverzaci v Claude aplikaci a nahraj do ní `petr-workflow.plugin` z releasu.
2. Požádej Clauda o instalaci pluginu. Plugin se má zobrazit jako náhled s tlačítkem pro přijetí.
3. Potvrď instalaci.

> Tenhle postup nebyl na čisté instalaci ověřený. Když náhled s tlačítkem neuvidíš, napiš Petrovi. Mezitím můžeš použít variantu Claude Code.

### 4.2 Globální pravidla

Zkopíruj obsah `claude/CLAUDE.md` do osobních preferencí v nastavení Claude aplikace. Pravidla určují jazyk odpovědí, postup práce a co Claude smí udělat bez potvrzení.

### 4.3 REA (volitelné)

REA je nástroj pro analýzu hotových aplikací. Popis je v `rea/PLAYBOOK.md`.

```bash
npx -y rea-agents@6.5.0 setup --client claude_desktop --dry-run --json
```

Příkaz nic nemění. Vypíše cesty, zálohy a změny, které setup provede. Když s plánem souhlasíš, spusť:

```bash
npx -y rea-agents@6.5.0 setup --client claude_desktop --yes
```

Setup zaregistruje MCP server a obvykle nainstaluje i odpovídající REA skill. Potom restartuj Claude aplikaci.

## 5. První úloha

Projdi celý postup na malé úloze, u které nevadí, když se rozbije. Příklad níže používá testovací repo s endpointem `/health`. Použij svoje vlastní.

| Krok | Napiš | Výsledek |
| --- | --- | --- |
| 1 | `/pw-spec přidej endpoint /health, který vrací stav aplikace` | `INITIAL.md` s problémem, cílem, non-goals, akceptačními kritérii a blokery |
| 2 | `/pw-plan` | `PLAN.md` ve fázích po nejvýš 3–4 krocích; Claude se zeptá „Spustit fázi 1?" |
| 3 | `/pw-implement 1` | Změny jen z fáze 1, výsledek testů, návrh commit message. Claude sám necommitne. |
| 4 | `/pw-review` | Tabulka nálezů: závažnost, soubor:řádek, problém, návrh opravy |
| 5 | `/pw-adr <rozhodnutí z úlohy>` | `docs/adr/ADR-NNN-<slug>.md` |
| 6 | `/pw-handoff` | `HANDOFF.md` pro pokračování v nové session |

Když `/pw-spec` najde blokující otázku, zastaví se a položí ji, místo aby psal plán. To je záměr: neřešené otázky jako datový model by zneplatnily půlku práce.

V Claude aplikaci bez připojené složky vrátí každý krok soubor v konverzaci. `/pw-implement` a `/pw-review` dávají smysl hlavně tam, kde Claude vidí kód.

## 6. První týden

1. **CLAUDE.md pro projekt.** V repu spusť v Claude Code `/init` a doplň výsledek podle šablony `plugin/petr-workflow/skills/petr-workflow/references/PROJECT-CLAUDE.md`: stack, příkazy, architektura, konvence, zákazy.
2. **Příklady.** Ulož 2–3 reprezentativní soubory do `examples/`. `/pw-implement` podle nich drží styl kódu.
3. **Rozhodnutí.** Každou volbu knihovny, datového modelu nebo architektury zapiš přes `/pw-adr`.
4. **Vlastní skill.** Postup, který opakuješ, nech zabalit přes `skill-creator` (plugin z `setup/plugins.sh`).

## 7. Řešení problémů

### `/pw-spec` nebo jiný skill se nenabízí

- **Claude Code:** zkontroluj `ls ~/.claude/skills` a restartuj Claude Code.
- **Claude aplikace:** ověř, že je plugin `petr-workflow` nainstalovaný.

### Proč `/pw-review` a ne `/review`

Claude Code má vestavěné příkazy `/review` a `/plan`. Prefix `pw-` brání kolizi.

### Skript vypsal řádek s `!!`

Instalace jednoho pluginu, marketplace nebo balíku selhala, ostatní pokračovaly. Spusť příkaz z daného řádku ručně a uvidíš chybu. `install.sh --all` je možné spustit znovu.

### Skill balíky skončily v projektu místo globálně

`setup/skills.sh` instaluje s `-g`, tedy globálně. Pokud jsi balík instaloval ručně příkazem `npx skills add` bez `-g`, skončil v aktuálním projektu. Odstraň ho přes `npx skills remove` a nainstaluj znovu s `-g`.

### REA hlásí `artifact_integrity_mismatch`

Hash nativního modulu v ASAR archivu nesouhlasí s deklarovanou hodnotou. U podepsaných aplikací se to stává. Analýzu můžeš zopakovat s `--integrity-policy record-and-continue`. Dotčené bajty se pak považují za nedůvěryhodné.

## 8. Odinstalace (Claude Code)

1. Přesuň do koše složky `petr-workflow` a `pw-*` z `~/.claude/skills/`.
2. Z `~/.claude/CLAUDE.md` odstraň řádek `@~/.claude/CLAUDE.petr.md` a přesuň do koše `~/.claude/CLAUDE.petr.md`.
3. Původní verze přepsaných skills najdeš v `~/.claude/backups/petr-kit-<datum-čas>/`.

Plugin nainstalovaný přes marketplace odinstaluješ příkazem `claude plugin uninstall petr-workflow@petr-workflow`. Ostatní pluginy odinstaluješ přes `claude plugin`, MCP servery přes `claude mcp`.

## 9. Kde najdeš další informace

| Soubor | Obsah |
| --- | --- |
| `README.md` | Přehled kitu a obsah jednotlivých částí |
| `claude/CLAUDE.md` | Globální pravidla |
| `plugin/petr-workflow/skills/` | Zdrojové soubory všech skills |
| `rea/PLAYBOOK.md` | Jak analyzovat hotovou aplikaci přes REA |
| `rea/AGENT-APP-PATTERNS.md` | Patterny z agentních aplikací a jak je převzít |
