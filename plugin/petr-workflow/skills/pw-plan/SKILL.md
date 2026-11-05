---
name: pw-plan
description: This skill should be used when the user says "/pw-plan", "udělej plán", "rozpadni to na kroky" or has a spec (INITIAL.md) and wants an implementation plan split into phases of at most 3–4 steps.
---

Spec: $ARGUMENTS (když prázdné, použij `INITIAL.md` nebo spec z konverzace).

1. Přečti spec a relevantní kód. Ověř, že blokery jsou vyřešené; když ne, skonči a vypiš je.
2. Napiš `PLAN.md`:
   - Fáze 1..N, každá max 3–4 kroky, každá končí ve stavu, který jde commitnout a otestovat
   - U každého kroku: soubory, co se mění, jak se ověří (test/příkaz)
   - Rizika a nevratné kroky označené ⚠️
   - Quick win první, pokud existuje
3. Rozhodnutí s dlouhodobým dopadem navrhni jako ADR (nepiš ho, jen vypiš).
4. Skonči: „Spustit fázi 1?" Nic neimplementuj bez potvrzení.
