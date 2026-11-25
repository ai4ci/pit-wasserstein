---
class: task
id: score-posterior-sample-forecasts.md
title: Accept posterior samples via an empirical CDF
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

Accept a set of draws for each forecast and evaluate its empirical CDF at the observed and adjusted reference. Specify the empirical median, handling of ties, endpoints and finite ensemble size, including what an endpoint PIT means for probit adjustment. Test small worked examples and convergence to parametric scores as the number of draws increases. Distinguish variation due to finite draws from variation across independent forecasts.