---
class: task
id: readme-directed-pit-sign.md
title: README reverses the sign of the directed PIT-Wasserstein formula
kind: issue
status: done
priority: medium
touches:
- src:scoring.R#pit_w
---

<!-- loom:links start -->
- touches: [scoring.R](../../R/scoring.R)
<!-- loom:links end -->

The README formula uses `adjusted PIT - midpoint rank` multiplied by the sign of `0.5 - midpoint rank`. The package and manuscript use `midpoint rank - adjusted PIT`. The README prose gives the package convention, with positive scores for overconfidence. The baseline heading also repeats the symbol for the adjusted undirected metric. Align both the formula and the baseline heading with the scoring code.


The README now uses the same sign as the scoring implementation and labels the baseline metric B_pit.