---
class: task
id: implement-bootstrap-test-for-dispersion-calibration.md
title: 'Implement a bootstrap significance test for H0: dispersion-calibrated'
status: dropped
kind: feature
priority: high
touches:
- src:scoring.R#pit_w
- paper:main.tex
blocks:
- task:document-asymptotic-theory-as-future-work.md
---
Implement a bootstrap (or permutation) hypothesis test for $H_0$: the
estimator is dispersion-calibrated, using $D^*_{pit}$ as the test statistic,
informed by the empirical null characterised in
`task:characterise-d-pit-sampling-distribution-by-simulation.md`.

Candidate procedures to evaluate (decide once the null-distribution shape
from that task is known):

- **Parametric bootstrap under $H_0$**: given the observed bias and sample
  size, simulate the null distribution of $D^*_{pit}$ directly (as in the
  characterisation task) and read off a p-value / critical value for the
  observed statistic. Simplest, but assumes the fitted distributional family
  is correct.
- **Nonparametric bootstrap on the adjusted PIT values**: resample the
  adjusted PIT values with replacement, recompute $D^*_{pit}$ each time, use
  the resample distribution to test against $H_0$'s theoretical mean/shape.
  Needs care because the PIT values are already a transform of the data, not
  i.i.d. draws in the usual bootstrap sense.

Implementation: likely a new exported function (e.g. `pit_w_test()`) in
`src:scoring.R` returning a statistic and p-value alongside the existing
`pit_w()` tibble, following the same `@unit`-tag test convention as
`pit_w()` itself. Needs its own tests proven to fail before development and
pass before completion, per AGENTS.md.

Report the result in `main.tex` (a worked example with a real or simulated
dataset showing the test in use), and reference back to `main.tex:240`'s
original "further work" statement as resolved by this work.

---

## Superseded proposal (17 November 2026)

The premise of this task was that no analytical null was available, so a
bootstrap would have to stand in. That premise no longer holds: see
`task:derive-analytical-null-distribution-for-pit-w-metrics.md`. All three
metrics now have exact or numerically-exact distribution-free nulls and a
working significance test in `src:significance.R`, with empirical size at
nominal 5% confirmed by simulation.

A bootstrap would now be strictly worse — slower, approximate, and it would
undercut the paper's claim that the family is analytical.

The independent-prediction bootstrap was dropped. The current EpiEstim study obtains independent estimates by design. Dependence-aware resampling is a separate [future plan](../plan/serially-dependent-forecasts.md).