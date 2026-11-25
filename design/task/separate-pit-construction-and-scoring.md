---
class: task
id: separate-pit-construction-and-scoring.md
title: Separate PIT construction and adjustment from metric calculation
status: todo
kind: feature
priority: medium
touches:
- src:scoring.R#pit_w
- src:scoring.R#prediction_scores
blocks:
- task:score-posterior-sample-forecasts.md
- task:score-quantile-forecasts.md
---

<!-- loom:links start -->
- blocks: [Accept posterior samples via an empirical CDF](score-posterior-sample-forecasts.md)
- blocks: [Accept forecasts specified by predictive quantiles](score-quantile-forecasts.md)
- touches: [scoring.R](../../R/scoring.R)
- touches: [scoring.R](../../R/scoring.R)

### Backlinks
- spawns: [Score forecasts supplied as draws or quantiles](../plan/prediction-distribution-inputs.md)
<!-- loom:links end -->

Factor the calculation shared by pit_w() and prediction_scores(). Keep forecast medians, link-scale or probit adjustment, and evaluation at the original and adjusted reference in the input stage. Score the two PIT vectors with their own midpoint ranks. Retain current grouped and ungrouped interfaces, tie handling, and conventional scores. Check equivalence on existing parametric examples including unequal scales where adjustment changes rank order.