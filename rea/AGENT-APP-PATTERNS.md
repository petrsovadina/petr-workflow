# Patterny z agentních appek (analýza přes REA)

Petr kolem Claude Code používá několik desktop appek, které agenty orchestrují, hlídají a schvalují. REA (`rea-agents@6.5.0`, `analyze-javascript-application`) je rozebral staticky z jejich `app.asar`. Pod každým patternem je, co z něj máš převzít do vlastního setupu, i bez té appky.

Analýza 29. 10. 2026, jen čtení, nic se nespouštělo.

| Appka | Parsované JS soubory | IPC operace | Co dělá |
| --- | --- | --- | --- |
| Orca | 3 746 | 1 914 | Orchestrace víc agentů ve worktrees, hooks, gates, Linear/Jira |
| CodeBurn | 401 | 181 | Kvóty a spotřeba napříč agenty (Claude, Codex, Gemini, Kimi, Copilot…) |
| OpenMausBot | 351 | 307 | Agent bot se schvalovacími režimy |
| Agent Orchestrator | — | — | REA odmítl kvůli nesouladu ASAR integrity u nativního modulu; jde rozebrat s `--integrity-policy record-and-continue` |

## 1. Každý agent ve vlastním git worktree (Orca)

**Doklad:** moduly `cli/handlers/worktree.js`, `worktree-create-agent-launch.js`, `worktree-lineage-summary.js`, `worktree-linear-issue-link.js`, `worktree-removal-warnings.js`.

**Pattern:** agent nikdy nepracuje v hlavním checkoutu. Dostane worktree navázaný na issue (Linear/Jira), má vlastní větev a lineage, a při odstranění worktree se kontroluje neuložená práce.

**Převezmi:**
```bash
git worktree add ../repo-feat-123 -b feat/123-csv-export
cd ../repo-feat-123 && claude      # paralelní agent, žádné kolize
git worktree remove ../repo-feat-123   # až po merge
```
Claude Code to umí i nativně: `claude --worktree <název>` (s `--tmux` rovnou v novém panelu).

## 2. Koordinátor + gates = human-in-the-loop (Orca)

**Doklad:** `cli/handlers/orchestration/gate-handlers.js`: `gate-create` (task, question, options), `gate-resolve`, `gate-list`. Komentář v kódu: gates jsou vázané na run a jediný oprávněný volající je koordinátor.

**Pattern:** workeři neřeší sporná rozhodnutí sami. Vytvoří gate s otázkou a možnostmi a čekají. Rozhoduje koordinátor (člověk nebo hlavní agent). Doplňují to mailbox mezi workery (`message-send`, `message-inbox`) a keepalive.

**Převezmi:** v `PLAN.md` označ kroky ⚠️ jako gate. Agent u nich zastaví a nabídne varianty. Přesně to dělá `/pw-plan` z tohohle kitu („Spustit fázi 1?").

## 3. Hook bridge: eventy agenta do lokální služby (Orca)

**Doklad:** `~/.orca/agent-hooks/claude-hook.sh` (+ `codex-`, `gemini-`, `kimi-hook.sh`), registrovaný na `SessionStart`, `UserPromptSubmit`, `PreToolUse`, `PostToolUse`, `Stop`, `SubagentStart/Stop`, `PostCompact` a další. Modul `agent-hook-scrub-safe-env`.

**Pattern:**
- Hook vždy hned vrátí `{}`, takže nikdy neblokuje agenta.
- Payload posílá `curl` na `127.0.0.1:<port>/hook/claude` s tokenem v hlavičce a timeouty 0,5 s / 1,5 s.
- Když služba neběží, ukládá eventy do spool souboru (`chmod 600`, limit 5 MB, rotace po 7 dnech).
- Do hooku jde jen whitelist env proměnných (scrub), žádné secrets.

**Převezmi** jako minimální vzor (`~/.claude/settings.json`):
```json
{ "hooks": { "Stop": [ { "hooks": [ { "type": "command",
  "command": "osascript -e 'display notification \"Agent hotový\" with title \"Claude Code\"'" } ] } ] } }
```
Pravidla: hook neblokuje, má timeout, neloguje secrets a selže potichu.

## 4. Spotřeba a kvóty napříč agenty (CodeBurn)

**Doklad:** `dist/electron/quota/claude.js`, `codex.js`, `gemini.js`, `kimi.js`, `copilot.js`, `grokbot.js`, `zcode.js`; `claude.js` čte lokální OAuth credentials a volá Anthropic usage endpoint. Menubar a CLI `serve`.

**Pattern:** jeden přehled limitů pro všechny agenty, v menubaru. Rozhodnutí, kterého agenta pustit na úlohu, padá podle zbývající kvóty.

**Převezmi:** v Claude Code `/usage`. Když používáš víc agentů, jeden menubar přehled ušetří přepínání.

## 5. Schvalovací režimy místo „vše/nic" (OpenMausBot)

**Doklad:** `electron/approval-trusted-mode.cjs`: režimy `ask`, `edits`, `auto`, `full`, `custom`; požadavek se validuje (UUID request id, bot id regex), změna režimu prochází kroky request → confirmation → activation → commit → finalization a dá se omezit na vlákno nebo bota.

**Pattern:** důvěra se zvyšuje postupně a lokálně (jedno vlákno, jeden bot), ne globálně. Přechod na vyšší autonomii má explicitní potvrzení.

**Převezmi** v Claude Code: `permissions.allow` jen pro čtecí a bezpečné příkazy, `ask` pro zápis ven (deploy, mail, push) a auto mode jen v sandboxu nebo worktree. Nikdy `skipDangerousModePermissionPrompt` na hlavním stroji s produkčními klíči.

## 6. Architektonické otisky appek, ve kterých Petr tráví nejvíc času

Druhé kolo analýzy (1. 11. 2026) mířilo na appky s nejvíc hodinami v Rize (12. 7. – 19. 10. 2026). Spuštěno s `--integrity-policy record-and-continue`, protože podepsané nativní moduly hlásí nesoulad integrity (Claude Desktop 8×, Notion 4×). Čísla jsou počty, které REA v kódu našel. Kód se tu necituje.

| Appka | Hodin v Rize | Okna | IPC operace (pojmenované / dynamické) | Ověření odesílatele | Utility procesy |
| --- | --- | --- | --- | --- | --- |
| Claude Desktop | 165,7 | 14 | 1 626 (10 / 1 615) | 73 | 4 |
| OpenMausBot | 61,3 | 4 | 307 (210 / 2) | 9 | 2 |
| Notion | 39,0 | 15 | 60 (7 / 47) | 5 | 2 |
| CodeBurn | 2,0 | 1 | 181 (89 / 2) | 0 | 0 |
| Orca | 1,3 | 6 | 1 914 (1 069 / 67) | 22 | 0 |

Spark Desktop a ChatGPT REA nedokončil (`resource_constraint`: vyčerpaná kapacita výsledku). Arc, Omi a Raycast jsou nativní appky; na ty je potřeba Ghidra, Hopper nebo IDA.

**Co z toho čtu:**

- **Claude Desktop** posílá skoro celé IPC přes dynamicky skládané kanály, což odpovídá generované RPC vrstvě, a na 73 místech ověřuje odesílatele. Podle názvů modulů běží MCP servery v odděleném runtime (`mcp-runtime/nodeHost`, `directMcpHost`), těžká práce ve workerech (terminál, hledání v historii, shell path) a lokální spuštění má vlastní okno pro souhlas (`local_exec_consent`).
- **Notion** je hlavně web v tenkém obalu: jen 60 IPC operací, ale 284 členů API vystavených do stránky a preload `sqlite_browser` pro lokální cache.
- **Orca** má 1 069 ručně pojmenovaných kanálů; orchestrace žije v desktopové části.
- **CodeBurn:** REA nenašel žádné ověření odesílatele. To neznamená, že tam není, ani že je appka zranitelná.

**Převezmi pro vlastní agenty a nástroje:**

1. Nástroje a MCP servery pouštěj mimo hlavní proces. Když spadnou, UI běží dál.
2. Každé volání do privilegované vrstvy ověř: kdo volá a odkud.
3. Lokální spuštění příkazu jen přes explicitní souhlas.
4. Když logika žije na serveru, stačí tenký desktop a lokálně jen cache.

## 7. Nástroj, jehož údržba blokuje práci, letí ven

**Doklad:** Rize (hodiny týdně) + Hindsight (datované záznamy o opravách).

- OpenClaw: 31,5 h v appce a 13,9 h údržby mimo ni (terminál, prohlížeč) mezi 18. 8. a 27. 9. 2026. Opravy gateway, tokenů, plaintext secrets, záloh, pluginů a aktualizací.
- 13. 9. nastavený asistent v OpenMausBotu. Od té doby 6–15 h týdně, OpenClaw spadl na nulu.

**Převezmi:** nový agentní nástroj dostane pár týdnů. Měř čas v něm a čas jeho údržby (Rize, WakaTime nebo jen poznámky). OpenClaw si vzal na údržbu skoro třetinu času (13,9 z 45 h). Když údržba bere takový kus nebo blokuje práci, nástroj odinstaluj.

## Shrnutí pro tvůj setup

1. Paralelní práce = worktree na agenta.
2. Sporné rozhodnutí = gate, ne tichá volba agenta.
3. Hooks jsou neblokující, s timeoutem a bez secrets.
4. Sleduj kvóty a vybírej agenta podle nich.
5. Autonomii zvyšuj po krocích a lokálně.
6. Nástroje a MCP mimo hlavní proces, ověřený volající, lokální spuštění se souhlasem.
7. Měř údržbu nástrojů; co jí bere velký kus času nebo blokuje práci, letí ven.
