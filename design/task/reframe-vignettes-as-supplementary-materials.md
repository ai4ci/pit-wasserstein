---
class: task
id: reframe-vignettes-as-supplementary-materials.md
title: Reframe the four figure vignettes as supplementary materials
status: todo
kind: feature
priority: medium
touches:
- vignette:figure-3.Rmd
- vignette:figure-4.Rmd
- vignette:introduction-to-pit.Rmd
- vignette:sir-epiestim-example.Rmd
- vignette:figure-3.Rmd
- vignette:figure-4.Rmd
---
The four vignettes (`vignettes/figure-1.Rmd` .. `figure-4.Rmd`, 135-325 lines
each) are currently bare figure-generation scripts: a title, `devtools::load_all()`,
and code that writes to `vignettes/main/fig/`. No prose explains what each
figure shows or why, beyond the title "figure-N".

Reframe them as the paper's supplementary materials:

- Each vignette gets an introductory paragraph stating what question the
  figure answers and how it relates to the paper's argument (point readers
  from the published paper to `vignette:figure-N.Rmd` the way a traditional
  paper points to "Supplementary Figure N").
- Narrate the simulation setup in prose before the code that builds it, not
  just inline comments — a reader checking reproducibility should be able to
  follow the logic without executing the chunks.
- Since the package will not go to CRAN (r-universe only), there is no need
  to keep the vignettes minimal for `R CMD check` vignette-build time limits;
  they can be as thorough as useful.
- Keep each vignette's actual simulation/plotting code as-is unless a bug is
  found while rewriting — this task is about narrative framing, not analysis
  changes. Any bug found while doing this is a separate pre-existing issue
  per AGENTS.md, not an in-scope fix here.

Consider adding one overview vignette (e.g. `vignettes/overview.Rmd`) that
links the four figure vignettes together as a supplementary-materials index,
so a reader lands somewhere coherent rather than picking a figure number at
random.
