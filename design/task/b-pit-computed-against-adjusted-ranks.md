---
class: task
id: b-pit-computed-against-adjusted-ranks.md
title: Baseline PIT-W metric is computed against the adjusted ranks
status: done
kind: issue
priority: high
touches:
- src:scoring.R
---
Discovered 2026-11-17 while building the significance tests. **Pre-existing,
not introduced by that work; not fixed.**

`prediction_scores()` (`R/scoring.R`) and `pit_w()` both compute the
*unadjusted* metric against the ranks of the **adjusted** PIT values:

```r
rank_order = rank(u_i, ties.method = "first")   # u_i is adjusted
unif       = (rank_order * 2 - 1) / (2 * n)
u_pit_unadj = abs(unif - u_i_unadj)             # unadjusted values, adjusted ranks
```

When the predictions are homoscedastic the link adjustment is a common shift
and the two rank vectors agree, so the defect is invisible. Under
heteroscedasticity it is not: an x-space shift $b$ moves $u_i$ by roughly
$b\varphi/\sigma_i$, which is a *different* amount for each prediction, so the
ordering can change and `u_pit_unadj` is then computed against the wrong
uniform grid.

Why it matters now: `B_pit` is one of the three members of the metric family
and has its own exact null (`b_pit_significance()`, the integrated absolute
bridge). That null assumes the statistic is
$\frac1n\sum_i |u_{(i)} - \frac{2i-1}{2n}|$ **on its own order statistics**.
A simulation check at $n = 76$ with $\kappa_\mathcal{S} = 0.5$ gives an
empirical size of 5.8% against a nominal 5%, consistent with a small amount of
contamination from the borrowed ranks.

Suggested fix: rank the unadjusted PIT values separately.

```r
unif_unadj  = (rank(u_i_unadj, ties.method = "first") * 2 - 1) / (2 * n)
u_pit_unadj = abs(unif_unadj - u_i_unadj)
```

Two lines in each of `prediction_scores()` and `pit_w()`. Re-run the size
check afterwards; it should come back to 5%.

---

## Why the ranks differ (2026-11-17)

Challenged on the grounds that the link and the quantile function are both
monotone, so the ranks must be preserved. That is true for *one* monotone map
applied to every element — but the adjustment is $n$ different maps:

$$u_i^{adj} = h_i(u_i), \qquad h_i = F_i \circ g^{-1}\!\left(g(F_i^{-1}(\cdot)) + b\right)$$

Each $h_i$ is monotone; they are not the same $h$. A shift of $b$ in $x$-space
moves prediction $i$'s PIT by roughly $b\varphi/\sigma_i$, so predictions with
small $\sigma_i$ move further. Counterexample, identity link, normal, $b = 1$:

| $z$ | $\sigma$ | $x$ | $u$ | $u^{adj}$ | rank $u$ | rank $u^{adj}$ |
|---|---|---|---|---|---|---|
| 0.0 | 1 | 0 | 0.500 | 0.841 | 1 | **2** |
| 0.1 | 10 | 1 | 0.540 | 0.579 | 2 | **1** |

## How much it matters

$n = 76$, 10000 replicates, calibrated heteroscedastic normal predictions,
$\kappa_\mathcal{S} = \mathrm{sd}(\log\sigma_i)$, nominal 5%:

| $\kappa_\mathcal{S}$ | % ranks moved | size, current | size, own ranks | mean $B$, current | mean $B$, own |
|---|---|---|---|---|---|
| 0 | **0.0%** | 0.046 | 0.046 | 0.0358 | 0.0358 |
| 0.25 | 37.8% | 0.050 | 0.048 | 0.0361 | 0.0357 |
| 0.50 | 52.4% | 0.054 | 0.048 | 0.0373 | 0.0357 |
| 1.00 | 65.3% | **0.091** | 0.050 | 0.0413 | 0.0360 |

Homoscedastic: identical, 0% of ranks move — which is why this was never
visible. Heteroscedastic: the test over-rejects calibrated forecasters, badly
at $\kappa_\mathcal{S} = 1$.

The direction follows from the construction: pairing each $u_i$ with the wrong
grid point can only add distance, so $B_{pit}$ is inflated. Mean $B$ under the
correct ranks is pinned at 0.0358 for every $\kappa_\mathcal{S}$, matching the
distribution-free null exactly; under the borrowed ranks it drifts upward with
$\kappa_\mathcal{S}$.

Note this only became a defect when $B_{pit}$ acquired its own null. As a
descriptive number to eyeball against the adjusted metric, borrowing the ranks
was harmless.

---

## Fixed (2026-11-18)

Fixed by the user in `src:scoring.R`. Both `prediction_scores()` and `pit_w()`
now rank the unadjusted PIT values separately, and the metric was renamed to
`B_pit` in the same pass (`task:rename-unadjusted-metric-to-b-pit.md`).

Verification — same experiment as above, $n = 76$, 4000 replicates, calibrated
heteroscedastic normals, nominal 5%:

| $\kappa_\mathcal{S}$ | size before | size after | mean $B_{pit}$ after |
|---|---|---|---|
| 0 | 0.046 | 0.044 | 0.0357 |
| 0.5 | 0.054 | 0.046 | 0.0357 |
| 1.0 | **0.091** | **0.051** | 0.0360 |

Null mean is $\sqrt{2\pi}/8\sqrt{n} = 0.0359$. The mean is now pinned at the
null value for every $\kappa_\mathcal{S}$ and the size holds at nominal across
the range, which is the signature that `B_pit` is the clean distribution-free
statistic its test assumes.

Note for whoever refactors later: `prediction_scores()` and `pit_w()` duplicate
the PIT construction, which is why this defect had to be fixed twice and was
initially fixed in only one of them. The duplication exists so that
`prediction_scores()` can return the per-prediction decomposition; a shared
helper returning `u_i`, `u_i_unadj`, `unif` and `unif_unadj` would remove the
hazard without losing that.
