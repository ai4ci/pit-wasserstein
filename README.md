# Adjusted PIT-Wasserstein: A Calibration Metric for Probabilistic Estimators

A calibration metric for probabilistic estimators, disentangled from bias and
sharpness. Originally published as Supplementary Appendix 2 of
**Challen & Danon (2025), "Instantaneous Reproduction Number Estimation From
Modelled Incidence"** (PCOMPBIOL-D-26-00077, also on medRxiv); this repository
is the rework into a standalone short paper.

---

## Contents

| Path | Description |
|------|-------------|
| `analysis.R` | Simulations; writes every figure and table into `main/fig/` |
| `main/main.tex` | Paper source (compile from `main/`) |
| `main/refs.bib` | Bibliography, shared with the parent paper |
| `main/fig/` | Generated figures and the parameter table |
| `R/` | Standalone plotting/output helpers (vendored from `ggrrr`) |
| `references/literature-review.md` | Positioning against existing calibration metrics |
| `design/priorities.md` | What is left to do |
| `design/active-issues.md` | Open issues that need an author decision |

## Reproducing the figures

```r
# from the project root
install.packages(c("tidyverse", "scoringRules", "patchwork", "huxtable", "here"))
source("analysis.R")
```

Rendering needs a device that can draw the requested fonts, and
`tab1-params.pdf` additionally needs Chromium (see
`design/active-issues.md`). Then compile `main/main.tex` with any LaTeX engine.

---

## Core concepts

The paper defines two metrics for assessing **calibration**, separately from
bias and sharpness.

### Adjusted PIT-Wasserstein ($D^*_{pit}$)

$$D^*_{pit} = \frac{1}{n}\sum_{i=1}^n{|rank_i - u_{i,adj}|}$$

Where $rank_i = (i-0.5)/n$ and $u_{i,adj}$ are the bias-adjusted PIT values.

- **Range:** [0, 0.5]. Zero = perfect calibration.
- **Property:** Symmetric on log-calibration — conservative and overconfident
  estimators of equal magnitude score equally.
- **Validated:** Independent of bias and sharpness in simulation.

### Directed PIT-Wasserstein ($U^*_{pit}$)

$$U^*_{pit} = \frac{1}{n}\sum_{i=1}^n{(rank_i - u_{i,adj}) \times \sgn(0.5-rank_i)}$$

- **Range:** [-0.25, +0.25]
- **Direction:** Positive = overconfident (U-shaped PIT histogram); Negative =
  conservative (dome-shaped).

---

## Literature context

Closest existing work; all of it is in the `pit-wasserstein` Zotero collection,
and `references/literature-review.md` has the detail.

| Paper | Metric | Difference from $D^*_{pit}$ |
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

### Summary of novelty

The **adjusted PIT-Wasserstein ($D^*_{pit}$)** appears to be genuinely novel as
a **standalone evaluative calibration metric** because it uniquely combines:

1. **Bias adjustment** before PIT uniformity assessment (no other metric does this)
2. **Wasserstein/L1 distance** rather than sup-norm (PCE) or binning (reliability diagrams)
3. **Signed direction** ($U^*_{pit}$) distinguishing overconfidence from over-conservatism
4. **Validation** showing it is independent of bias and sharpness

The closest existing metrics (Wessel et al.'s MCB, Kuleshov et al.'s PCE)
measure raw PIT uniformity without de-biasing, so they conflate bias with
miscalibration.
