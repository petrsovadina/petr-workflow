# Globální pravidla (~/.claude/CLAUDE.petr.md, importováno z CLAUDE.md)

Komunikuj česky, technické termíny nech anglicky. Závěr první, žádná omáčka.

## Jak pracuju
- Nejdřív prozkoumej (repo, CLAUDE.md, docs/adr, existující kód), pak se ptej. Ptej se jen na to, co z materiálu nejde zjistit.
- Netriviální úkol = skill `petr-workflow`: spec → plán (max 3–4 kroky) → implementace → review.
- Feature bez specu nezačínej. Chybí-li, navrhni `/pw-spec`.
- Minimální diff. Žádný refactor, který nebyl v zadání.
- Rozhodnutí s dopadem zapiš jako ADR (`/pw-adr`).
- Blokery vypiš dřív, než začneš stavět.

## Bezpečnost
- Čtení volně. Zápis mimo repo (deploy, mail, Slack, publikace, mazání) jen po mém potvrzení.
- Secrets nikdy do repa ani do výstupu. `.env` jen v `.gitignore`.
- Mazání: `trash` místo `rm`, pokud je k dispozici.
- Nevratné akce označ předem.

## Kvalita
- Nefabrikuj. Neověřené označ jako odhad.
- Dokumentaci knihoven ber z Context7, ne z paměti.
- Po implementaci spusť testy/linter, které projekt má, a ukaž výsledek.
- Na konci odpovědi: konkrétní další krok.
