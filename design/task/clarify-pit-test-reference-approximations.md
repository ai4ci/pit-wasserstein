---
class: task
id: clarify-pit-test-reference-approximations.md
title: Package documentation describes limiting PIT-Wasserstein tests as exact
kind: issue
status: todo
priority: high
touches:
- src:significance.R
- vignette:significance-testing.Rmd
---

<!-- loom:links start -->
- touches: [significance.R](../../R/significance.R)
- touches: [significance-testing.Rmd](../../vignettes/significance-testing.Rmd)
<!-- loom:links end -->

DESCRIPTION calls the three tests exact or numerically exact. The baseline code evaluates the limiting Brownian bridge law, the adjusted undirected code simulates a median-projected limiting bridge and extrapolates the upper tail, and the directed code uses a large-sample Gaussian reference. For example, at n = 1 the raw distance under uniform PIT is Uniform(0, 0.5), and the directed score is identically zero. Align DESCRIPTION and the significance help with the distinction between a limiting law and a finite-sample test. State the forecast-family and adjustment assumptions for the adjusted references, and retain the vignette guidance on independent PIT values.


Updated DESCRIPTION, the checked-in help pages, and the significance vignette to describe the three limiting references and the common-scale Gaussian setting for the adjusted tests. The roxygen comments in R/significance.R still need the same wording before regenerating the help pages.

The vignette review found a remaining statement in the baseline test section of the significance vignette that the function returns an exact p-value. Align that passage and the scope of the adjusted-reference discussion with the large-sample model and assumptions.

Several simulation chunks in the significance vignette, including the rejection-rate comparison, centre errors with rowMeans(e). The package and the adjusted reference in the paper use sample medians. Reconcile these calculations before presenting them as validation of the implemented adjusted tests. The paper includes the code for its median-adjusted comparison.

**Review of 25 November 2026.** The baseline vignette uses a large-sample p-value and the link-scale simulation examples now use the sample median. The roxygen source still describes finite-sample exactness or universal fitted references. Keep this task open for the package-source changes.