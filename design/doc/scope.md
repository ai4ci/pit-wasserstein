---
class: doc
title: "Scope and phased roadmap"
tags: [meta]
---

# Scope

This repository is a **paper with sourced R alongside it**. `main/` is the
citable artefact, `analysis.R` is the script that regenerates the figures, and
`R/metrics.R` is a single readable reference implementation of every metric the
paper defines. It is deliberately **not** an R package — see
`adr:paper-is-primary-and-metrics-are-a-reference-implementation.md`, which
supersedes the earlier hybrid-package decision.

The design records are loom instances: `design/adr/` holds architecture
decisions, `design/task/` the roadmap, `design/issue/` open issues,
`design/metric/` and `design/figure/` the paper's objects, `design/doc/` the
prose pages. The document model is `design/document-model.mmd` and links are
populated at **repository** level, not branch level.

## Architecture decisions

`doc:INDEX.md` carries the live rendered lists; the sections below are the
intent, and the ADRs are the record.

Three things define the shape:

1. **One definition per metric, in `R/metrics.R`.** `R/` is a `source()`
   drop-box loaded by `.Rprofile`, not a namespace. `pit_w()` ($D^*_{pit}$,
   $U^*_{pit}$), `coverage_prob()`, `threshold_misclass()` and `rlnorm4()` live
   there and `run_scenario()` calls them; the vendored `ggrrr` plotting and
   table helpers stay internal and dot-prefixed. `crps()` / `crps_norm()` stay
   in `analysis.R` — CRPS is cited to `scoringRules`, not defined by this paper.
2. **Tests assert the paper's properties**, not the old code's behaviour.
   `Rscript --no-init-file tests/testthat.R` (there is no package, so
   `devtools::test()` does not apply).
3. **`main/` stays LaTeX**, not Quarto. `main/fig/` keeps its committed
   artefacts so the paper compiles without running R, and tracked build junk
   (`main/*.aux`, `.bbl`, `.blg`, `.log`, `.out`) should stop being tracked.

## Phased roadmap

- [ ] **P0 loom scaffold** — model, index pages, ADRs, this roadmap.
      `task:p0-loom-scaffold.md`
- [x] ~~**P1 package skeleton**~~ — dropped; packaging costs the figure
      machinery for no gain to the reader. Untracking LaTeX build artefacts
      moved to P3. `task:p1-package-skeleton.md`
- [ ] **P2 reference implementation of the metrics** in `R/metrics.R`, tested
      against the paper and called by `run_scenario()`. Largely done.
      `task:p2-extract-metric-api.md`
- [ ] **P3 make the paper standalone** — abstract, cite the companion paper
      rather than saying "the main paper" in four places, ship or vendor
      `unsrturl.bst`. `task:p3-paper-standalone.md`
- [ ] **P4 reproducibility and CI** — seeding, the 1000/10000 sample-size
      discrepancy, and a check workflow. `task:p4-reproducibility-ci.md`
