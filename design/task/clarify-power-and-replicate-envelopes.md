---
class: task
id: clarify-power-and-replicate-envelopes.md
title: Clarify the replicate ranges and power statements in Figures 2 and 3
status: todo
kind: paperFix
priority: medium
touches:
- paper:main.tex
- vignette:sample-sizes-and-power.Rmd
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [sample-sizes-and-power.Rmd](../../vignettes/sample-sizes-and-power.Rmd)

### Backlinks
- spawns: [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md)
<!-- loom:links end -->

Figure 3 shows medians and the 2.5th–97.5th percentiles of 250 replicate scores in all three panels. The dashed thresholds are one-sided for B and U and two-sided for D. Revise the reference to one- or two-sided confidence intervals and distinguish null rejection rates from power under alternatives. For the “at most 100” claim, give the score, scenario, sample size and observed fraction beyond threshold, or describe the median crossing only. The decoupled simulation fixes median reported spread, with CV one, so “same mean spread” is misleading. Resolve the dangling “Model misspecification” after the supplementary article citation.

For the 250 overconfident replicates in the vignette, B, D and U rejected in 60.0%, 94.4% and 89.6% at n = 77. At n = 129 the corresponding fractions were 90.4%, 98.8% and 97.6%. These are the two plotted sample sizes either side of 100.