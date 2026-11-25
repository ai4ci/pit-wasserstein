---
class: plan
id: prediction-distribution-inputs.md
title: Score forecasts supplied as draws or quantiles
status: draft
spawns:
- task:separate-pit-construction-and-scoring.md
- task:score-posterior-sample-forecasts.md
- task:score-quantile-forecasts.md
---

<!-- loom:links start -->
- spawns: [Accept posterior samples via an empirical CDF](../task/score-posterior-sample-forecasts.md)
- spawns: [Accept forecasts specified by predictive quantiles](../task/score-quantile-forecasts.md)
- spawns: [Separate PIT construction and adjustment from metric calculation](../task/separate-pit-construction-and-scoring.md)
<!-- loom:links end -->

Short-term package work. Separate construction of raw and adjusted PITs from rank-based scoring so forecasts supplied in different forms can share the three metric calculations. Preserve the behaviour of the parametric interfaces and document how discretisation affects the interpretation of each new input.