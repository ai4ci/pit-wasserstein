---
class: task
id: clarify-epiestim-figure-and-inference.md
title: Clarify Figure 4 and the limits of the EpiEstim comparison
status: todo
kind: paperFix
priority: high
touches:
- paper:main.tex
- vignette:sir-epiestim-example.Rmd
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [sir-epiestim-example.Rmd](../../vignettes/sir-epiestim-example.Rmd)

### Backlinks
- blocks: [Confirm the EpiEstim observation windows and reference day](confirm-epiestim-window-and-reference-day.md)
- spawns: [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md)
<!-- loom:links end -->

In the methods and Figure 4, give the confirmed endpoint and width convention, 100 independent series per point and paired comparisons across five windows. Define peak as the maximum across all days and 100 replicates at one population size. Mean predictive-median minus reference is signed bias with zero as its target. Identify the baseline iid-uniform cutoff and the two fitted common-scale Gaussian benchmarks used for gamma posteriors with variable scales. Describe the change in sign and the effect of window choice in this simulation. A smoothed crossing, prior reversion and an optimal rule for future outbreaks require different evidence. Reconcile the descriptive caption with the stronger claims in the results and discussion.