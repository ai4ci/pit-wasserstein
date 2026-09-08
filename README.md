# Adjusted PIT-Wasserstein: A Calibration Metric for Probabilistic Estimators

Originally published as Supplementary Appendix 2 of:
**Challen & Danon (2025), "Instantaneous Reproduction Number Estimation From Modelled Incidence"**
(PLOS Computational Biology submission PCOMPBIOL-D-26-00077, also on medRxiv)

This directory contains the source files for potential reworking into a standalone short paper.

---

## Contents

| Path | Description |
|------|-------------|
| `s2/s2.tex` | LaTeX source for Supplementary Appendix 2 |
| `s2/s2.pdf` | Compiled PDF |
| `s2/s2.bbl` | Compiled bibliography |
| `s2/fig/` | Generated figures (PDF, EPS) |
| `s2-metrics-validation.R` | Full R code to reproduce all figures and simulations |
| `R/` | Standalone utility functions (imported from ggoutbreak-methods) |
| `main/refs.bib` | Shared bibliography from parent paper |

---

## Core concepts

The supplement defines two novel metrics for assessing **calibration** of probabilistic estimators, disentangled from bias and sharpness:

### Adjusted PIT-Wasserstein ($D^*_{pit}$)

$$D^*_{pit} = \frac{1}{n}\sum_{i=1}^n{|rank_i - u_{i,adj}|}$$

Where $rank_i = (i-0.5)/n$ and $u_{i,adj}$ are bias-adjusted PIT values.

- **Range:** [0, 0.5]. Zero = perfect calibration.
- **Property:** Symmetric on log-calibration (conservative and overconfident of equal magnitude score equally).
- **Validated:** Independent of bias and sharpness in simulation.

### Directed PIT-Wasserstein ($U^*_{pit}$)

$$U^*_{pit} = \frac{1}{n}\sum_{i=1}^n{(rank_i - u_{i,adj}) \times \sgn(0.5-rank_i)}$$

- **Range:** [-0.25, +0.25]
- **Direction:** Positive = overconfident (U-shaped PIT histogram); Negative = conservative (dome-shaped)
- **Note:** The sign in the current s2.tex text description is **inverted** — the equation and code are correct, but the prose says "-0.25 for over-confidence ... +0.25 for excessive uncertainty" when it should be the reverse.

---

## How to reproduce

```r
# Install dependencies
install.packages(c("tidyverse", "scoringRules", "ggpp", "patchwork"))
# ggoutbreak is only needed for helper functions (.gg_pedantic, .gg_save_as, std_size)
# These are duplicated in R/ for the standalone version — we should replace them

# Run the analysis
source("s2-metrics-validation.R")
```

### R package dependencies
- **tidyverse** (ggplot2, dplyr, tidyr, purrr, forcats)
- **scoringRules** (for `crps_norm`, `crps_cnorm`)
- **ggpp** (for `geom_label_npc`)
- **patchwork** (for plot composition)
- **ggoutbreak** (currently needed for `.gg_pedantic()`, `.gg_save_as()`, `std_size` — these should be replaced with standalone equivalents for the new paper)

---

## Literature context

The following papers form the closest existing work. All have been added to the `pit-wasserstein` Zotero collection.

### Closest: Wasserstein distance from uniform PIT

| Paper | Metric | Difference from $D^*_{pit}$ |
|-------|--------|----------------------------|
| **Wessel et al. (2025)** arXiv:2506.13687 | **MCB** = mean \|sorted PIT - uniform\| | No bias adjustment. Used as regularisation during training, not evaluation. |
| **Wilks (2018)** QJRMS 144:76–88 | Miscalibration penalty (deviations of PIT from uniform) | First use of PIT-uniformity penalty. Qualitative/binned, not Wasserstein metric. |

### Probabilistic Calibration Error (PCE)

| Paper | Metric | Difference |
|-------|--------|-----------|
| **Kuleshov, Fenner & Ermon (2018)** ICML | PCE = sup-norm \|PIT CDF - uniform CDF\| | Sup-norm (KS-style), not L1/Wasserstein. No bias adjustment. |
| **Dheur & Ben Taieb (2023)** ICML | PCE (same definition) | Large-scale empirical study of PCE. |

### PIT histogram analysis

| Paper | Relevance |
|-------|-----------|
| **Gneiting, Balabdaoui & Raftery (2007)** JRSS-B | Canonical PIT/calibration/sharpness framework. |
| **Hamill (2001)** MWR 129:550–560 | Rank histograms for ensemble verification. |
| **Brockwell (2007)** Stat. Prob. Lett. | Universal residuals / PIT residuals. |
| **Podsztavek et al. (2024)** ESANN | Automated ML classification of PIT histogram shapes. |
| **Arrieta-Ibarra et al. (2022)** JMLR 23 | Survey of calibration metrics; reliability diagrams. |

### Wasserstein distances

| Paper | Relevance |
|-------|-----------|
| **Panaretos & Zemel (2019)** Annu. Rev. Stat. Appl. | Comprehensive review of Wasserstein distances in statistics. |

### Tooling

| Paper | Relevance |
|-------|-----------|
| **Bosse et al. (2024)** arXiv:2205.07090 | scoringutils R package — implements AD test for PIT uniformity but no Wasserstein-based calibration metric. |

### Summary of novelty

The **adjusted PIT-Wasserstein ($D^*_{pit}$)** appears to be genuinely novel as a **standalone evaluative calibration metric** because it uniquely combines:
1. **Bias adjustment** before PIT uniformity assessment (no other metric does this)
2. **Wasserstein/L1 distance** rather than sup-norm (PCE) or binning (reliability diagrams)
3. **Signed direction** ($U^*_{pit}$) distinguishing overconfidence from over-conservatism
4. **Validation** showing it is independent of bias and sharpness

The closest existing metrics (Wessel et al.'s MCB, Kuleshov et al.'s PCE) measure raw PIT uniformity without de-biasing, making them conflate bias with miscalibration.

---

## Known issues (to fix in standalone version)

1. **Sign error in $U^*_{pit}$ text** — s2.tex line 145 says "-0.25 for over-confidence ... +0.25 for excessive uncertainty". The equation and R code give +0.25 for overconfidence (U-shaped) and -0.25 for conservatism (dome-shaped). Fix: swap the sign descriptions.

2. **Notation error** — eq (eq:bias) uses $g'$ (derivative) instead of $g^{-1}$ (inverse link function).

3. **Sentence fragment** — s2.tex line 129: "PIT values (also sometimes described as universal residuals [7]) $u_i$." Missing verb.

4. **Bias-adjustment circularity** — bias is estimated from the same data used to compute $D^*_{pit}$. Needs caveat for small $n$.

5. **"Proper scoring rule" claim** — the text says $D^*_{pit}$ "appears to be a proper scoring rule for calibration". This is empirical, not proven. Should be softened.

6. **ggoutbreak dependency** — for standalone paper, replace `.gg_pedantic()`, `.gg_save_as()`, `std_size` with self-contained versions or remove ggoutbreak dependency.

---

## Planned extensions for standalone paper

- [ ] Small-sample characterisation ($n = 50, 100, 500, 1000$)
- [ ] Non-normal prediction distributions (log-normal, gamma)
- [ ] Temporal autocorrelation effects
- [ ] Bootstrap uncertainty bands on $D^*_{pit}$
- [ ] Comparison with PCE, MCB, and coverage probability
- [ ] Real data example
- [ ] Fix sign bug, notation error, sentence fragment
