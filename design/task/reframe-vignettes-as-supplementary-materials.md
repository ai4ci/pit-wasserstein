---
class: task
id: reframe-vignettes-as-supplementary-materials.md
title: Reframe the four figure vignettes as supplementary materials
status: done
kind: feature
priority: medium
touches:
- vignette:pit-w-metrics.Rmd
- vignette:sample-sizes-and-power.Rmd
- vignette:introduction-to-pit.Rmd
- vignette:sir-epiestim-example.Rmd
- vignette:significance-testing.Rmd
- vignette:model-misspecification.Rmd
---
The figure vignettes were originally bare figure-generation scripts named
`figure-1.Rmd` .. `figure-4.Rmd`: a title, `devtools::load_all()`, and code
that wrote to `vignettes/main/fig/`, with no prose explaining what each figure
showed or why.

**Renamed 2026-11-18** as part of this reframing, so the links above point at
the current filenames:

| was | now |
|---|---|
| `figure-1.Rmd`, `figure-2.Rmd` | `vignette:introduction-to-pit.Rmd` |
| `figure-3.Rmd` | `vignette:pit-w-metrics.Rmd` |
| `figure-4.Rmd` | `vignette:sample-sizes-and-power.Rmd` |
| (new) | `vignette:significance-testing.Rmd`, `vignette:sir-epiestim-example.Rmd` |

Reframe them as the paper's supplementary materials:

- Each vignette gets an introductory paragraph stating what question the
  figure answers and how it relates to the paper's argument (point readers
  from the published paper to the named vignette the way a traditional
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

---

## Done (2026-11-18)

All five vignettes have been narrated. Each now opens by stating what question
it answers and how it relates to the paper's argument, and describes its
simulation setup in prose before the code that builds it.

| Vignette | Role | Paper figure |
|---|---|---|
| `vignette:introduction-to-pit.Rmd` | background for an uninitiated reader: calibration, the two failure modes, spread–error decoupling, PIT histograms | not in the paper — referred to online |
| `vignette:pit-w-metrics.Rmd` | simulation setup, metric definitions, the bias-invariance comparison against CRPS and coverage | Figure 1 |
| `vignette:sample-sizes-and-power.Rmd` | two simulations: separation at fixed $n$, and power against $n$ | Figures 2 and 3 |
| `vignette:significance-testing.Rmd` | the Brownian-bridge link, the Kolmogorov–Smirnov analogy, and the three null distributions | — |
| `vignette:sir-epiestim-example.Rmd` | the metrics applied to an external estimator across epidemic sizes | Figure 5 |
| `vignette:model-misspecification.Rmd` | what the metrics do when the predictive family is wrong | — |

Two deviations from the scope above, both deliberate:

- The vignettes were renamed from `figure-N.Rmd` to descriptive names, so they
  no longer depend on a figure numbering that the paper rewrite is changing.
- Simulation code was left alone, as scoped. Three defects found while writing
  the prose were raised separately rather than fixed inline:
  `task:b-pit-computed-against-adjusted-ranks.md`,
  `task:qgamma4-not-the-inverse-of-pgamma4.md` and the legacy `biased` column
  in `vignette:sample-sizes-and-power.Rmd` (fixed by the user directly).

**Not done:** the optional overview/index vignette suggested at the end of the
original scope. The cross-references at the foot of each vignette partly cover
it. Raise as its own task if a single landing page is wanted.
