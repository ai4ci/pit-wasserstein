---
class: task
id: rename-unadjusted-metric-to-b-pit.md
title: Rename the unadjusted metric to B_pit across code, tests, vignettes and paper
status: done
kind: feature
priority: high
touches:
- src:scoring.R
---
Agreed with the user 2026-11-17 as part of the three-metric family framing.

The original supplementary material used $U_{pit}$ for the unadjusted metric
and $U^*_{pit}$ for the adjusted one. The star was dropped in the code because
it is awkward to type, which left the adjusted metric called `U_pit` and the
unadjusted one called `U_pit_unadj` — a long, negatively-defined name for what
is now a first-class member of the family with its own null hypothesis and its
own significance test.

Agreed naming:

| Name | Was | Null hypothesis |
|---|---|---|
| `B_pit` | the old unadjusted column / $U_{pit}$ | fully probabilistically calibrated |
| `D_pit` | `D_pit` / $D^*_{pit}$ | dispersion correct, location arbitrary |
| `U_pit` | `U_pit` / $U^*_{pit}$ | shape correct, location arbitrary |

`B` for *baseline*: it is the omnibus test the other two refine.

Touches:
- `pit_w()` and `prediction_scores()` return columns (`R/scoring.R`).
- `b_pit_significance()` already takes a `B_pit` argument and documents the
  pre-rename column name; that note can go once this lands.
- `tests/testthat/`, the vignettes, and the notation table in the paper.

Do this in one pass, not incrementally — a half-renamed metric is worse than
either name.
