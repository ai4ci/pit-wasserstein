---
class: plan
id: formalise-significance-tests.md
title: Formalise the PIT significance test derivations in Lean
status: done
spawns:
- task:formalise-bridge-functionals.md
- task:prove-joint-pit-quantile-and-median-limit.md
- task:construct-gaussian-bridge-path-law.md
- task:link-lean-proofs.md
---

<!-- loom:links start -->
- spawns: [Discharge the Gaussian path and integrability assumptions for the pinned bridge](../task/construct-gaussian-bridge-path-law.md)
- spawns: [Check the bridge functionals and directed variance in Lean](../task/formalise-bridge-functionals.md)
- spawns: [Make Lean proof results addressable from the design graph](../task/link-lean-proofs.md)
- spawns: [Derive the joint PIT quantile and median limit from iid sampling](../task/prove-joint-pit-quantile-and-median-limit.md)
<!-- loom:links end -->

Follow the sampling references in the current manuscript from the ordered PIT statistics to their limiting laws. Verify each mathematical step against the pinned Mathlib, recording the probabilistic assumptions that still separate a conditional result from an end-to-end proof.