---
class: issue
title: "Figures are not reproducible"
status: open
severity: major
ownership: preExisting
raised: 2026-09-11
tags: [reproducibility]
followUp: task:p4-reproducibility-ci.md
---

# Symptom

`analysis.R` draws every scenario from `rnorm()` / `rlnorm()` / `runif()` with
no `set.seed()`, so re-running replaces the published figures with a different
draw. The committed `main/fig/*.pdf` therefore cannot be tied to any seed.

# Suggested fix

One `set.seed()` at the top of the script, and record the seed in the paper
alongside the simulation description (`\eqref{eq:valid}`). Needs to land with
`issue:sample-size-discrepancy`, or the regenerated figures encode the wrong
sample size.
