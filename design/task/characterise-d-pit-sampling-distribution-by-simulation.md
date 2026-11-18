---
class: task
id: characterise-d-pit-sampling-distribution-by-simulation.md
title: Characterise D*_pit sampling distribution under H0 by simulation
status: done
kind: feature
priority: high
touches:
- src:simulation.R
- src:scoring.R#pit_w
blocks:
- task:implement-bootstrap-test-for-dispersion-calibration.md
- task:decide-publication-format-short-communication-or-full-paper.md
---
Simulate $D^*_{pit}$ (and $U^*_{pit}$) under $H_0$ (estimator exactly
dispersion-calibrated, $\sigma_\mathcal{S}/\sigma_\mathcal{E}=1$, varying
bias and $\kappa_\mathcal{S}$) across a grid of sample sizes, reusing
`generate_simulation()` (`src:simulation.R`) and `pit_w()`
(`src:scoring.R#pit_w`). Goals:

- Confirm (or correct) the existing qualitative observation in
  `main.tex:234` that undirected PIT-Wasserstein shrinks with sample size and
  that the bias-adjustment step adds its own sampling noise (the bias itself
  is estimated from the same sample).
- Establish the empirical rate: does $D^*_{pit}$ under $H_0$ scale like
  $n^{-1/2}$ as for an unadjusted Wasserstein-1-to-uniform statistic, or does
  estimating the bias shift change the rate or the constant?
- Check sensitivity to $\kappa_\mathcal{S}$ (variability of estimator
  confidence) and to the choice of `dist`/`link`, since the null distribution
  should not depend on these if the metric is to be used as a general test
  statistic.
- Output: an empirical null distribution of $D^*_{pit}$ (and $U^*_{pit}$) as
  a function of $n$, suitable for the bootstrap test in
  `task:implement-bootstrap-test-for-dispersion-calibration.md` to validate
  against, and candidate figures/tables for a results section.

This is simulation study work, not an R package feature — output likely
belongs in a new vignette or in `main.tex`'s results section rather than
exported package code.
