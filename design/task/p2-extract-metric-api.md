---
class: task
title: "P2 extract the metric API from analysis.R"
status: todo
priority: high
phase: P2
tags: [packaging, api]
---

# Goal

Move the metric definitions out of `analysis.R` into `R/` as the package's
exported API. Scope agreed: **metrics only, generic** — the vendored `ggrrr`
plotting/table helpers stay internal and dot-prefixed.

Anchors to move (all in `analysis.R`):

| Symbol | Line | Notes |
|---|---|---|
| `pitw()` | `analysis.R:120` | returns a closure over `cdf`; the core of $D^*_{pit}$ / $U^*_{pit}$ |
| `crps()` | `analysis.R:95` | returns a closure; integrates the CDF |
| `crps_norm()` | `analysis.R:172` | closed-form wrapper |
| `rlnorm4()` | `analysis.R:22` | sharpness sampler, needed by the simulator |
| `run_scenario()` | `analysis.R:194` | the simulation in `\eqref{eq:valid}` |

Order of work (`AGENTS.md`: tests proven to fail first, then pass):

1. Write `testthat` tests against the **intended** behaviour, not current
   behaviour. Expect failures from `issue:sample-size-discrepancy` and
   `issue:implicit-sorting-notation` — discuss, do not silently fix.
2. Move the five functions, add roxygen docs, `.gg_*`/`.hux_*` helpers stay
   unexported.
3. Delete the `source()` block from `.Rprofile`; it must not ship.
4. Re-point `analysis.R` at the package, and stop it writing into `main/fig/`
   implicitly (`here::here` is disabled inside packages).
5. Decide `R/import-standalone-mixture-distributions.R`: unused by everything,
   delete unless the paper gains mixture predictions.
