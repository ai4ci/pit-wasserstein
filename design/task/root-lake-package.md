---
class: task
id: root-lake-package.md
title: Expose the pinned Lake package and proof imports at repository root
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

The repository root contains the Lake manifest, toolchain pin and package configuration for pit-wasserstein. Lake resolves the PITW library from the proof directory. Verified the root build, imported the library and checked the joint sampling and directed-test theorems in a separate Git-dependent project, and inspected the R source archive for excluded Lean build files. Reservoir discovery depends on publication and its independent GitHub eligibility checks.