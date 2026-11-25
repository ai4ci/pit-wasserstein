---
class: task
id: score-quantile-forecasts.md
title: Accept forecasts specified by predictive quantiles
status: todo
kind: feature
priority: medium
touches:
- src:scoring.R
- src:interfaces.R
---

<!-- loom:links start -->
- touches: [interfaces.R](../../R/interfaces.R)
- touches: [scoring.R](../../R/scoring.R)

### Backlinks
- blocks: [Separate PIT construction and adjustment from metric calculation](separate-pit-construction-and-scoring.md)
- spawns: [Score forecasts supplied as draws or quantiles](../plan/prediction-distribution-inputs.md)
<!-- loom:links end -->

Accept paired probabilities and quantile values for each forecast. Specify interpolation, support and tail behaviour, recovery of the median, and treatment of tied or crossing quantiles. Exercise observations and adjusted references inside and outside the supplied grid. Compare against an analytical CDF on progressively finer grids and document which scores depend on the interpolation and tail assumptions.