---
class: task
id: expose-lean-declarations-in-loom.md
title: Expose Lean declarations as Loom source anchors
kind: issue
status: todo
priority: low
touches:
- proof:PITW/Baseline.lean
---

<!-- loom:links start -->
- touches: [PITW/Baseline.lean](../../proof/PITW/Baseline.lean)
<!-- loom:links end -->

Loom 0.17.0 recognises Lean and can prefetch its grammar. Its structure extractor returns no entries across the project’s Lean files. In Baseline.lean, iid_baseline_score_limit exists and Lean checks it. Loom lists no anchors, and validating a touches link to that theorem reports graph/missing-symbol. An upstream Lean declaration adapter or structure query could expose named theorems, lemmas and definitions. Test a real declaration and a misspelled name when upgrading Loom.

**Review of 25 November 2026.** Loom 0.17.2 now lists PITW.iid_sampling_limits in IidScores.lean and the early declarations in Baseline.lean, but loom ls proof:PITW/Baseline.lean --kind Theorem returns no entries although iid_baseline_score_limit is defined there. Keep this open for the missing declarations.