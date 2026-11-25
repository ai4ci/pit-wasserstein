---
class: task
id: confirm-epiestim-window-and-reference-day.md
title: Confirm the EpiEstim observation windows and reference day
status: todo
kind: issue
priority: high
touches:
- vignette:sir-epiestim-example.Rmd
- paper:main.tex
blocks:
- task:clarify-epiestim-figure-and-inference.md
---

<!-- loom:links start -->
- blocks: [Clarify Figure 4 and the limits of the EpiEstim comparison](clarify-epiestim-figure-and-inference.md)
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [sir-epiestim-example.Rmd](../../vignettes/sir-epiestim-example.Rmd)

### Backlinks
- spawns: [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md)
<!-- loom:links end -->

In Figure 4 the legend is t_end − t_start. EpiEstim sums seq(t_start, t_end), so labels 2, 4, 7, 10 and 14 denote 3, 5, 8, 11 and 15 observations. The endpoint index is uniform on 40…75. The first incidence element is day 0, so t_end = 40 uses observations through day 39 but joins the truth on day 40. The offset matters for bias on a declining trajectory. Decide whether the estimand is end-day or next-day R_t and whether width means elapsed days or number of counts. If the calculation changes, regenerate and compare Figure 4 and the supporting coverage results. Otherwise explicitly label the convention in both accounts. The unit of replication is already correct.