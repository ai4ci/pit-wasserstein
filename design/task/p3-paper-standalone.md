---
class: task
title: "P3 make the paper standalone"
status: todo
priority: medium
phase: P3
tags: [paper]
---

# Goal

`main/main.tex` is still written as Supplementary Appendix 2 of the estimator
paper. As a standalone short paper it needs:

- **An abstract** (`main.tex` has none — `\maketitle` goes straight to
  `\section{Background}`).
- **The companion paper cited, not implied.** "the main paper" appears at
  `main.tex:74`, `main.tex:102`, `main.tex:114` and `main.tex:234`, and
  `main/refs.bib` has no entry for it.
- **`\bibliographystyle{unsrturl}` satisfiable outside the author's machine** —
  `unsrturl.bst` is in neither the repo nor the sandbox TeX tree, so commit the
  `.bst` or switch to a stock style.
- Re-run `bibtex`: `main/main.bbl` was carried over from the supplementary
  build.

Then seed `design/metric/` and `design/figure/` from the paper so the `metrics`
and `figures` views are populated, and link each metric to its equation
(`eq:crps`, `eq:bias`, `eq:ubias`, `eq:sharp`, `eq:cover`, `eq:pit2`, `eq:pit3`,
`eq:tmp`) and its implementing function.
