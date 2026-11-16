---
class: task
id: duplicate-dheur-bib-entry.md
title: refs.bib has two entries for Dheur & Ben Taieb (2023)
status: todo
kind: paperFix
priority: low
touches:
- paper:refs.bib
---
Pre-existing: `vignettes/main/refs.bib` contains both `Dheur_Ben Taieb_2023` and `Dheur_Taieb_2023` for the same ICML 2023 paper. The former also has a space in its cite key.

Suggested fix: keep `Dheur_Taieb_2023` (the key [reference:dheur-2023-probabilistic-calibration-study.md](../reference/dheur-2023-probabilistic-calibration-study.md) records), drop the other, and update any citation in `paper:main.tex`.