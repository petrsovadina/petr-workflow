---
name: pw-spec
description: This skill should be used when the user says "/pw-spec", "napiš spec", "udělej INITIAL.md", "sepiš zadání feature" or wants to turn a feature idea into a spec with goals, non-goals, acceptance criteria and blockers before any code is written.
---

Zadání: $ARGUMENTS (když prázdné, vezmi ho z konverzace).

1. Nejdřív prozkoumej, co je k dispozici: repo nebo připojenou složku (CLAUDE.md, docs/adr, související kód, examples/), přiložené soubory, konverzaci. Neptej se na nic, co tam je.
2. Vytvoř nebo aktualizuj `INITIAL.md` podle šablony `references/INITIAL.md` v tomhle skillu:
   - Problém (realita, kdo to pocítí)
   - Cíl a měřitelný přínos
   - Non-goals
   - Akceptační kritéria (testovatelná)
   - Dotčené soubory a rozhraní
   - Dokumentace a příklady
   - Blokery a otevřené otázky + kdo je rozhodne
3. Bez repa nebo složky dej spec jako soubor nebo dokument v konverzaci.
4. Pokud existuje blokující otázka, která zneplatní půlku práce, zastav a polož ji. Jinak skonči shrnutím a doporučením `/pw-plan`.
