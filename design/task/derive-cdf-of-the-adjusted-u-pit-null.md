---
class: task
id: derive-cdf-of-the-adjusted-u-pit-null.md
title: Find or tabulate a c.d.f. for the bias-adjusted U_pit null
status: todo
kind: feature
priority: medium
touches:
- src:significance.R
---
Raised 2026-11-17. The limiting law is **identified and numerically verified**;
what is missing is a c.d.f. in the sense that Johnson & Killeen (1983) gives
one for the baseline functional.

The bias adjustment estimates a location shift from the same data, which
removes one direction from the limiting bridge. With
$\kappa(t) = \varphi(\Phi^{-1}(t))/\varphi(0)$ the sensitivity of the PIT
values to that shift, and the median centring pinning the bridge at $t = 1/2$,

$$\sqrt{n}\,U_{pit} \Rightarrow \int_0^1 \left| B^\circ(t) - \kappa(t)\,B^\circ(\tfrac12) \right| \mathrm{d}t$$

Verification (2026-11-17), 4000 replicates of the limit process against 3000
finite-sample replicates at $n = 400$:

| | limit process | finite sample $n=400$ |
|---|---|---|
| mean | 0.2345 | 0.236 |
| $q_{0.95}$ | 0.3791 | 0.382 |

and the ratio of adjusted to baseline 5% critical value is a stable 0.65–0.67
across $n \in \{25, 76, 400\}$ and across $\kappa_\mathcal{S} \in \{0, 0.5\}$,
confirming the adjusted null is still distribution-free.

This is the Kolmogorov–Smirnov to Lilliefors step: same statistic, one
estimated parameter, a different and strictly smaller null. Using the baseline
null for the adjusted statistic is badly conservative — at $n = 76$ a
$U_{pit}$ of 0.05 gives $p = 0.165$ against the baseline null and $p = 0.022$
against the correct one.

Current implementation: `.u_pit_null()` in `R/significance.R` simulates the
limit process once per session and caches it, with a quadratic-exponential
tail extrapolation beyond the 99th percentile. It is correct and cheap, but it
is simulation, and the paper's claim is that the family is analytical.

What would close this:
1. A c.d.f. for $\int_0^1|B^\circ(t) - \kappa(t)B^\circ(1/2)|\,\mathrm{d}t$ in
   the style of Johnson & Killeen, or
2. a published result for the L1 norm of a bridge with a linear functional
   projected out, or
3. failing both, a high-precision tabulation shipped as package data with a
   stated accuracy, which is honest and citable even if it is not a formula.

Option 3 is the acceptable fallback and should not block the paper.
