---
name: pw-review
description: This skill should be used when the user says "/pw-review", "zreviewuj změny", "nezávislé review" or wants changes checked against the spec by a reviewer without the implementation context.
---

Rozsah: $ARGUMENTS (když prázdné, `git diff main...HEAD`; bez gitu změněné soubory z konverzace).

Když je k dispozici subagent (Agent tool), spusť ho bez kontextu implementace a dej mu jen diff, `INITIAL.md` a `PLAN.md`. Jinak udělej review sám a ber kód, jako bys ho viděl poprvé.

Kontroluj:
1. Splňuje změna akceptační kritéria ze specu? Co chybí?
2. Bugy, edge cases, error handling, bezpečnost (secrets, injection, authz).
3. Scope creep a zbytečná složitost.
4. Chybějící testy.

Vrať tabulku: závažnost (blocker/major/minor) · soubor:řádek · problém · návrh opravy.
Blockery oprav až po potvrzení.
