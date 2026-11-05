# petr-workflow

Plugin pro Claude Code a Claude aplikaci se 7 skills. Vede práci postupem implementation-first: nejdřív kontext a spec, potom plán po malých fázích, implementace s minimálním diffem, nezávislé review a zápis rozhodnutí.

| Skill | Co dělá |
| --- | --- |
| `petr-workflow` | Metoda a standardy. Načte se sám u netriviálních úkolů. |
| `/pw-spec` | Ze zadání udělá `INITIAL.md`: problém, cíl, non-goals, akceptační kritéria, blokery. |
| `/pw-plan` | Ze specu udělá `PLAN.md` ve fázích po nejvýš 3–4 krocích. |
| `/pw-implement` | Implementuje jednu fázi s minimálním diffem a testy po každém kroku. |
| `/pw-review` | Review změn proti specu, ideálně subagentem bez kontextu implementace. |
| `/pw-adr` | Zapíše architektonické rozhodnutí do `docs/adr/`. |
| `/pw-handoff` | Sepíše `HANDOFF.md` pro pokračování v jiné session. |

## Instalace

```bash
claude plugin marketplace add petrsovadina/petr-workflow
claude plugin install petr-workflow@petr-workflow
```

Repo je soukromé, potřebuješ k němu přístup na GitHubu.

Prefix `pw-` brání kolizi s vestavěnými příkazy Claude Code `/plan` a `/review`.

Instalace, první úloha a řešení problémů: [ONBOARDING.md](https://github.com/petrsovadina/petr-workflow/blob/main/ONBOARDING.md).

Licence: Apache-2.0.
