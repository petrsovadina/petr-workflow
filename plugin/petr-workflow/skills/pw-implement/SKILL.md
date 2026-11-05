---
name: pw-implement
description: This skill should be used when the user says "/pw-implement", "implementuj fázi", "udělej fázi 1" or wants one phase of PLAN.md implemented with a minimal diff and verification.
---

Implementuj fázi $ARGUMENTS z `PLAN.md`.

- Drž se jen kroků té fáze. Co navíc najdeš, zapiš do `PLAN.md` jako poznámku, neopravuj.
- Před změnou knihovního API si ověř aktuální dokumentaci (Context7, když je k dispozici).
- Minimální diff, styl podle existujícího kódu a `examples/`.
- Po každém kroku spusť relevantní testy/linter/typecheck. Neprojde → oprav, než půjdeš dál.
- Na konci: seznam změněných souborů, výsledek testů, co zbývá, návrh commit message. Necommituj bez potvrzení.
