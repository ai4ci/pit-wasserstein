---
class: task
id: add-non-normal-distribution-robustness-study.md
title: Use the existing non-normal distribution capability to test bias-adjustment robustness
status: todo
kind: feature
priority: high
touches:
- src:simulation.R
- src:scoring.R#pit_w
---
The capability to simulate non-normal distributions already exists and is
unused. `generate_simulation()` (`src:simulation.R`) takes `bias_dist`,
`sharpness_dist`, `estimator_dist` and `true_value_fn` as arbitrary
`r*`-prefixed function names via `rlang::as_function(sprintf("r%s", ...))`
— but the paper's validation simulation (`main.tex` eq:valid, eq:valid2)
only ever exercises $X \sim N(0,1)$ true values, Normal bias error, and
log-normal sharpness. Every reported result is Gaussian-on-Gaussian.

Since the bias adjustment in `pit_w()` is median-based (not mean-based —
see `src:scoring.R#pit_w`'s `link_medians`/`link_bias` computation), it
should in principle be robust to asymmetric distributions where a mean-based
adjustment would not be. This is currently an unverified claim, not a result.

Agreed scope, discussed with the user 2026-11-13: extend the validation
simulation (or a new supplementary vignette, see
`task:reframe-vignettes-as-supplementary-materials.md`) to non-normal error
and/or true-value distributions relevant to the parent paper's domain — e.g.
gamma or log-normal true values and/or error functions, which is closer to
how positive, skewed quantities like $R_t$ actually behave — and report
whether $D^*_{pit}$/$U^*_{pit}$ remain bias-invariant and well-behaved under
that asymmetry. This is new evidence using existing capability, not a code
change to `generate_simulation()` itself unless a gap is found while doing
it (in which case: pre-existing per AGENTS.md, raise as a separate issue, do
not fix inline).

Can proceed regardless of the short-communication-vs-full-paper decision.