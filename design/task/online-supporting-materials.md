---
class: task
id: online-supporting-materials.md
title: Gather the supporting materials at one online address
status: todo
kind: paperFix
priority: medium
touches:
- paper:main.tex
- vignette:pitw.Rmd
- proof:PITW.lean
- src:scoring.R
- src:significance.R
- proof:PITW/IidScores.lean#PITW.iid_sampling_limits
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [PITW.lean](../../proof/PITW.lean)
- touches: [PITW/IidScores.lean](../../proof/PITW/IidScores.lean)
- touches: [scoring.R](../../R/scoring.R)
- touches: [significance.R](../../R/significance.R)
- touches: [pitw.Rmd](../../vignettes/pitw.Rmd)

### Backlinks
- spawns: [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md)
<!-- loom:links end -->

Provide one reader-facing landing page linked from the manuscript. Map Figures 1–4 and the supplementary simulations to their published articles. Include the R implementation of the scores and reference distributions, the Lean sources and build instructions, and a release or commit that identifies the version reviewed. Check the published article links, in particular the current manuscript slug sir-epiestim, whose source is sir-epiestim-example.Rmd. Confirm the links in the final PDF.
Specify the scope of the manuscript’s “formally proven in Lean” sentence when linking the proof. The Lean development proves the sampling limits and rejection results under stated assumptions. Evaluating the Airy series, simulating the adjusted reference and extrapolating its tail are numerical work outside that proof.