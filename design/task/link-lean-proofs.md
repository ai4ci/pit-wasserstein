---
class: task
id: link-lean-proofs.md
title: Make Lean proof results addressable from the design graph
status: done
kind: chore
priority: medium
touches:
- proof:PITW/Baseline.lean
- proof:PITW.lean
---

<!-- loom:links start -->
- touches: [PITW.lean](../../proof/PITW.lean)
- touches: [PITW/Baseline.lean](../../proof/PITW/Baseline.lean)

### Backlinks
- spawns: [Formalise the PIT significance test derivations in Lean](../plan/formalise-significance-tests.md)
<!-- loom:links end -->

The proof source subtype covers the Lake project under `proof/`, including the top-level import module and the Lean modules under `proof/PITW/`. The three significance-test tasks link to the modules that establish their results. Loom 0.17.1 supports whole-file links here. Lean theorem and definition anchors remain an open issue.