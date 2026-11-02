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

- [P0 loom scaffold](../task/p0-loom-scaffold.md)
- [P1 package skeleton](../task/p1-package-skeleton.md)
- [P2 extract the metric API from analysis.R](../task/p2-extract-metric-api.md)
- [P3 make the paper standalone](../task/p3-paper-standalone.md)
- [P4 reproducibility and CI](../task/p4-reproducibility-ci.md)
<!-- loom view: backlog end -->

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
