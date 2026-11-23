---
class: task
id: correct-power-vignette-interpretation.md
title: Correct the sample-size vignette descriptions of the plots and power
status: todo
kind: issue
priority: medium
touches:
- vignette:sample-sizes-and-power.Rmd
---

<!-- loom:links start -->
- touches: [sample-sizes-and-power.Rmd](../../vignettes/sample-sizes-and-power.Rmd)
<!-- loom:links end -->

Figure 2 places the three scores in panels and facets each score by sample size. The prose calls each panel a sample size. The vignette also explains power using the height of the bulk of the score distribution above the line and refers to the median crossing in Figure 3 as a direct answer to the sample-size question. The rejection proportion across replicates estimates power, and a median crossing represents a different summary.

Describe which levels are panels and facets. State that the dashed lines are reference cut-offs and that the plots show distributions of scores. Base any target-power recommendation on rejection proportions for the specified scenario.

The fixed-sample experiment also describes the three bias levels as multiples of the error standard deviation. generate_simulation() passes bias_location directly to the normal generator while bias_scale is drawn separately. The offsets 0, 0.5 and 1 are therefore in outcome units for Figure 2. For Figure 3 the error standard deviation is fixed at one.
