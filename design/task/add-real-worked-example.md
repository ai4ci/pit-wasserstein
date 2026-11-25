---
class: task
id: add-real-worked-example.md
title: 'Evaluate EpiEstim across epidemic sizes and estimation windows'
status: done
kind: feature
priority: high
touches:
- paper:main.tex
- vignette:sir-epiestim-example.Rmd
produces:
- resource:fig4-epiestim-by-epi-size.pdf
---
Figure 4 and its supplementary vignette use a deterministic SIR trajectory, 100 population sizes and 100 independent observation series per size. Each series supplies a single randomly chosen endpoint for all five windows. We score one estimate per series within each size and window. The earlier proposal for a within-epidemic low/high prevalence comparison was superseded. The [study design](../doc/paper-rewrite-skeleton.md#7-epiestim-across-epidemic-sizes-and-estimation-windows) and [reference-day issue](confirm-epiestim-window-and-reference-day.md) document the calculation used in the figure.

## Earlier design and results (superseded)

The following records the original experiment. Its sample counts, figure numbering and numerical results predate the independent-replicate design above.

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

---

## Outcome (2026-11-17)

Done. Implemented as `vignette:seir-example.Rmd`, producing
`resource:fig4-epiestim-by-epi-size.pdf` (panels A–D).

Two deviations from the scope above, both deliberate and both strengthening
the result:

1. **SEIR → deterministic SIR ODE.** The exposed compartment adds nothing: the
   requirement was an exact known $R_t$, and $R_t = R_0 S_t$ from a `deSolve`
   SIR solution delivers that with less machinery.
2. **Low-vs-high prevalence → a continuous sweep over epidemic size.** 100
   log-spaced population sizes from $10^{2.5}$ to $10^{5}$, ten replicates
   each, same epidemic shape throughout, peak observed case count as the
   x-axis. Two regimes would have given two points; the sweep shows a **sign
   change**, which is a much stronger statement than a difference.

Findings, scored with `prediction_scores(dist="gamma2", link="log",
threshold=1)` against the exact $R_t$:

- $D^*_{pit}$ rises monotonically with epidemic size and **crosses zero** at a
  peak of ~56 observed cases ($-0.079$ at peak 10, $+0.089$ at peak 1261).
  $U^*_{pit}$ is U-shaped with a minimum at ~47. EpiEstim is under-confident
  at low counts and over-confident at high counts — the predicted failure
  mode is confirmed, and the crossover is located.
- **CRPS ranks the forecaster in the opposite direction** (falls 0.183 →
  0.087, $r=-0.89$ with $\log_{10}$ peak, vs $r=+0.91$ for $D^*_{pit}$). CRPS
  is tracking sharpness, not calibration. Coverage sides with PIT-W: nominal
  95% intervals cover 91% at peak 10 and 51% at peak 1261. This is the
  paper's headline comparison, now made on an external estimator.
- Significance is read from the **analytical null** of
  `task:derive-analytical-null-distribution-for-pit-w-metrics.md`
  ($D^*\sim N(0,1/48n)$, $\mathbb{E}[U^*]=\sqrt{2\pi}/8\sqrt{n}$, median
  $n=76$): $z=-3.7$ at peak 10, $-1.0$ at peak 36, $+5.7$ at peak 1261. Only
  the 36–73 band is indistinguishable from calibrated.
- Bias is negative at every size ($-0.185 \to -0.088$). `U_pit_unadj` is
  0.24–0.30 and flat; adjusted `U_pit` is 0.05–0.10 and carries all the
  structure — bias invariance demonstrated on an error nobody designed.

Narrative placement: Section 7 of `doc:paper-rewrite-skeleton.md`.

Follow-ups deliberately **not** done here (raise separately if wanted):
- `EpiEstim` and `deSolve` are not yet in `DESCRIPTION` `Suggests`.
- The experiment shows *that* the sign changes, not *why* — Gamma(2,2) prior,
  7-day window and renewal-equation likelihood are not separated.
- `pObs` is fixed at 0.5, leaving a vestigial single-level `P(obs)` colour
  aesthetic in the figure.