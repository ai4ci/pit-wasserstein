---
class: task
id: qualify-vignette-diagnostic-interpretation.md
title: Qualify vignette claims about what PIT departures identify
status: todo
kind: issue
priority: high
touches:
- vignette:significance-testing.Rmd
- vignette:model-misspecification.Rmd
- vignette:introduction-to-pit.Rmd
---

<!-- loom:links start -->
- touches: [introduction-to-pit.Rmd](../../vignettes/introduction-to-pit.Rmd)
- touches: [model-misspecification.Rmd](../../vignettes/model-misspecification.Rmd)
- touches: [significance-testing.Rmd](../../vignettes/significance-testing.Rmd)
<!-- loom:links end -->

The significance vignette's interpretation table assigns location and dispersion error when all three tests reject. Pure spread error can produce that pattern. Using 100 standard normal midpoint quantiles as observations and normal forecasts with mean 0 and SD 0.3 gave all three p-values below 0.05, with zero common location shift. Likewise, the model-misspecification table treats non-rejection of the adjusted scores as evidence that family and width are correct. The introductory histogram table presents simulated shapes as uniquely identifying causes.

Revise the tables to describe patterns compatible with the evidence. Scope the empirical signatures to the simulated alternatives, and distinguish evidence of a PIT departure from identification of its cause or evidence of calibration.
