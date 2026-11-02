---
class: doc
title: "Scope and phased roadmap"
tags: [meta]
---

# Scope

This repository is a **hybrid**: an R package that implements the calibration
metrics, and the academic paper that defines them. Neither half is subordinate
to the other — the paper is the citable artefact, the package is what makes the
figures reproducible by someone other than the author.

The design records are loom instances: `design/adr/` holds architecture
decisions, `design/task/` the roadmap, `design/issue/` open issues,
`design/metric/` and `design/figure/` the paper's objects, `design/doc/` the
prose pages. The document model is `design/document-model.mmd` and links are
populated at **repository** level, not branch level.

## Architecture decisions

`doc:INDEX.md` carries the live rendered lists; the sections below are the
intent, and the ADRs are the record.

Three things define the shape of the hybrid:

1. **`R/` is the future package namespace**, addressed as `src:R/...`. The metric
   functions currently live in `analysis.R` (`pitw` at `analysis.R:120`, `crps`
   at `analysis.R:95`, `run_scenario` at `analysis.R:194`) and must move into
   `R/` to be exported; the vendored `ggrrr` helpers stay internal.
2. **`main/` stays LaTeX**, not Quarto. `main/fig/` keeps its committed
   artefacts so the paper compiles without running R, and build junk
   (`main/*.aux`, `.bbl`, `.log`, `.out`) stops being tracked.
3. **A package must not write into its own tree at runtime**, so
   `analysis.R`'s `here::here("main", "fig")` output path cannot survive into
   the package unchanged — it becomes a script under `data-raw/` or `inst/`,
   driven explicitly.

## Phased roadmap

- [ ] **P0 loom scaffold** — model, index pages, ADRs, this roadmap.
      `task:p0-loom-scaffold.md`
- [ ] **P1 package skeleton** — `DESCRIPTION`, `NAMESPACE`, `LICENSE`,
      `.Rbuildignore`, `tests/testthat/`, untrack LaTeX build artefacts.
      `task:p1-package-skeleton.md`
- [ ] **P2 move the metrics out of `analysis.R`** with roxygen docs and
      failing-first tests, then rewrite `.Rprofile`'s `source()` hack.
      `task:p2-extract-metric-api.md`
- [ ] **P3 make the paper standalone** — abstract, cite the companion paper
      rather than saying "the main paper" in four places, ship or vendor
      `unsrturl.bst`. `task:p3-paper-standalone.md`
- [ ] **P4 reproducibility and CI** — seeding, the 1000/10000 sample-size
      discrepancy, and a check workflow. `task:p4-reproducibility-ci.md`
