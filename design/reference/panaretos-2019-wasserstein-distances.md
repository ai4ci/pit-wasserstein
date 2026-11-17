---
class: reference
id: panaretos-2019-wasserstein-distances.md
title: Statistical Aspects of Wasserstein Distances
citeKey: panaretos2019
year: 2019
doi: 10.1146/annurev-statistics-030718-104938
zoteroKey: 4QRI8U4C
citedIn:
- paper:refs.bib
---
Panaretos & Zemel (2019), *Annual Review of Statistics and Its Application*
6:405–431.

Comprehensive review of Wasserstein distances $W_p$ and their statistical uses,
structured in three categories: (1) technical tool for asymptotic theory,
(2) methodological tool for inference (goodness-of-fit), (3) object of inference
(Wasserstein space as sample space).

Key results for $W_1$ on the real line:

- **One-dimensional formula** (Section 1.2.2): $W_p(X,Y) = \|F_X^{-1} -
  F_Y^{-1}\|_p = (\int_0^1 |F_X^{-1}(\alpha) - F_Y^{-1}(\alpha)|^p d\alpha)^{1/p}$,
  and $W_1(X,Y) = \int_{-\infty}^\infty |F_X(t) - F_Y(t)|\,dt$.
- The $W_1$ between the empirical measure $\mu_n$ and a true law $\mu$ converges
  at rate $n^{-1/2}$ in 1-D under a moment condition (Section 3.3:
  $J_1(\mu) = \int F(1-F) < \infty$ suffices).
- **One-sample GoF**: del Barrio et al. (2000) derive the asymptotic distribution
  of $W_2(F_n, F_0)$; limits are of order $\sqrt{n}$ and normal under the
  alternative, and of order $n$ under the null.
- **Gaussian case** (Section 3.2): for $p=2$ with Gaussian measures,
  $W_2^2(N(m_1,\Sigma_1), N(m_2,\Sigma_2)) = \|m_1-m_2\|^2 +
  \operatorname{tr}[\Sigma_1+\Sigma_2-2(\Sigma_1^{1/2}\Sigma_2\Sigma_1^{1/2})^{1/2}]$.

For the PIT-Wasserstein metric $D^*_{pit} = W_1(\text{PIT distribution}, U(0,1))$:
the one-dimensional formula makes $W_1$ computationally trivial (no LP needed),
and the $n^{-1/2}$ convergence rate justifies the $\sqrt{n}$ scaling used in the
asymptotic theory.

**Why cite:** Wasserstein distance theory, especially the 1-D $W_1$ formula and
empirical process convergence rates.
