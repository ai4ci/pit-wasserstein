---
class: task
title: "P4 reproducibility and CI"
status: todo
priority: medium
phase: P4
tags: [reproducibility, ci]
---

# Goal

Someone cloning the repo must be able to regenerate every figure and get the
same numbers the paper reports.

- Resolve `issue:sample-size-discrepancy` (needs an author decision on which
  number is authoritative) and `issue:figures-not-reproducible`.
- `.github/workflows/` exists but is **empty** — no CI at all. Add a check
  workflow: `devtools::check()`, `lintr`, and `loom validate --check` +
  `loom render --check`. Note `.github/` is read-only in the scoder sandbox, so
  the workflow file has to be authored on the host.
- Font/device dependencies documented in `issue:roboto-not-installed` and
  `issue:tab1-needs-chromium` need a CI story or the figures cannot be rebuilt
  headlessly.
- Patch version bump discipline per `AGENTS.md`.
