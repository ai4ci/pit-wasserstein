---
class: task
id: correct-metrics-vignette-interpretation.md
title: Reconcile vignette metric explanations with the formulas and figures
status: done
kind: issue
priority: medium
touches:
- vignette:pit-w-metrics.Rmd
- vignette:model-misspecification.Rmd
- src:scoring.R#pit_w
---

<!-- loom:links start -->
- touches: [scoring.R](../../R/scoring.R)
- touches: [model-misspecification.Rmd](../../vignettes/model-misspecification.Rmd)
- touches: [pit-w-metrics.Rmd](../../vignettes/pit-w-metrics.Rmd)
<!-- loom:links end -->

The metrics vignette labels both CRPS and the baseline PIT score as panel B, although the assembled plot places CRPS in A. It also says the lower- and upper-tail departures cancel. The stated formula gives a positive contribution from each tail when the lower PIT lies below its rank and the upper PIT exceeds its rank. Describe the midpoint-rank statistic as a discrete comparison with a uniform reference grid. For a one-value sample with PIT 0.5 the score is zero, while the distance to continuous uniform is 0.25.

In the model-misspecification vignette, the gamma/log-normal discussion gives a positive directed score and describes the same comparison as conservative. Check which sign and comparison the simulation actually supports before revising the interpretation.

**Review of 25 November 2026.** The metric definitions now distinguish the midpoint and continuous references and explain why two heavy PIT tails both contribute positively to the directed score. Figure 1 identifies CRPS in panel A. The family study distinguishes swapping gamma and lognormal distributions from reporting a symmetric normal distribution.