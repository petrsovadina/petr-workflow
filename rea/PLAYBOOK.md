# REA playbook

[REA](https://rea.tools) (Reverse Engineer Anything) je MCP server a CLI, se kterým agent rozebere hotový software, ukáže doklady a postaví podobnou funkci. Tak vznikl i `AGENT-APP-PATTERNS.md`.

Používej ho jen na software, který vlastníš nebo smíš zkoumat (výzkum, interoperabilita, vzdělávání). Licenční podmínky cílové appky platí dál.

## Instalace

```bash
npx -y rea-agents@6.5.0 setup   # ukáže plán, po schválení zaregistruje MCP + skill
# restartuj Claude Code, ověř: /mcp → rea
```
Static analýza JS/Electron a .NET nepotřebuje žádný engine. Na nativní binárky potřebuješ Ghidru, Hopper, IDA nebo Kuna.

## Workflow: jedna otázka → doklady → přestavba

1. **Zeptej se na jednu funkci**, ne na celou appku.
2. **REA prozkoumá** cíl (staticky, případně za běhu) a vrátí Evidence s limity.
3. **Agent vysvětlí nebo postaví** vlastní verzi a otestuje ji proti originálu.

## Prompty, které fungují

```
Use REA to inspect /Applications/<App>.app. How does it hook into Claude Code?
Show the evidence (module paths), then write a minimal hook for my setup.

Use REA to analyze the Electron app at <path>. List IPC channels that touch the filesystem
and which of them validate the sender.

Use REA to inspect https://<my-test-app>. Record listing, creating and deleting items
and build an RL environment from it.
```

## CLI bez MCP

```bash
npx -y rea-agents@6.5.0 analyze-javascript-application \
  "/Applications/<App>.app/Contents/Resources/app.asar" --json > app.json
# výstup bývá 200–300 MB: čti summary, statistics a semantic_graph.nodes
# podle kind (child-process, config-source, boundary, module)
```

Když selže integrita ASAR (podepsané nativní moduly), opakuj s
`--integrity-policy record-and-continue`. Bajty se pak berou jako nedůvěryhodné.

## Tipy

- Výstup je obrovský. Nech agenta napsat malý extraktor (Python) na `summary` a uzly podle `kind`.
- Názvy modulů (`module` uzly) často řeknou architekturu rychleji než kód.
- Ke klíčovým modulům se vrať přímo: `npx @electron/asar extract app.asar src`.
- Každé tvrzení drž u dokladu (cesta modulu). Co REA nepotvrdil, označ jako odhad.
