---
class: reference
id: zhao-2020-individual-calibration.md
title: Individual Calibration with Randomized Forecasting
citeKey: Zhao_Ma_Ermon_2020a
year: 2020
zoteroKey: 9H8T2GXP
citedIn:
- paper:refs.bib
---
Zhao, Ma & Ermon (2020), *ICML* 37:11387–11397.

**Closest prior art to the unadjusted metric, alongside Wessel et al. (2025).**
They measure miscalibration as the Wasserstein-1 distance between the PIT
distribution and the uniform, defined explicitly as

$$d_{W1}(F, F') = \int_0^1 |F(r) - F'(r)|\,dr, \qquad
\mathrm{err}_H(x) = d_{W1}\!\left(F_{H[x]}(Y), F_U\right),$$

i.e. the $L^1$ distance between the empirical PIT CDF and the uniform CDF —
the same construction as $D_{pit}$, used as a per-input quantity and a training
objective rather than as an evaluative statistic. No bias adjustment, no signed
direction, no finite-sample correction.

Their contribution is *individual* calibration: requiring $\mathrm{err}_H(x)
\approx 0$ for every $x$, not on average. They prove it is unattainable
deterministically — Proposition 1 shows no verifier can decide
$(\epsilon,\delta)$-PAIC for a deterministic forecaster from a finite sample,
hence no learning algorithm can guarantee it — and achieve it by randomising
the forecast. They also note that average calibration in $d_{W1}$ bounds the
ECE of Guo et al. (2017).

**Why cite:** mandatory. The Wasserstein-1-to-uniform construction is already
in the literature, so the novelty claim must rest on (a) the bias adjustment,
(b) the signed $U^*_{pit}$, and (c) its use as an evaluative metric with
known finite-sample behaviour — not on the distance itself.