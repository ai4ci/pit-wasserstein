---
class: task
id: formalise-bridge-functionals.md
title: Check the bridge functionals and directed variance in Lean
kind: feature
status: done
priority: high
touches:
- paper:main.tex
- proof:PITW/Scores.lean
- proof:PITW/Bridge.lean
- proof:PITW/Tests.lean
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [PITW/Bridge.lean](../../proof/PITW/Bridge.lean)
- touches: [PITW/Scores.lean](../../proof/PITW/Scores.lean)
- touches: [PITW/Tests.lean](../../proof/PITW/Tests.lean)

### Backlinks
- spawns: [Formalise the PIT significance test derivations in Lean](../plan/formalise-significance-tests.md)
<!-- loom:links end -->

The Lean library verifies the finite-sample scores, the midpoint approximation, the Gaussian shift profile and its cancellation from the directed statistic. Given the process convergence and adjustment assumptions, it derives the three limiting functionals and the two-sided Gaussian rejection probability with variance 1/48. The proof directory README lists the theorem statements and outstanding assumptions.