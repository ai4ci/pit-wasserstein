---
class: task
id: construct-gaussian-bridge-path-law.md
title: Discharge the Gaussian path and integrability assumptions for the pinned bridge
kind: feature
status: done
priority: high
touches:
- paper:main.tex
- proof:PITW/ContinuousGaussian.lean
- proof:PITW/BrownianBridge.lean
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [PITW/BrownianBridge.lean](../../proof/PITW/BrownianBridge.lean)
- touches: [PITW/ContinuousGaussian.lean](../../proof/PITW/ContinuousGaussian.lean)

### Backlinks
- spawns: [Formalise the PIT significance test derivations in Lean](../plan/formalise-significance-tests.md)
<!-- loom:links end -->

Choose a concrete continuous Brownian version, pin it at time one, and show that the resulting zero-extended L¹ path has a Gaussian law. Establish the product integrability conditions needed for both applications of Fubini in the directed-test proof.
Lean now derives the Gaussian path law for every Mathlib real Brownian motion using finite Gaussian projections and uniform Bernstein approximation on continuous paths. The supremum-norm second moment gives the integrability bounds for Fubini. The resulting directed law and rejection theorem require no extra bridge regularity assumptions.