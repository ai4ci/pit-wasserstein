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