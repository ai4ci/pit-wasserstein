---
class: task
title: "P1 package skeleton"
status: dropped
priority: high
phase: P1
tags: [packaging]
---

# Dropped

Superseded by `adr:paper-is-primary-and-metrics-are-a-reference-implementation.md`:
packaging the repo costs the whole figure/table machinery (vendored `ggrrr`
helpers, `here::here` output paths, Roboto, Chromium for
`issue:tab1-needs-chromium.md`) for no gain to the paper's reader.

The metric API this task existed to enable was built without packaging — see
`task:p2-extract-metric-api.md`.

## Carried over

The one item here that was worth doing moves to `task:p3-paper-standalone.md`:

- Untrack the LaTeX build artefacts already in git: `main/main.aux`,
  `main/main.bbl`, `main/main.blg`, `main/main.log`, `main/main.out`.

## Explicitly not coming back

- `DESCRIPTION`, `NAMESPACE`, `LICENSE`, `.Rbuildignore`, `man/`.
- Roxygen docs on the metric functions (plain `#'` comments in `R/metrics.R`
  are enough; nothing is built from them).
- Moving `analysis.R` to `data-raw/`.
