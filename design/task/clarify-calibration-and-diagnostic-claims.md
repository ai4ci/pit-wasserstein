---
class: task
id: clarify-calibration-and-diagnostic-claims.md
title: Clarify what the three statistics can diagnose
status: todo
kind: paperFix
priority: medium
touches:
- paper:main.tex
- vignette:significance-testing.Rmd
- vignette:model-misspecification.Rmd
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [model-misspecification.Rmd](../../vignettes/model-misspecification.Rmd)
- touches: [significance-testing.Rmd](../../vignettes/significance-testing.Rmd)

### Backlinks
- spawns: [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md)
<!-- loom:links end -->

Reconcile the abstract, interpretation and discussion with the pooled PIT null defined in Methods. Failure to reject B does not establish conditional calibration. Pure width error can make all three tests reject. U large relative to |D| records departures that cancel in the signed score, including subgroup errors or a family mismatch. It cannot identify spread–skill decoupling on its own. In the simulation distinguish a correct median spread at c=1 from the calibration of the full forecast when spreads vary independently of error.