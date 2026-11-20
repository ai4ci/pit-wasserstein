---
class: task
id: probit-adjusted-quantile-missing-parameters.md
title: Probit-adjusted outcomes use default forecast distribution parameters
kind: issue
status: done
priority: high
touches:
- src:scoring.R#prediction_scores
---

<!-- loom:links start -->
- touches: [scoring.R](../../R/scoring.R)
<!-- loom:links end -->

In the probit branch, `prediction_scores()` computes `adj_true_value = inv_cdf(u_i)` with the quantile function defaults. A grouped normal example with outcomes -1, 0, and 1, forecast means 0, and forecast SDs 2 yields adjusted outcomes -0.5, 0, and 0.5 even though the median probit shift is zero. This feeds adjusted coverage and the threshold score. Pass each forecast location and scale into the inverse CDF and check that mapping the adjusted outcome back to a PIT reproduces `u_i` for continuous forecasts.


Verified the saved fix with the original zero-shift normal example and a second normal example with varying forecast locations and scales and a nonzero median shift. Reapplying each forecast CDF to its adjusted outcome reproduced the adjusted PIT. The existing scoring and significance tests also passed.