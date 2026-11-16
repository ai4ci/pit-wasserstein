---
class: task
id: add-real-worked-example.md
title: 'EpiEstim on simulated SEIR data: differential calibration at low vs high prevalence'
status: todo
kind: feature
priority: high
touches:
- paper:main.tex
---
Concrete scope agreed with the user 2026-11-13, replacing the earlier
"depends on data availability" framing — this doesn't need real surveillance
data, it needs one new simulation plus a genuinely external, independent
estimator:

1. Simulate an SEIR epidemic with a **known, exact $R_t$ trajectory** (ground
   truth no real dataset can give you).
2. Run **EpiEstim** (the widely used external R package, not this package's
   own `generate_simulation()` framework) on the resulting incidence to
   produce $R_t$ estimates with their stated credible intervals, in two
   regimes from the same simulation: a **low-prevalence** period and a
   **high-prevalence** period.
3. Score both regimes with $D^*_{pit}$/$U^*_{pit}$ against the known true
   $R_t$. EpiEstim is documented to become overconfident at high incidence
   (its Poisson/Gamma renewal-equation likelihood understates variance as
   counts grow), so the expected result is a *differential* dispersion
   calibration between the two regimes from a single, well-characterised,
   independently-implemented estimator — not a synthetic bias injected by
   this package's own simulator.

Why this is the stronger choice over hunting for a real dataset: the SEIR
simulation gives exact ground truth (a real surveillance dataset never does
for $R_t$), while EpiEstim's independent implementation and its known,
previously-documented failure mode under high incidence mean the result is
a genuine finding, not a circular demonstration of the paper's own
simulation framework working on itself.

Practical notes for whoever picks this up:
- `EpiEstim` is a new dependency — not currently in `DESCRIPTION`. Add it to
  `Imports` or `Suggests` (likely `Suggests` plus a vignette-only use, since
  the core package doesn't need it at runtime).
- Likely lands as a new vignette (see
  `task:reframe-vignettes-as-supplementary-materials.md`) plus a
  corresponding results paragraph/figure in `main.tex` — link the new
  vignette file with `loom link task:add-real-worked-example.md touches
  vignette:<name>.Rmd` once it exists; loom cannot link to a file that
  doesn't exist on disk yet.
- No SEIR simulator currently exists in this package (`R/simulation.R` only
  has the bias/sharpness estimator-generation framework used elsewhere in
  the paper) — this is new code, not a reuse of existing capability like the
  non-normal-distribution task is.

Can proceed regardless of the short-communication-vs-full-paper decision,
though a short communication may not have room for it — see
`task:decide-publication-format-short-communication-or-full-paper.md`.
