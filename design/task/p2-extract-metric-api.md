---
class: task
title: "P2 reference implementation of the paper's metrics"
status: doing
priority: high
phase: P2
tags: [api, metrics]
---

# Goal

One readable definition of every metric the paper defines, in `R/metrics.R`,
called by `analysis.R` instead of re-derived inline. Not a package — see
`adr:paper-is-primary-and-metrics-are-a-reference-implementation.md`.

Done:

- [x] `rank_of(n)` — the ideal PIT quantiles $(i - 0.5)/n$ of `\eqref{eq:pit2}`.
- [x] `pit_w(true_value, est_mean, est_sd, cdf = stats::pnorm)` — bias-adjusted
      $D^*_{pit}$ (`\eqref{eq:pit2}`) and directed $U^*_{pit}$ (`\eqref{eq:pit3}`),
      plus `bias` and the unadjusted distance. Accepts a length-$n$ vector or an
      $S \times n$ matrix (rows = estimators), so one call scores a whole
      scenario grid.
- [x] `coverage_prob(pit, level)` — `\eqref{eq:cover}`.
- [x] `threshold_misclass(true_value, est_mean, est_sd, threshold, link)` —
      $P_{err}$ of `\eqref{eq:tmp}`, which previously existed only in the paper.
- [x] `rlnorm4(n, median, coef_variation)` — moved out of `analysis.R:22`.
- [x] `tests/testthat/test-metrics.R` written against the paper's stated
      properties, proven to fail before `R/metrics.R` existed, now 26 passing.
      Entry point: `Rscript --no-init-file tests/testthat.R`.
- [x] `run_scenario()` calls the reference functions; the dead `pitw()` closure
      (old `analysis.R:120-172`, complete but never called) and the duplicated
      `unif` definitions are gone.
- [x] `.Rprofile` sources `R/metrics.R`.
- [x] Numeric equivalence proven: old and new `run_scenario()` agree to
      2.8e-17 on every metric column over the 9-row figure grid.

Remaining:

- [ ] Decide whether `threshold_misclass()` earns a column in `run_scenario()`.
      It is implemented and tested but no figure shows $P_{err}$, so adding the
      column is a paper change, not just a code change.
- [ ] Fold the `metric` instances into `design/metric/` and link each to
      `src:R/metrics.R` via `implementedIn`, and to its figure via
      `figure --visualises--> metric`. The directory exists and is empty.
- [ ] `R/import-standalone-mixture-distributions.R` is unused by anything
      (confirmed by grep for its exported samplers) — delete it, or say why it
      stays.

# Anchors

| Symbol | Location | Paper |
|---|---|---|
| `pit_w()` | `src:R/metrics.R` | `\eqref{eq:pit2}`, `\eqref{eq:pit3}` |
| `coverage_prob()` | `src:R/metrics.R` | `\eqref{eq:cover}` |
| `threshold_misclass()` | `src:R/metrics.R` | `\eqref{eq:tmp}` |
| `rlnorm4()` | `src:R/metrics.R` | the $\sigma_i$ draw of `\eqref{eq:valid}` |
| `run_scenario()` | `src:analysis.R#run_scenario` | the simulation of `\eqref{eq:valid}` |
| `crps()`, `crps_norm()` | `src:analysis.R` | left in place — CRPS is cited to `scoringRules`, not defined here |

# Do not repeat

- **Do not use the vendored `dist_fns` class for the metrics.** See
  `issue:dist-fns-vendoring-incomplete.md`. It cannot hold per-prediction
  parameters, and vectorising through it is no faster than the plain
  `pnorm(q, mean, sd)` call it would replace.
- Matrix recycling: an $S \times n$ matrix minus a length-$n$ vector walks the
  vector down the **columns**. Every place a per-prediction vector meets a
  per-estimator matrix must go through `.recyc_rows()` / `.recyc_cols()`. This
  was introduced once and caught only by the numeric-equivalence check.
