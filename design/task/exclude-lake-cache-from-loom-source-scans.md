---
class: task
id: exclude-lake-cache-from-loom-source-scans.md
title: Loom scans Git-ignored files during source validation
kind: issue
status: done
priority: low
touches:
- proof:PITW/Baseline.lean
---

<!-- loom:links start -->
- touches: [PITW/Baseline.lean](../../proof/PITW/Baseline.lean)
<!-- loom:links end -->

Loom 0.17.0 scanned the Git-ignored Lake cache during source validation. With the source root at `proof/`, a dry-run link used more than 6 GB of resident memory before it was stopped. The temporary workaround rooted the source prefix at `proof/Proof/`.

The reproduction uses a Git repository with a `proof/` source root, a `src implements task` relation and a `/.lake` rule in `proof/.gitignore`. An R function contains a reverse link to a missing task. In 0.17.0, validation reported that link even under `proof/.lake/`.

Verified in Loom 0.17.1. Validation reports the dangling link in `proof/probe.R` and passes when the same file moves to `proof/.lake/probe.R`. Git confirms the file matches the nested ignore rule. The source prefix now covers the whole Lake project.