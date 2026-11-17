---
class: reference
id: arrieta-ibarra-2022-metrics-of-calibration.md
title: Metrics of Calibration for Probabilistic Predictions
citeKey: arrieta-ibarra2022
year: 2022
doi: 10.48550/arXiv.2205.09680
zoteroKey: H2LT2XKK
citedIn:
- paper:refs.bib
---
Arrieta-Ibarra, Gujral, Tannen, Tygert & Xu (2022), arXiv:2205.09680.

Compares two families of calibration error metrics for binary-outcome probabilistic
predictions: **binned ECE** (histogram-based, requires bin-width/number choice) and
**cumulative ECCE** (no parameters, fully non-parametric). Key results from the paper:

- **ECE1/ECE2** (binned): Riemann sums over $m$ bins. Hit a noise floor of order
  $O(\nu^{-1})$ under perfect calibration where $\nu$ is draws-per-bin; Corollary 2
  proves $\liminf_n \text{ECE2} > c > 0$ if $\nu$ is bounded on an interval.
- **ECCE-MAD / ECCE-R** (cumulative): $C_k = n^{-1}\sum_{j=1}^k(R_j-S_j)$; metrics
  are $\max_k |C_k|$ and $\max C_k - \min C_k$. Under perfect calibration and a
  mild condition on score distribution, Corollary 7 proves $\text{ECCE-MAD}\to 0$ and
  $\text{ECCE-R}\to 0$ as $n\to\infty$ — no noise floor.
- **Theorem 11**: under imperfect calibration the ECCEs stay bounded away from 0.
- **Theorem 6**: asymptotically $\text{ECCE-MAD}/\sigma_n \to \sup|B_t|$ and
  $\text{ECCE-R}/\sigma_n \to \sup B_t - \inf B_t$ (Brownian motion extremes), with
  expected values $\sqrt{\pi/2}\approx 1.25$ and $2\sqrt{2/\pi}\approx 1.60$.
- P-values for ECCE statistics are available via the methods of Tygert (2022),
  arXiv:2202.00100.

Open-source reproducibility: https://github.com/facebookresearch/ecevecce.

**Why cite:** the first proof that cumulative calibration metrics provably dominate
binned metrics in consistency and power, and do so without tuning parameters. Shows
why a cumulative $W_1$ distance on PIT values is statistically well-motivated.
