---
class: task
id: add-missing-scoringrules-import.md
title: scoringRules is used but not declared in DESCRIPTION Imports
status: done
kind: issue
priority: high
touches:
- src:scoring.R
blocks:
- task:add-ci-r-cmd-check-workflow.md
---
Pre-existing. `R/scoring.R` calls `scoringRules::crps.numeric` and
`scoringRules::crps` (in `crps_fn_generator()`), but `scoringRules` is not
listed in `DESCRIPTION`'s `Imports`. `R CMD check` fails this as an error
("undeclared package"), which blocks any r-universe build.

Suggested fix: add `scoringRules` to `Imports` in `DESCRIPTION` and run
`loom`-adjacent `devtools::document()` / `Rscript -e devtools::check()` to
confirm.

