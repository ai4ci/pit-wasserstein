---
class: task
id: derive-analytical-null-distribution-for-pit-w-metrics.md
title: Derive the analytical null distribution of the PIT-W metrics
status: todo
kind: feature
priority: high
touches:
- paper:main.tex
- src:scoring.R#pit_w
blocks:
- task:characterise-d-pit-sampling-distribution-by-simulation.md
- task:restore-pivotality-of-the-bias-adjustment.md
- task:two-part-test-decomposition-d-then-u.md
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

$\sqrt{n}\,U^*_{pit} \Rightarrow \int_0^1|B^\circ(p)|dp$, the Kac-Takács
statistic. Takács (1993) gives the exact CDF as a series. Mean is clean:

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
test in closed form, tabulate $U^*_{pit}$ critical values from the Takács
series (validated against simulation rather than derived from it). This
reframes `task:characterise-d-pit-sampling-distribution-by-simulation.md`
from "primary evidence" to "validation of known theory", which is
substantially more publishable.

Blocked by nothing; feeds the publication-format decision.