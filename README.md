# petr-workflow

Plugin a kit pro Claude, se kterým pracuje stejně jako u Petra: nejdřív kontext a spec, potom plán po malých fázích, implementace s minimálním diffem, nezávislé review a zápis rozhodnutí. Funguje v **Claude Code** i v **Claude aplikaci** (desktop chat).

Verze 0.1.1 · licence Apache-2.0 · [CHANGELOG](CHANGELOG.md) · [ONBOARDING](ONBOARDING.md) pro první instalaci krok za krokem. Neobsahuje tokeny, klienty ani osobní data.

## Obsah

1. [Co dostaneš](#co-dostaneš)
2. [Požadavky](#požadavky)
3. [Stažení](#stažení)
4. [Instalace](#instalace)
5. [Ověření instalace](#ověření-instalace)
6. [Příkazy v Claude](#příkazy-v-claude)
7. [Aktualizace](#aktualizace)
8. [Odinstalace](#odinstalace)
9. [REA](#rea)
10. [Řešení problémů](#řešení-problémů)
11. [Co je kde](#co-je-kde)

## Co dostaneš

| Část | K čemu |
| --- | --- |
| Plugin `petr-workflow` | 7 skills: metoda `petr-workflow` a příkazy `/pw-spec`, `/pw-plan`, `/pw-implement`, `/pw-review`, `/pw-adr`, `/pw-handoff` |
| `claude/CLAUDE.md` | Globální pravidla: čeština s EN termíny, čtení volně, zápis ven jen s potvrzením, žádné secrets |
| `install.sh` | Zkopíruje skills a pravidla do `~/.claude`. S `--all` přidá pluginy, skill balíky a MCP |
| `setup/*.sh` | Skripty, které `install.sh --all` volá; jdou spustit i samostatně |
| `rea/` | Jak rozebrat hotovou appku přes REA a patterny, které z toho vyšly |

## Požadavky

| Co | Kdy | Ověříš |
| --- | --- | --- |
| Claude Code | instalace pro Claude Code | `claude --version` |
| Node.js + `npx` | `./install.sh --all` (skill balíky, REA) | `node --version` |
| Node.js 22.23.4+, 24.22.1+ nebo 26.12.1+ | REA | `node --version` |
| `git` s přístupem k repu | instalace přes marketplace (repo je soukromé) | `gh auth status` |

## Stažení

Repo `petrsovadina/petr-workflow` je soukromé. Release stáhneš, když k němu máš přístup:

```bash
gh release download v0.1.1 -R petrsovadina/petr-workflow
shasum -a 256 -c SHA256SUMS.txt
```

První příkaz stáhne tři soubory: `petr-workflow-0.1.1.zip` (celý kit), `petr-workflow.plugin` (plugin pro Claude aplikaci) a `SHA256SUMS.txt`. Druhý ověří, že se soubory při stažení nepoškodily; u obou má vypsat `OK`.

Bez přístupu k repu napiš Petrovi o pozvánku, nebo použij odkaz na stažení, který ti poslal.

## Instalace

Vyber **jednu** cestu. Kit i marketplace instalují stejné skills, takže kombinace obou by je načetla dvakrát.

### A. Claude Code: celý kit (doporučeno)

```bash
unzip petr-workflow-0.1.1.zip -d ~
cd ~/petr-workflow
./install.sh
```

`unzip … -d ~` vytvoří `~/petr-workflow`. `./install.sh` zkopíruje 7 skills do `~/.claude/skills/`, pravidla do `~/.claude/CLAUDE.petr.md` a na konec tvého `~/.claude/CLAUDE.md` přidá řádek `@~/.claude/CLAUDE.petr.md`. Tvůj stávající obsah zůstane.

Instalátor nic nepřepíše bez zálohy. Když skill nebo pravidla se stejným názvem už existují a liší se, přesune je do `~/.claude/backups/petr-kit-<datum-čas>/`. Opakované spuštění bez změn vypíše `beze změny`.

Pluginy, skill balíky a MCP navíc:

```bash
cd ~/petr-workflow
./install.sh --all
```

`--all` po základu spustí `setup/plugins.sh`, `setup/skills.sh` a `setup/mcp.sh`. Přidá marketplaces a pluginy (Context7, mattpocock-skills, Karpathy guidelines, skill-creator, claude-md-management, claude-code-setup, chrome-devtools-mcp), globálně nainstaluje balík `addyosmani/agent-skills` a zaregistruje MCP server REA. Když jedna položka selže, skript vypíše řádek začínající `!!` a pokračuje.

Volitelné balíky (claude-mem, n8n, caveman, sloptrim, hyperframes, marketing a další):

```bash
cd ~/petr-workflow
WITH_OPTIONAL=1 ./install.sh --all
```

Po instalaci restartuj Claude Code.

### B. Claude Code: jen plugin přes marketplace

```bash
claude plugin marketplace add petrsovadina/petr-workflow
claude plugin install petr-workflow@petr-workflow
```

První příkaz přidá repo jako marketplace, druhý z něj nainstaluje plugin. Dostaneš jen 7 skills, bez globálních pravidel a extra balíků. Potřebuješ přístup k repu.

### C. Claude aplikace (desktop chat)

1. Nahraj `petr-workflow.plugin` do konverzace a požádej Clauda o instalaci. Potvrď ji v náhledu. Tenhle krok zatím nebyl ověřený na čisté instalaci; když náhled s tlačítkem neuvidíš, použij cestu A.
2. Obsah `claude/CLAUDE.md` vlož do osobních preferencí v nastavení Clauda.
3. Volitelně REA, viz [REA](#rea).

V chatu bez připojené složky vracejí skills spec, plán, ADR i handoff jako soubory v konverzaci. S připojenou složkou pracují přímo v ní.

### Vyzkoušet bez instalace

```bash
claude --plugin-dir ~/petr-workflow/plugin/petr-workflow
```

Spustí Claude Code s pluginem načteným jen pro tuhle session. Do `~/.claude` nic nezapíše.

## Ověření instalace

Kit (cesta A):

```bash
ls ~/.claude/skills | grep -E '^(petr-workflow|pw-)'
grep -n 'CLAUDE.petr.md' ~/.claude/CLAUDE.md
```

První příkaz má vypsat 7 řádků: `petr-workflow`, `pw-adr`, `pw-handoff`, `pw-implement`, `pw-plan`, `pw-review`, `pw-spec`. Druhý ukáže řádek s importem pravidel.

Plugin přes marketplace (cesta B):

```bash
claude plugin details petr-workflow@petr-workflow
```

V části `Component inventory` musí být `Skills (7)`.

Po `--all`:

```bash
claude plugin list
claude mcp list
```

`claude plugin list` vypíše nainstalované pluginy se stavem `enabled`. `claude mcp list` u REA ukáže `Connected`.

Kontrola samotného pluginu ze složky kitu:

```bash
cd ~/petr-workflow
claude plugin validate plugin/petr-workflow/.claude-plugin/plugin.json
claude plugin validate .claude-plugin/marketplace.json
```

Obě kontroly mají skončit `Validation passed`. Varování o chybějící ikoně se týká jen veřejného adresáře pluginů.

## Příkazy v Claude

Píšeš je do Claude Code nebo do Claude aplikace. Text za příkazem je zadání.

| Příkaz | Zadání | Výsledek |
| --- | --- | --- |
| `/pw-spec <co chceš postavit>` | popis feature | `INITIAL.md`: problém, cíl, non-goals, akceptační kritéria, dotčené části, blokery. Při blokující otázce se zastaví a zeptá se. |
| `/pw-plan [cesta ke specu]` | bez zadání vezme `INITIAL.md` | `PLAN.md` ve fázích po nejvýš 3–4 krocích, rizika označená ⚠️. Skončí otázkou „Spustit fázi 1?" a nic neimplementuje. |
| `/pw-implement <číslo fáze>` | číslo fáze z `PLAN.md` | Změny jen z té fáze, testy po každém kroku, seznam souborů a návrh commit message. Necommitne sám. |
| `/pw-review [git rozsah]` | bez zadání `main...HEAD` | Tabulka nálezů: závažnost, soubor:řádek, problém, oprava. Ideálně ji udělá subagent bez kontextu implementace. |
| `/pw-adr <rozhodnutí>` | název rozhodnutí | `docs/adr/ADR-NNN-<slug>.md`: kontext, varianty, důsledky, reverzibilita. |
| `/pw-handoff` | nic | `HANDOFF.md`: stav, rozhodnutí, změněné soubory, TODO, další krok. |

Skill `petr-workflow` nespouštíš ručně. Claude si ho načte u netriviálních úkolů a drží se podle něj postupu.

Typický den:

```text
/pw-spec přidej export pacientů do CSV
/pw-plan
/pw-implement 1
/pw-review
/pw-adr volba knihovny pro CSV
/pw-handoff
```

Prefix `pw-` je schválně: Claude Code má vestavěné `/plan` a `/review`.

## Aktualizace

Kit (cesta A): stáhni nový release, rozbal ho přes starou složku a spusť instalátor znovu. Změněné skills se před přepsáním zálohují.

```bash
V=0.1.1   # číslo nové verze bez „v“, viz https://github.com/petrsovadina/petr-workflow/releases
gh release download "v$V" -R petrsovadina/petr-workflow
unzip -o "petr-workflow-$V.zip" -d ~
~/petr-workflow/install.sh
```

Plugin přes marketplace (cesta B):

```bash
claude plugin marketplace update petr-workflow
claude plugin update petr-workflow@petr-workflow
```

První příkaz stáhne aktuální stav marketplace z repa, druhý aktualizuje plugin. Po aktualizaci restartuj Claude Code.

## Odinstalace

Kit (cesta A). Soubory jdou do koše, ne do smazání:

```bash
mkdir -p ~/.Trash
mv ~/.claude/skills/petr-workflow ~/.claude/skills/pw-* ~/.Trash/
mv ~/.claude/CLAUDE.petr.md ~/.Trash/
perl -ni -e 'print unless m{^\@~/\.claude/CLAUDE\.petr\.md$}' ~/.claude/CLAUDE.md
```

První dva řádky přesunou skills a pravidla do koše. Poslední odstraní z `~/.claude/CLAUDE.md` jen řádek s importem, zbytek souboru zůstane. Původní verze přepsaných souborů najdeš v `~/.claude/backups/`.

Plugin přes marketplace (cesta B):

```bash
claude plugin uninstall petr-workflow@petr-workflow
claude plugin marketplace remove petr-workflow
```

Pluginy a MCP z `--all` odinstaluješ stejně přes `claude plugin uninstall <plugin>@<marketplace>` a `claude mcp remove <název>`.

## REA

[REA](https://rea.tools) rozebírá hotové aplikace a weby a ukazuje doklady. Postup a prompty jsou v [rea/PLAYBOOK.md](rea/PLAYBOOK.md).

Claude Code: `./install.sh --all` REA zaregistruje sám. Stav ověříš:

```bash
npx -y rea-agents@6.5.0 doctor --client claude_code --json
```

Claude aplikace: nejdřív plán bez změn, potom instalace.

```bash
npx -y rea-agents@6.5.0 setup --client claude_desktop --dry-run --json
npx -y rea-agents@6.5.0 setup --client claude_desktop --yes
```

První příkaz nic nemění a vypíše cesty, zálohy a změny. Druhý je provede. Pak restartuj Claude aplikaci.

Analýza Electron appky bez MCP, rovnou z terminálu:

```bash
npx -y rea-agents@6.5.0 analyze-javascript-application "/Applications/<App>.app/Contents/Resources/app.asar" --json > app.json
```

Výstup bývá stovky MB. Když REA ohlásí `artifact_integrity_mismatch`, přidej `--integrity-policy record-and-continue`.

## Řešení problémů

| Příznak | Co udělat |
| --- | --- |
| `/pw-spec` se nenabízí | Ověř instalaci (viz [Ověření instalace](#ověření-instalace)) a restartuj Claude Code. |
| Skills se načítají dvakrát | Máš kit i plugin z marketplace. Jeden z nich odinstaluj. |
| `install.sh` vypíše řádek s `!!` | Jedna položka selhala, ostatní prošly. Spusť příkaz z toho řádku ručně a uvidíš chybu. `./install.sh --all` jde pustit znovu. |
| `claude plugin marketplace add` selže | Nemáš přístup k soukromému repu, nebo `git` není přihlášený. Ověř `gh auth status`. |
| `shasum -c` nevypíše `OK` | Soubor se nestáhl celý. Stáhni ho znovu. |
| REA: `artifact_integrity_mismatch` | Zopakuj s `--integrity-policy record-and-continue`. Dotčené bajty se pak berou jako nedůvěryhodné. |
| REA: `resource_constraint` | Výsledek je na REA moc velký (například ChatGPT, Spark). Analyzuj menší část appky. |

## Co je kde

| Cesta | Obsah |
| --- | --- |
| `plugin/petr-workflow/` | Zdroj pluginu, stejný pro Claude Code i Claude aplikaci |
| `claude/CLAUDE.md` | Globální pravidla |
| `install.sh` | Instalátor kitu |
| `setup/plugins.sh`, `setup/skills.sh`, `setup/mcp.sh` | Pluginy, skill balíky a MCP pro `--all` |
| `.claude-plugin/marketplace.json` | Marketplace pro `claude plugin marketplace add` |
| `ONBOARDING.md` | První instalace a první úloha krok za krokem |
| `rea/PLAYBOOK.md`, `rea/AGENT-APP-PATTERNS.md` | REA postup a patterny z agentních appek |
| `.github/workflows/ci.yml` | Kontrola pluginu, marketplace a instalace při každém pushi |
| `CHANGELOG.md`, `LICENSE`, `NOTICE` | Verze a licence Apache-2.0 |
