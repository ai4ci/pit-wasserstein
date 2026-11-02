---
class: doc
title: "Priorities"
tags: [meta]
---

# Priorities

Moved out of `README.md` when `main/` became the paper directory, and re-pointed
at loom when the design records became instances. The sequenced plan is
`doc:scope.md`; the live task list is the `backlog` view below. Research
directions that are not yet committed tasks are listed underneath so they are
not lost — promote one to a `task` instance when it is picked up.

<!-- loom view: backlog -->

- [P2 reference implementation of the paper's metrics](../task/p2-extract-metric-api.md)
- [P3 make the paper standalone](../task/p3-paper-standalone.md)
- [P4 reproducibility and CI](../task/p4-reproducibility-ci.md)
<!-- loom view: backlog end -->

## In progress (worktree at `8454e0a`, uncommitted as of 2026-11-02)

`task:p2-extract-metric-api.md` is partly done and **unverified end to end**:

- `R/metrics.R` + `tests/testthat/test-metrics.R` (26 passing) exist and
  `run_scenario()` now calls them. Old vs new `run_scenario()` agree to 2.8e-17
  on every metric column over the 9-row figure grid.
- Next: run the whole script once (`Rscript analysis.R`) to regenerate
  `main/fig/` and confirm the figures are unchanged — the equivalence proof
  covers the metric columns, not the plotting code.
- Then the open decisions on that task: whether `threshold_misclass()` gets a
  column (it is a paper change), the empty `design/metric/` and `design/figure/`
  instances, and deleting the unused vendored files
  (`issue:dist-fns-vendoring-incomplete.md`).
- Not started: `issue:figures-not-reproducible.md` — `analysis.R` still has no
  `set.seed()`, so `true_value` at `analysis.R:28` is an unseeded draw and any
  figure regeneration replaces the published figures with a different draw. Do
  not regenerate without deciding that first.

## Research directions (not yet tasks)

- Small-sample characterisation ($n = 50, 100, 500, 1000$).
- Non-normal prediction distributions (log-normal, gamma).
- Temporal autocorrelation effects.
- Bootstrap uncertainty bands on $D^*_{pit}$.
- Comparison with PCE, MCB, and coverage probability.
- Real data example.
- Caveat the bias-adjustment circularity: bias is estimated from the same data
  used to compute $D^*_{pit}$, which needs a note for small $n$.
- Soften the "proper scoring rule" claim for $D^*_{pit}$ — it is observed, not
  proven.
- Identify thresholds for significance of $D^*_{pit}$.

## Paper build state

- [ ] Recompile `main/main.pdf` — no working LaTeX in the sandbox
      (`issue:no-latex-in-sandbox.md`). `main/main.bbl` was carried over from the
      supplementary build; re-run bibtex after editing citations.
- [ ] `refs.bib` has no entry for the companion estimator paper, but the text
      still says "the main paper" in four places (`main.tex:74`, `:102`, `:114`,
      `:234`). Cite it or reword — part of `task:p3-paper-standalone.md`.
- [ ] Paper has no abstract — a standalone short paper needs one, also P3.
- [ ] `R/import-standalone-mixture-distributions.R` is unused by the script —
      delete it unless the paper gains mixture predictions, part of
      `task:p2-extract-metric-api.md`.
