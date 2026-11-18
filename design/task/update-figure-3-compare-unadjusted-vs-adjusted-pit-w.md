---
class: task
id: update-figure-3-compare-unadjusted-vs-adjusted-pit-w.md
title: 'Rework Figure 3: unadjusted vs adjusted/directed PIT-W, plus PCE/MCB comparison'
status: done
kind: paperFix
priority: high
touches:
- vignette:pit-w-metrics.Rmd
- paper:main.tex
- src:scoring.R#pit_w
produces:
- resource:fig3-metric-compare.pdf
---
Rework Fig. 3 to make the paper's central claim (bias-invariance) a picture,
not only a paragraph, and to show the literature's competing metrics failing
where this one doesn't — not just describe that they would in the lit
review.

Currently (`main.tex:219-224`): panel A is CRPS, panel B is 50% coverage
probability, panels C/D are adjusted and directed PIT-Wasserstein. Panel B is
a different, generic calibration proxy, not the thing being compared
against.

Agreed rework, discussed with the user 2026-11-13:

- Swap panel B for the **existing unadjusted PIT-Wasserstein** ($U_{pit,unadj}$,
  already computed by `pit_w()` — `src:scoring.R#pit_w`'s `B_pit`
  return value). This is the metric that already exists in the literature
  ([Zhao et al. (2020)](../reference/zhao-2020-individual-calibration.md),
  [Dheur & Ben Taieb (2023)](../reference/dheur-2023-probabilistic-calibration-study.md)):
  plotting it against the same bias/calibration sweep as panels C/D, on the
  same axes, shows directly that it moves with bias while the adjusted
  metric doesn't — the comparison *is* the novelty argument.
- **Also add a quantified comparison against PCE (Kuleshov et al. 2018) and/or
  the unadjusted MCB (Wessel et al. 2025)** over the same simulated
  estimators, rather than only arguing in prose that they conflate bias with
  miscalibration. This is the strongest available version of the paper's
  novelty claim and is cheap to add while already reworking this figure and
  its underlying simulation sweep.
- Move the displaced 50% coverage probability panel to a supplementary
  vignette rather than dropping it outright — it's a legitimate metric, just
  not the comparison this figure should lead with.

Can proceed regardless of the short-communication-vs-full-paper decision in
[task:decide-publication-format-short-communication-or-full-paper.md](decide-publication-format-short-communication-or-full-paper.md).
