---
class: task
id: rename-lean-library.md
title: Use PITW as the public Lean module name
status: done
kind: chore
priority: medium
touches:
- proof:PITW.lean
---

<!-- loom:links start -->
- touches: [PITW.lean](../../proof/PITW.lean)

### Backlinks
- spawns: [Make the PIT significance proofs reusable as a root Lake package](../plan/package-lean-proofs.md)
<!-- loom:links end -->

Use PITW as the default Lake target and the public module prefix. A downstream project can import PITW or individual modules such as PITW.IidRankPath. The package dependency is named pit-wasserstein and the theorem namespace is PITW.