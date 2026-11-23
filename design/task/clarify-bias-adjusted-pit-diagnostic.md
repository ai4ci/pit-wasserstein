---
class: task
id: clarify-bias-adjusted-pit-diagnostic.md
title: Clarify standard calibration versus the bias-adjusted PIT diagnostic
status: done
kind: paperFix
priority: high
touches:
- paper:main.tex
- src:scoring.R#pit_w
- paper:rewrite/main.tex
blocks:
- task:reframe-introduction-as-mathematical-methods-paper.md
- task:characterise-d-pit-sampling-distribution-by-simulation.md
---
The scratch discussion raised a useful framing issue, but its source claims are not reliable enough to cite as evidence. Standard probabilistic calibration is assessed from PIT values of the original forecast distributions, so it reflects location and spread together. This project's metric first estimates a global mean link-scale error from forecast medians and shifts the outcomes before computing the PIT distance; describe this as a separate bias-adjusted diagnostic, not calibration of the unchanged forecasts or an established “centred PIT Wasserstein” standard.

When revising the paper:

- Define the adjustment precisely, including its link scale and global estimation.
- Present adjusted and unadjusted PIT distances alongside the bias and a proper score; state that a single global shift does not establish conditional or group calibration.
- Keep the novelty claim narrow: the Wasserstein-1 PIT-to-uniform distance is prior work ([Zhao et al. (2020)](../reference/zhao-2020-individual-calibration.md); [Dheur & Ben Taieb (2023)](../reference/dheur-2023-probabilistic-calibration-study.md)); argue only for the adjustment, signed direction, and evaluative use as supported by the paper.
- Do not cite Hamill (2001) as support for explicitly removing mean bias before a PIT/rank histogram unless the primary text is checked; the existing reference record only supports the histogram caveat.

The discussion's 1D squared-Wasserstein mean/centered-shape decomposition is not directly the project's W1 method, so it is out of scope for this paper unless the paper itself changes direction.
## Extended scope 2026-11-13: calibration vs. dispersion calibration throughout

This is the same underlying confusion the task was already raised for, now
scoped across the whole paper rather than just the Zotero-discussion framing
issue.

The authors already flagged it themselves:

> `main.tex:61` — `% TODO: rephrase lookg at replacing calibration with
> disersion calibration thoughout & explain the difference`

Concretely, "calibration" currently means two different things in the same
document:

- `main.tex:63` (intro): calibration is the joint property affected by bias
  *and* spread together — the standard PIT-uniformity sense.
- `main.tex:76`, and the Fig. 1 caption (`main.tex:72`, "...is the true value
  of **the dispersion calibration**"): calibration is the bias-independent
  ratio $\sigma_\mathcal{S}/\sigma_\mathcal{E}$ that $D^*_{pit}$ and
  $U^*_{pit}$ actually measure.

Everywhere from line 76 onward the paper means the second sense but mostly
writes "calibration" unqualified (e.g. `main.tex:162`, `:219`, `:224`,
`:240`, `:260`, `:263`).

Suggested fix: define **dispersion calibration** precisely and early (as the
ratio of spread parameters, independent of bias), keep **calibration**
(unqualified) for the joint PIT-uniformity sense only where discussing prior
literature (Dawid 1984, Diebold et al. 1998, Gneiting et al. 2007), and
search-and-replace every later use that actually means the bias-independent
quantity to "dispersion calibration". This also sharpens the novelty claim:
the paper is not proposing a new *calibration* metric in the Gneiting/Dawid
sense (Zhao 2020 and Dheur & Ben Taieb 2023 already have Wasserstein-1
calibration metrics), it is proposing a bias-adjusted **dispersion**
calibration metric, which is the actually novel combination.

Also carries the paper's own stated future-work line, now with a home:

> `main.tex:240` — "Further work is required to characterise the behaviour
> of this in small samples, and to identify thresholds for significance."

See `plan:dispersion-calibration-significance-test.md`.

## Terminology for $\kappa_\mathcal{S}$ (raised 2026-11-13)

The paper currently calls $\kappa_\mathcal{S}$ "a measure of the intrinsic
variability of estimate confidence" (`main.tex:187`); in discussion it gets
called "inconsistent confidence". Neither is quite right, and the imprecision
hides a point worth making.

**The failure mode is not heterogeneity of $\sigma_i$ per se.** If the stated
uncertainty varied *in step with* the realised per-prediction error, the PIT
values would be uniform and the estimator perfectly calibrated — that is what
a good heteroscedastic model does. The simulation (`eq:valid`) draws
$\sigma_i$ *independently* of the realised error, so what the metric penalises
is **stated uncertainty that varies without tracking actual error**.

Suggested terminology, best first:

- **"spread-error decoupling"** — names the mechanism, and anchors to the
  established *spread-skill relationship* in ensemble verification, which
  gives a citation hook near
  [reference:hamill-2001-rank-histograms.md](../reference/hamill-2001-rank-histograms.md).
- **"spurious sharpness variation"** — emphasises that the variation is
  uninformative rather than merely present.
- **"conditional dispersion miscalibration"** — slots into the Gneiting
  hierarchy (marginal dispersion correct, conditional calibration failing);
  most precise, least readable. See
  [reference:gneiting-resin-2023-regression-diagnostics.md](../reference/gneiting-resin-2023-regression-diagnostics.md).

Recommendation: use *spread-error decoupling* in prose, keep
$\kappa_\mathcal{S}$ as the parameter name, and avoid "inconsistent
confidence" — it reads as a property of the forecaster rather than of the
forecast-error relationship.

Note this interacts with the main terminology fix in this task: an estimator
with $\kappa>0$ and correct median dispersion is **not** dispersion
calibrated, so the definitions must not imply that getting the average width
right is sufficient.

Completed in the standalone [rewrite](../../vignettes/main/rewrite/main.tex). Equations 1–3 distinguish the raw and adjusted ranks, the median shift on the chosen link scale, and the signed and unsigned summaries. The text distinguishes pooled uniformity from conditional calibration.
