---
class: task
id: mean-based-bias-estimator-fails-for-skewed-distributions.md
title: pit_w bias estimator uses a mean and is inconsistent for skewed predictive families
status: done
kind: paperFix
priority: high
touches:
- src:scoring.R#pit_w
- src:scoring.R#prediction_scores
- vignette:significance-testing.Rmd
blocks:
- task:add-non-normal-distribution-robustness-study.md
---
Pre-existing bug, found by the user 2026-11-13 while testing `gamma4`
predictive distributions, diagnosed in-session.

## Symptom

`U_pit` cannot be driven near zero for a skewed predictive family, at any
scale:

```r
qs = seq(1,199,2)/200
pit_w(1, qgamma4(qs, 1, 0.5), 0.50, dist = "gamma4", link = "log")   # U_pit = 0.0228
```

## Cause

`src:scoring.R#pit_w` estimates the bias as

```r
link_bias = mean(ln$linkfun(link_medians) - ln$linkfun(true_value))
```

For a **perfectly calibrated** estimator the PIT values are uniform, which
forces the *median* log-residual to zero — but **not the mean**, when the
log-residuals are skewed. For a skewed predictive family the mean-based
estimator therefore reports a spurious non-zero bias, the adjustment shifts
the true values by it, and the metric then measures the miscalibration the
adjustment just introduced.

`prediction_scores()` (`src:scoring.R`) uses the identical construction and
has the same defect.

## Evidence

$n=100$ deterministic mid-rank grid, `gamma4` with $\kappa=0.5$, true value 1.
"Calibrated placement" is $\mu_i = 1/F_W^{-1}(1-q_i)$, which yields exactly
uniform PITs by construction (`gamma4` is a scale family in `location`).

| case | `B_pit` | adj: mean | adj: median | mean log bias |
|---|---|---|---|---|
| `lnorm4`, log-symmetric | 5.1e-17 | 5.1e-17 | 7.9e-17 | -3.3e-18 |
| `gamma4`, quantile placement | 2.35e-2 | 2.28e-2 | 2.35e-2 | -4.40e-2 |
| `gamma4`, calibrated placement | **6.4e-17** | **2.41e-2** | **3.8e-6** | +4.40e-2 |

Row 3 is decisive: the PIT values are uniform to machine precision, and the
mean-based adjustment turns a perfect score into 0.024. A median-based
estimator recovers 3.8e-6. Log-symmetric families (row 1) are unaffected
either way, which is why this was never seen with `norm` or `lnorm4` — the
two families the existing `@unit` tests use.

## Suggested fix

Use a median for the link-scale bias:

```r
link_bias = median(ln$linkfun(link_medians) - ln$linkfun(true_value))
```

This is the **third independent argument for median-based centring**, after
the probit-space infinities and the outlier breakdown point documented in
`task:restore-pivotality-of-the-bias-adjustment.md`. It also changes published
numbers for any skewed family, so it is a correction to the metric's
behaviour, not just an implementation detail — the paper's existing results
all use `norm`/`lnorm4` and are unaffected.

## Knock-on: the `@unit` test construction is only valid for log-symmetric families

The existing examples place predictions at `q<dist>(qs, ...)`, giving
$u_i = F_W(1/F_W^{-1}(q_i))$, which is uniform only when
$W \overset{d}{=} 1/W$, i.e. when $\log W$ is symmetric. That holds for `norm`
and `lnorm4` but not for `gamma4` — the user's construction was genuinely
miscalibrated (`B_pit` = 0.0235) independently of the bug above. Any
test or vignette extending to skewed families must use
$\mu_i = 1/F_W^{-1}(1-q_i)$, or solve $F(x_0;\mu_i) = 1-q_i$ numerically.

This directly affects `task:add-non-normal-distribution-robustness-study.md`:
without both corrections that study would have produced inexplicable
non-zero baselines.

## UPDATE 2026/11/16

This is changed in code and calibration location functions added for testing but not updated in paper or documentation yet.

