---
class: reference
id: diebold-1998-density-forecast-evaluation.md
title: Evaluating Density Forecasts with Applications to Financial Risk Management
citeKey: Diebold_Gunther_Tay_1998
year: 1998
doi: 10.2307/2527342
zoteroKey: WFB3G5YT
citedIn:
- paper:refs.bib
---
Diebold, Gunther & Tay (1998), *International Economic Review* 39(4):863–883.

The paper that made the PIT the standard tool for density forecast evaluation.
It shows that if the sequence of forecast densities $p_t(y_t)$ coincides with
the true conditional densities $f_t(y_t \mid \Omega_t)$, then the sequence of
probability integral transforms $z_t = P_t(y_t)$ is i.i.d. $U(0,1)$ — the
joint-density/triangular-Jacobian argument is their Proposition.

Their central methodological complaint is the one this paper answers:

> Simple tests of i.i.d. $U(0,1)$ behavior are readily available, such as those
> of Kolmogorov–Smirnov and Cramér–von Mises. Alone, however, such tests are not
> likely to be of much value [...] because they are not constructive; that is,
> when rejection occurs, the tests generally provide no guidance as to why.

They therefore fall back on histograms and correlograms of $z_t$ — visual,
not scalar. $D^*_{pit}$ with its signed companion $U^*_{pit}$ is a scalar that
*is* constructive: magnitude plus direction of the departure.

**Why cite:** the canonical PIT reference (with Dawid 1984), and the source of
the "tests are not constructive" motivation for a quantified, directional
metric.