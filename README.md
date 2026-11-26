# Adjusted PIT-Wasserstein: A Calibration Metric for Probabilistic Estimators  <img src="man/figures/logo.png" align="right" height="139" alt="" />

  <!-- badges: start -->
[![R-CMD-check](https://github.com/ai4ci/pit-wasserstein/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/ai4ci/ggoutbreak/actions/workflows/R-CMD-check.yaml)
[![R-universe version](https://ai4ci.r-universe.dev/pitw/badges/version)](https://ai4ci.r-universe.dev/pitw)
[![DOI](https://zenodo.org/badge/github/1361599864.svg)](https://doi.org/10.5281/zenodo.24555797)
[![EPSRC badge](https://img.shields.io/badge/EPSRC%20grant-EP%2FY028392%2F1-05acb5)](https://gtr.ukri.org/projects?ref=EP%2FY028392%2F1)
<!-- badges: end -->


A dispersion calibration metric for probabilistic estimators, disentangled from bias and
sharpness. Originally published as Supplementary Appendix 2 of
**Challen & Danon (2025), "Instantaneous Reproduction Number Estimation From
Modelled Incidence"**; this repository is the extension into a standalone paper.

The [Lean proof library](proof/README.md) gives the asymptotic null laws for all three tests and instructions for importing them into another Lean project.

---

## Core concepts

The paper defines three metrics for assessing probabilistic estimators and 
differentiating between, bias, dispersion miscalibration, and skill-spread
decoupling.

### Baseline PIT-Wasserstein ($B_{pit}$)

$$B_{pit} = \frac{1}{n}\sum_{i=1}^n{|u_i - rank_i|}$$

Where $rank_i = (i-0.5)/n$ and $u_i$ are the PIT values.

- **Range:** [0, 0.5]. Zero = perfect calibration and zero bias.
- **Property:** Symmetric on log-calibration for a given bias.
- **Validated:** Dependent on bias, dispersion calibration and sharpness in simulation.

### Adjusted PIT-Wasserstein ($U^*_{pit}$)

$$U_{pit} = \frac{1}{n}\sum_{i=1}^n{|u_{i,adj} - rank_i|}$$

Where $rank_i = (i-0.5)/n$ and $u_{i,adj}$ are the bias-adjusted PIT values.

- **Range:** [0, 0.5]. Zero = perfect calibration.
- **Property:** Symmetric on log-calibration — conservative and overconfident
  estimators of equal magnitude score equally.
- **Validated:** Independent of bias and sharpness in simulation.

### Directed PIT-Wasserstein ($D^*_{pit}$)

$$D_{pit} = \frac{1}{n}\sum_{i=1}^n{(rank_i - u_{i,adj}) \times \operatorname{sgn}(0.5-rank_i)}$$

- **Range:** [-0.25, +0.25]
- **Direction:** Positive = overconfident (U-shaped PIT histogram); Negative =
  conservative (dome-shaped).

All three metrics have significance tests based on large-sample reference
distributions for independent PIT values. The adjusted tests use reference laws
derived for the Gaussian location model.

---

## Literature context

Closest existing work; all of it is in the `pit-wasserstein` Zotero collection,
and `references/literature-review.md` has the detail.

| Paper | Metric | Difference from $U^*_{pit}$ |
|-------|--------|----------------------------|
| **Wessel et al. (2025)** arXiv:2506.13687 | **MCB** = mean \|sorted PIT - uniform\| | No bias adjustment. Used as regularisation during training, not evaluation. |
| **Wilks (2018)** QJRMS 144:76–88 | Miscalibration penalty (deviations of PIT from uniform) | First PIT-uniformity penalty. Qualitative/binned, not Wasserstein. |
| **Kuleshov, Fenner & Ermon (2018)** ICML | PCE = sup-norm \|PIT CDF - uniform CDF\| | Sup-norm (KS-style), not L1/Wasserstein. No bias adjustment. |
| **Dheur & Ben Taieb (2023)** ICML | PCE (same definition) | Large-scale empirical study of PCE. |
| **Gneiting, Balabdaoui & Raftery (2007)** JRSS-B | — | Canonical PIT/calibration/sharpness framework. |
| **Hamill (2001)** MWR 129:550–560 | — | Rank histograms for ensemble verification. |
| **Brockwell (2007)** Stat. Prob. Lett. | — | Universal residuals / PIT residuals. |
| **Podsztavek et al. (2024)** ESANN | — | ML classification of PIT histogram shapes. |
| **Arrieta-Ibarra et al. (2022)** JMLR 23 | — | Survey of calibration metrics; reliability diagrams. |
| **Panaretos & Zemel (2019)** Annu. Rev. Stat. Appl. | — | Wasserstein distances in statistics. |
| **Bosse et al. (2024)** arXiv:2205.07090 | — | `scoringutils` has the AD test for PIT uniformity, no Wasserstein calibration metric. |

### Summary

The **adjusted PIT-Wasserstein ($U^*_{pit}$)** combines:

1. **Bias adjustment** before PIT uniformity assessment (no other metric does this)
2. **Wasserstein/L1 distance** rather than sup-norm (PCE) or binning (reliability diagrams)
3. **Signed direction** ($D^*_{pit}$) distinguishing overconfidence from over-conservatism
4. **Validation** showing it is independent of bias and sharpness

The closest existing metrics (Wessel et al.'s MCB, Kuleshov et al.'s PCE)
measure raw PIT uniformity without de-biasing, so represent calibration as 
both bias and dispersion calibration and are not informative on dispersion 
miscalibration in the presence of bias.
