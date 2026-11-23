---
class: task
id: check-epiestim-vignette-inference.md
title: Revisit the EpiEstim reference values and inference with overlapping windows
status: todo
kind: issue
priority: high
touches:
- vignette:sir-epiestim-example.Rmd
- src:significance.R
---

<!-- loom:links start -->
- touches: [significance.R](../../R/significance.R)
- touches: [sir-epiestim-example.Rmd](../../vignettes/sir-epiestim-example.Rmd)
<!-- loom:links end -->

The example uses the baseline Brownian-bridge mean for the adjusted undirected score. The implementation uses a simulated adjusted reference. The example treats nominal reference values for independent PITs as grounds for a statistical conclusion, while the seven-day windows share data. The significance vignette explicitly identifies rolling estimates as violating the independence assumption.

Keep the comparison descriptive until a supported reference accounts for the overlapping estimates. If numerical reference values are retained for illustration, identify the right metric and state what comparison the reference supports.

The figure also colours the panels by the current significance calls. Review those colours and any legend or caption alongside the numerical interpretation.

The example also describes seven-day windows and exclusion of windows without cases. The actual EpiEstim index pairs are 7–14 through 93–100 inclusive (eight counts), and the filter is on positive counts on the matched reference day. The incidence vector starts at simulation day zero but t_end is a one-based row index. Joining t_end to the simulation day places the reference one day after the last incidence in the window. Check whether this alignment was intended before changing the example. The paper describes the calculation as run.
