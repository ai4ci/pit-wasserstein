---
class: task
id: reframe-introduction-as-mathematical-methods-paper.md
title: Reframe the introduction as a mathematical methods paper, not an educational piece
status: todo
kind: paperFix
priority: high
touches:
- paper:main.tex
---
The current introduction (`main.tex:63-76`) is descriptive and informal —
"a probabilistic estimator has three aspects which determine its utility",
analogies, no equations until the CRPS section. To read as a methods paper
rather than an educational piece, rewrite it to:

- State bias, sharpness and dispersion calibration as mathematical
  definitions from the first mention, not prose descriptions — the
  definitions already exist later in the paper (`main.tex:168-187`); move the
  formal statement earlier and let the intro reference it rather than
  re-describe it informally.
- Ground every general claim in the cited literature instead of asserting it:
  the calibration/sharpness trade-off should cite
  [Gneiting, Balabdaoui & Raftery (2007)](../reference/gneiting-2007-calibration-and-sharpness.md)
  and [DeGroot & Fienberg (1983)](../reference/degroot-1983-comparison-of-forecasters.md)
  at first mention, not only in the later related-work paragraph.
- State the gap explicitly and early, citing the specific papers it is a gap
  *relative to*: [Zhao et al. (2020)](../reference/zhao-2020-individual-calibration.md)
  and [Dheur & Ben Taieb (2023)](../reference/dheur-2023-probabilistic-calibration-study.md)
  already measure calibration via Wasserstein-1 distance from PIT to uniform;
  [Wessel et al. (2025)](../reference/wessel-2025-tail-calibration.md) already has
  the identical unadjusted formula as a training loss. The contribution is the
  bias adjustment, the signed direction, and evaluative use — say so in the
  first paragraph, not after the fact.
- Depends on `task:clarify-bias-adjusted-pit-diagnostic.md` landing first:
  the mathematical definitions should use "dispersion calibration"
  consistently from the outset, not the current conflated usage.

Scope note (ponytail): do not expand this into a full literature review in
the introduction — one grounding citation per claim is enough; the longer
positioning argument already lives in `design/doc/literature-review.md` and
should stay there, not be duplicated into the paper prose.
