---
class: plan
id: package-lean-proofs.md
title: Make the PIT significance proofs reusable as a root Lake package
status: done
rationale: Expose the proof library to downstream Lean projects and Reservoir while retaining the R package layout.
spawns:
- task:root-lake-package.md
- task:rename-lean-library.md
- task:consolidate-brownian-area-sources.md
informedBy:
- reference:johnson-killeen-1983-l1-brownian-bridge.md
- reference:takacs-1993-absolute-brownian-motion.md
---

<!-- loom:links start -->
- informedBy: [An explicit formula for the c.d.f. of the L1 norm of the Brownian bridge](../reference/johnson-killeen-1983-l1-brownian-bridge.md)
- informedBy: [On the Distribution of the Integral of the Absolute Value of the Brownian Motion](../reference/takacs-1993-absolute-brownian-motion.md)
- spawns: [Consolidate the Brownian area source transcriptions in their reference records](../task/consolidate-brownian-area-sources.md)
- spawns: [Use PITW as the public Lean module name](../task/rename-lean-library.md)
- spawns: [Expose the pinned Lake package and proof imports at repository root](../task/root-lake-package.md)
<!-- loom:links end -->
