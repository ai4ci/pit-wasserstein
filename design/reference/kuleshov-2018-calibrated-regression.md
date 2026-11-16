---
class: reference
id: kuleshov-2018-calibrated-regression.md
title: Accurate Uncertainties for Deep Learning Using Calibrated Regression
citeKey: Kuleshov_Fenner_Ermon_2018
year: 2018
doi: 10.48550/arXiv.1807.00263
citedIn:
- paper:refs.bib
---
Kuleshov, Fenner & Ermon (2018), ICML 2018.

Introduces the **probabilistic calibration error (PCE)**:

$$PCE = \sum_{j=1}^m w_j |\hat{p}_j - p_j|$$

where the bins $p_j$ partition [0,1] and $\hat{p}_j$ is the empirical
proportion of observations falling below quantile $p_j$.

- Sup-norm style (Kolmogorov-Smirnov), not L1/Wasserstein
- Binned, not exact
- No bias adjustment
- Widely adopted in the ML calibration literature

**Why cite:** PCE is the main competing calibration metric.
