---
class: reference
id: bosse-2024-scoringutils.md
title: Evaluating Forecasts with scoringutils in R
citeKey: bosse2024
year: 2024
doi: 10.48550/arXiv.2205.07090
zoteroKey: 4R72QCZK
citedIn:
- paper:refs.bib
---
Bosse, Gruson, Cori, van Leeuwen, Funk & Abbott (2024), arXiv:2205.07090, *Journal
of Statistical Software* 109(2).

The `scoringutils` R package paper. Key features relevant to calibration:

- **PIT histograms** (Section 2.5): the package computes and visualises PIT
  histograms; triangular shape → bias, U-shaped → underdispersion, dome →
  overdispersion.
- **Coverage plots** (Section 2.5): compares empirical vs nominal quantile and
  interval coverage for quantile-based forecasts; deviations from diagonal
  indicate miscalibration.
- **Anderson–Darling test** (Section 2.5): the package documentation mentions
  performing a formal AD test on PIT uniformity, but the authors note it is
  "often too quick to reject the null" and PIT uniformity does not guarantee
  calibration (citing Gneiting et al. 2007; Hamill 2001).
- **WIS decomposition** (Appendix C): proper scoring rule (weighted interval
  score) decomposed into overprediction, underprediction, and dispersion
  components — related but distinct from PIT-Wasserstein.
- **Pairwise comparison** (Section 3.2): relative skill scores based on
  geometric means of score ratios between forecasters.

The package explicitly notes (Section 5): "It is currently does not support
statistical testing of forecast performance as part of its core workflow."

**Why cite:** the current standard R tooling for probabilistic forecast
evaluation; its reliance on PIT histograms + AD test illustrates the gap that
$D^*_{pit}$ and $U^*_{pit}$ fill — scalar, constructive, directional metrics.
