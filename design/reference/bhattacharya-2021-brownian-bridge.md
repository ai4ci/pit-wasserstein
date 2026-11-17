---
class: reference
id: bhattacharya-2021-brownian-bridge.md
title: The Brownian Bridge
citeKey: bhattacharya2021
year: 2021
doi: 10.1007/978-3-030-78939-8_20
zoteroKey: NXMTC4GP
citedIn:
- paper:refs.bib
---
Bhattacharya & Waymire (2021), *Random Walk, Brownian Motion, and Martingales*,
Graduate Texts in Mathematics 292, Springer, Chapter 20.

Rigorous treatment of the Brownian bridge $B^*_t = B_t - tB_1$ as a centered
Gaussian process with covariance $\operatorname{Cov}(B^*_s, B^*_t) = s(1-t)$ for
$s\leq t$ (Proposition 20.1). Key results:

- **Proposition 20.2**: for i.i.d. $U(0,1)$ samples, the Kolmogorov–Smirnov statistic
  $D_n = \sqrt{n}\sup_{t}|F_n(t)-t|$ converges in distribution to
  $\sup_{t\in[0,1]}|B^*_t|$.
- **Corollary 20.3**: this limit distribution is *free of the parent CDF* for any
  continuous $F$, so $D_n$ is distribution-free (the classical KS result).
- **Exercise 6(iv)**: $P(\sup|B^*_t|\leq y) = 1+2\sum_{k=1}^\infty (-1)^k e^{-2k^2y^2}$,
  the standard Kolmogorov distribution for two-sided KS tests.
- **Glivenko–Cantelli Lemma** (Exercise 7): $\sup_t|F_n(t)-F(t)|\to 0$ almost surely.

The Brownian bridge is the weak limit of the empirical quantile process under the null
of uniform PIT values, which is why $\sqrt{n}\,D^*_{pit} \Rightarrow \int_0^1 B^*(u)\,du$
is Gaussian with mean 0 and variance $1/48$.

**Why cite:** the distribution-free KS limit (Prop. 20.2) provides the template for
the distribution-free null of $D^*_{pit}$; the bridge covariance $s(1-t)$ gives
$\operatorname{Var}(\int B^*) = 1/48$. Johnson & Killeen (1983) provide the explicit
CDF for the complementary $\int|B^*|$ functional.
