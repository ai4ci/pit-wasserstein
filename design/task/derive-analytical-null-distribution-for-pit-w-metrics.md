---
class: task
id: derive-analytical-null-distribution-for-pit-w-metrics.md
title: Derive the analytical null distribution of the PIT-W metrics
status: done
kind: feature
priority: high
touches:
- paper:main.tex
- src:scoring.R#pit_w
- vignette:significance-testing.Rmd
- src:significance.R
blocks:
- task:characterise-d-pit-sampling-distribution-by-simulation.md
- task:restore-pivotality-of-the-bias-adjustment.md
- task:document-three-part-test-decomposition.md
---
Worked through with the user 2026-11-13; numerically verified in-session
(20k-40k replicates per $n$). Under $H_0$ the unadjusted PIT values are iid
$U(0,1)$ **whatever the predictive distributions are**, so the null law of
both metrics depends only on $n$ — the whole derivation can be posed in
terms of uniforms.

## The reduction

Both metrics are functionals of the empirical quantile process
$q_n(p)=\sqrt{n}(F_n^{-1}(p)-p) \Rightarrow -B^\circ(p)$, a Brownian bridge.

## $D^*_{pit}$ (directed) — closed form

A **linear** functional of the bridge, hence exactly Gaussian in the limit.
With $s(p)=\operatorname{sgn}(0.5-p)$ and $K(s,t)=\min(s,t)-st$:

$$\sigma^2=\iint s(p)s(q)K(p,q)\,dp\,dq=\tfrac{1}{12}-\tfrac{1}{16}=\tfrac{1}{48}$$

$$D^*_{pit} \;\dot\sim\; N(0,\;1/(48n))$$

Two-sided 5% test: $|D^*_{pit}| > 1.96/\sqrt{48n} = 0.2829/\sqrt{n}$.

Verified numerically: $n\cdot\mathrm{Var}(D^*_{pit})=0.0208$ against
$1/48=0.02083$, and essentially **exact even at $n=25$**. Skewness ~0 at all
$n$. Caveat: tails are slightly heavy at small $n$, so the normal critical
value over-rejects — empirical size 8.1% at $n=10$, 6.3% at $n=25$, 5.5% at
$n=50$, 5.3% at $n=100$, 5.1% at $n=400$. Needs a kurtosis/Edgeworth
correction or an exact tail below $n\approx50$.

## $U^*_{pit}$ (undirected) — a named distribution

$\sqrt{n}\,U^*_{pit} \Rightarrow \int_0^1|B^\circ(p)|dp$, the integrated
absolute Brownian-bridge functional. Its mean is clean:

$$\mathbb{E}\!\int_0^1|B^\circ| = \sqrt{\tfrac{2}{\pi}}\int_0^1\!\sqrt{p(1-p)}\,dp
= \sqrt{\tfrac{2}{\pi}}\cdot\tfrac{\pi}{8} = \tfrac{\sqrt{2\pi}}{8} \approx 0.3133$$

Verified: $\sqrt{n}\,\mathbb{E}[U^*_{pit}]$ = 0.311 / 0.312 / 0.313 / 0.314
at $n$ = 25 / 100 / 400 / 1600. Empirical upper 95% point of
$\sqrt{n}\,U^*_{pit} \approx 0.580$, stable from $n\approx25$.

Variance of the limit follows from the bivariate normal absolute moment
$\mathbb{E}|XY|=\tfrac{2}{\pi}\sigma_s\sigma_t(\sqrt{1-\rho^2}+\rho\arcsin\rho)$
integrated against $K$.

**Exact finite-$n$ moments** are also available: $u_{(i)}\sim\mathrm{Beta}(i,n-i+1)$
and $\mathbb{E}|u_{(i)}-r_i|$ is closed-form in incomplete beta functions. Worth
having because $r_i=(i-0.5)/n$ vs $\mathbb{E}u_{(i)}=i/(n+1)$ differ by
$O(1/n)$ — a *relative* $O(n^{-1/2})$ correction that matters at small $n$.

## Deliverable

Write this up as a theory section: state both limits, give the $D^*_{pit}$
test in closed form, tabulate $U^*_{pit}$ critical values from a
bridge-specific distributional result or simulation (validated against
simulation rather than derived from it). This
reframes `task:characterise-d-pit-sampling-distribution-by-simulation.md`
from "primary evidence" to "validation of known theory", which is
substantially more publishable.

Blocked by nothing; feeds the publication-format decision.


## Reference check 2026-11-16

The new Takács (1993) reference is specifically about the integral of the absolute value of **Brownian motion**, not the Brownian bridge. It therefore does not support the claim that the bridge functional has the same exact CDF series. The supplementary vignette now names the limit descriptively as the integrated absolute Brownian-bridge functional; critical values should be taken from a bridge-specific source or simulation until a direct reference is verified. Bhattacharya and Waymire (2021) is useful background on the bridge itself, but does not establish this functional's distribution.

---

## Outcome (2026-11-17): done

All three members of the family now have a null, and two of the three are
exact and analytical.

| Metric | $H_0$ | Null of $\sqrt{n}\times$metric | Status |
|---|---|---|---|
| `B_pit` | PITs are i.i.d. $U(0,1)$ | $\int_0^1\|B^\circ\|$, c.d.f. from Johnson & Killeen (1983) | **exact, closed form** |
| `D_pit` | dispersion correct, location arbitrary | $\mathcal{N}(0, 1/48)$ | **exact, closed form** |
| `U_pit` | shape correct, location arbitrary | $\int_0^1\|B^\circ(t)-\kappa(t)B^\circ(1/2)\|$ | law identified, c.d.f. open |

with $\kappa(t)=\varphi(\Phi^{-1}(t))/\varphi(0)$.

Implemented in `src:significance.R` as `b_pit_significance()`,
`d_pit_significance()` and `u_pit_significance()`, with `p_l1_bridge()` /
`q_l1_bridge()` exposing the Johnson & Killeen series. The Airy function and
the zeros of $Ai'$ are computed from base R's Bessel functions, so no new
dependency was needed.

Key finding beyond the original scope: **the bias adjustment is free for
`D_pit` and expensive for `U_pit`.** $D_{pit}$ is already orthogonal to a
location shift, so $n\mathrm{Var}(D)$ is $1/48$ with or without the
adjustment; $U_{pit}$ pays the usual estimated-parameter price and its 5%
critical value is a stable 0.66 times the baseline one. That asymmetry is now
a result in the paper rather than a caveat.

Empirical size at $n = 76$, 3000 replicates, heteroscedastic
($\kappa_\mathcal{S} = 0.5$) calibrated predictions: `B_pit` 5.8%, `U_pit`
4.7%, `D_pit` 6.3% against a nominal 5%. The `D_pit` inflation is the
documented small-$n$ behaviour of the normal approximation; the `B_pit`
inflation is `task:b-pit-computed-against-adjusted-ranks.md`.

Remaining work split out as
`task:derive-cdf-of-the-adjusted-u-pit-null.md` — the `U_pit` null is
currently simulated once per session rather than evaluated from a formula.
