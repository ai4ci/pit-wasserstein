---
class: task
id: review-revised-paper-and-vignettes.md
title: Reconcile the vignettes and design records with the revised manuscript
status: done
kind: chore
priority: high
touches:
- vignette:sir-epiestim-example.Rmd
- paper:main.tex
- vignette:significance-testing.Rmd
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [significance-testing.Rmd](../../vignettes/significance-testing.Rmd)
- touches: [sir-epiestim-example.Rmd](../../vignettes/sir-epiestim-example.Rmd)

### Backlinks
- spawns: [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md)
<!-- loom:links end -->

Check the revised independent-replicate EpiEstim study against its generating code, review the other articles against the manuscript, and record outstanding manuscript decisions and future methodology separately.

All seven revised articles rendered in an isolated checkout. The EpiEstim run produced 50,000 estimates and 500 scores, with 100 independent predictions in every score. For the shortest window at the largest population the raw and adjusted interquartile coverage were 12% and 46%, compared with 0% and 2% for the longest window. The manuscript tasks record the remaining decisions on day alignment, diagnostic interpretation, power and supporting materials.