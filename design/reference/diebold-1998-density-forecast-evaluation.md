---
class: reference
id: diebold-1998-density-forecast-evaluation.md
title: Evaluating Density Forecasts with Applications to Financial Risk Management
citeKey: diebold1998
year: 1998
doi: 10.2307/2527342
zoteroKey: E6H3454Z
citedIn:
- paper:refs.bib
---
Diebold, Gunther & Tay (1998), *International Economic Review* 39(4):863–883.

The paper that established the PIT as the standard tool for density forecast
evaluation. Core results:

- **Decision-theoretic motivation** (Section 2): the true DGP $f(y_t \mid
  \Omega_t)$ dominates all other densities $p_t(y_t)$ for *all* loss functions —
  no forecast user can do better than using the correct density. But if $p_t \neq
  f_t$, some users *must* do worse. This gives a loss-function-free criterion:
  test whether $p_t = f_t$.
- **The PIT Proposition** (Section 3): if $p_t(y_t) = f_t(y_t \mid \Omega_t)$ for
  all $t$, then the sequence $z_t = P_t(y_t) = \int_{-\infty}^{y_t} p_t(u)\,du$
  is i.i.d. $U(0,1)$. Proof uses the triangular Jacobian of the
  transformation from $\{y_t\}$ to $\{z_t\}$, showing the joint density of
  $\{z_t\}$ factorises into $U(0,1)$ marginals.
- **Central methodological complaint**:

  > Simple tests of i.i.d. $U(0,1)$ behavior are readily available, such as those
  > of Kolmogorov–Smirnov and Cramér–von Mises. Alone, however, such tests are not
  > likely to be of much value [...] because they are not constructive; that is,
  > when rejection occurs, the tests generally provide no guidance as to why.

- **Proposed graphical diagnostics**: (a) PIT histogram to check uniformity,
  with binomial confidence intervals per bin; (b) correlograms of $(z-\bar{z})$,
  $(z-\bar{z})^2$, $(z-\bar{z})^3$, $(z-\bar{z})^4$ to detect dependence in
  conditional mean, variance, skewness, kurtosis.
- **Applications**: simulated t-GARCH(1,1) and real S&P 500 returns. Showed
  progressive improvement from naive $N(0,1)$ → GARCH → t-GARCH as evidenced by
  increasingly uniform PIT histograms and vanishing autocorrelation.

**Why cite:** the canonical PIT reference (with Dawid 1984), and the source of
the "tests are not constructive" motivation for a quantified, directional metric.
$D^*_{pit}$ with its signed companion $U^*_{pit}$ is a scalar that *is*
constructive: magnitude plus direction of the departure, decomposable along the
lines Diebold et al. propose.
