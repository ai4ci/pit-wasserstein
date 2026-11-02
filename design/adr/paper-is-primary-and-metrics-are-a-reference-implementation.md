---
class: adr
title: "The paper is primary and the metrics are a reference implementation"
status: accepted
decided: 2026-11-02
tags: [structure, packaging]
supersedes: [adr:repository-is-hybrid-package-and-paper.md]
mandates: [task:p2-extract-metric-api.md, task:p4-reproducibility-ci.md]
---

# Context

`adr:repository-is-hybrid-package-and-paper.md` decided to make this repository
both an R package and the paper. Working through P1 before writing any code
showed the package half costs far more than it returns.

The cost is not the metric functions — those are a few dozen lines. It is
everything around them:

1. **`R/` is not a namespace, it is a `source()` drop-box.** `.Rprofile` does
   `try(source("R/import-standalone-*.R"))` for four vendored `ggrrr` helper
   files, and `analysis.R` only works because of it (`fig_dir` at
   `analysis.R:17` and `.gg_pedantic()` at `analysis.R:15` both resolve through
   globalenv). Making `R/` a real namespace breaks `source("analysis.R")`, so
   "delete the `.Rprofile` hack" and "namespace `R/`" are one change, not two —
   which is what invalidated the claim in `task:p1-package-skeleton.md` that P1
   could land before P2.
2. **The figure and table machinery is the bulk of the surface area.** Every
   `here::here("main", "fig")` write, the `.gg_save_as()` / `.hux_save_as()`
   helpers, the Roboto font, the Chromium dependency for `tab1-params.pdf`
   (`issue:tab1-needs-chromium.md`) and the patchwork/ggplot2 4.x incompatibility
   (`issue:patchwork-ggplot2-incompatibility.md`) all have to be either packaged
   or excluded, and packaging them buys the paper nothing.
3. **A package cannot write into its own tree**, so `analysis.R` would have to
   move to `data-raw/` under a driver script — restructure for the sake of the
   layout rather than the reader.
4. **Nobody is the audience for an installable package here.** The thing other
   people need is the formulas, and the paper has them; the thing reviewers need
   is to check the figures against the definitions, which needs readable
   functions, not `install.packages()`.

Meanwhile the actual defect the package was meant to fix is real: the metric
definitions were duplicated and unreachable. `analysis.R` held a complete
`pitw()` implementation (old `analysis.R:120-172`) that was **never called** —
it was dead code — while the numbers in the published figures came from four
inline `purrr` lambdas inside `run_scenario()` (old `analysis.R:258-270`). The
ideal-uniform vector `unif` was rebuilt in three places. $P_{err}$, defined at
`\eqref{eq:tmp}`, was implemented nowhere.

# Decision

**Do not package.** This repository stays a paper with sourced R alongside it:
`main/` is the citable artefact, `analysis.R` is the script that regenerates the
figures, and `R/` is a set of files `source()`d by `.Rprofile`, not a namespace.
No `DESCRIPTION`, `NAMESPACE`, `LICENSE`, `man/` or `R CMD check`.

What replaces the packaging goal is a **single reference implementation of the
paper's core functions**, used consistently by the analysis:

- `R/metrics.R` defines `rank_of()`, `pit_w()` ($D^*_{pit}$, `\eqref{eq:pit2}`,
  and $U^*_{pit}$, `\eqref{eq:pit3}`), `coverage_prob()` (`\eqref{eq:cover}`),
  `threshold_misclass()` (`\eqref{eq:tmp}`) and `rlnorm4()` (the sharpness
  sampler).
- `run_scenario()` calls those functions instead of re-deriving the formulas
  inline, so there is exactly one definition of each metric in the repo.
- `tests/testthat/` tests the functions against the **paper's** stated
  properties (zero on perfect calibration, $D^*_{pit} \in [0, 0.5]$,
  $U^*_{pit} \in \pm 0.25$, bias-invariance), not against the old code's
  behaviour. Run with `Rscript --no-init-file tests/testthat.R`.
- `.Rprofile` keeps its `source()` role and gains `try(source("R/metrics.R"))`.

The `metric` and `figure` classes in the document model survive unchanged —
they describe the paper's objects, which was always orthogonal to packaging.

# Consequences

- `task:p1-package-skeleton.md` is `dropped`, not `done`. The one genuinely
  useful item in it — untracking `main/*.aux`, `.bbl`, `.blg`, `.log`, `.out` —
  moves to `task:p3-paper-standalone.md`, which is where a LaTeX-shaped repo
  belongs.
- `task:p2-extract-metric-api.md` is re-scoped to "reference implementation",
  which is what has now been built.
- The tests are not a package test suite: there is no `testthat.R` harness
  shipped to a checker, and `devtools::test()` / `devtools::check()` do not
  apply. `Rscript --no-init-file tests/testthat.R` is the entry point.
- Reproducibility becomes *more* important, not less, because there is no
  package boundary to lean on: `task:p4-reproducibility-ci.md` (seeding,
  `issue:figures-not-reproducible.md`, the 1000/10000 discrepancy of
  `issue:sample-size-discrepancy.md`) is now the main remaining risk to the
  figures.
- Revisit this decision if a second paper or an external user needs the metrics
  programmatically; at that point extract `R/metrics.R` alone rather than the
  whole repo.
