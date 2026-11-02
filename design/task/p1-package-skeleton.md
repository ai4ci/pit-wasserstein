---
class: task
title: "P1 package skeleton"
status: todo
priority: high
phase: P1
tags: [packaging]
blocks: [task:p2-extract-metric-api.md]
---

# Goal

Make the repository buildable and checkable as a package without touching the
paper or the science.

- `DESCRIPTION` (name, version 0.0.1, authors, license, `Imports`),
  `NAMESPACE`, `LICENSE`, `NEWS.md`, `.Rbuildignore` excluding `main/`,
  `design/`, `references/`, `analysis.R`, `.sandbox/`, `.Rproj.user`.
- `tests/testthat/` + `tests/testthat.R`, written **before** the code moves, so
  the tests are proven to fail first (`AGENTS.md`).
- Untrack LaTeX build artefacts: `main/main.{aux,bbl,blg,log,out}`. Keeping
  `main/main.pdf` committed is fine — the paper must compile without R.
- `lintr` already configured (`.lintr`); confirm it passes on the new files.

Blocked by `task:p2-extract-metric-api.md` only for the export list; the
scaffolding itself can land first, and it blocks P2 because there is nowhere to
put exported code until `DESCRIPTION` and `NAMESPACE` exist.
