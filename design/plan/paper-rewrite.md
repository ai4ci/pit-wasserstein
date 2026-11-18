---
class: plan
id: paper-rewrite.md
title: Rewrite the appendix as a standalone short paper
status: active
rationale: The repo was converted to an R package; the paper and its design records need to follow.
spawns:
- task:readme-describes-pre-package-layout.md
- task:clarify-bias-adjusted-pit-diagnostic.md
- task:reframe-introduction-as-mathematical-methods-paper.md
- task:reframe-vignettes-as-supplementary-materials.md
- task:update-figure-3-compare-unadjusted-vs-adjusted-pit-w.md
- task:add-non-normal-distribution-robustness-study.md
- task:add-real-worked-example.md
- task:pit-w-notation-swapped-between-readme-and-paper.md
- task:mean-based-bias-estimator-fails-for-skewed-distributions.md
- task:rename-unadjusted-metric-to-b-pit.md
- task:integrate-jmlr-latex-style.md
informedBy:
- reference:wessel-2025-tail-calibration.md
- reference:gneiting-2007-calibration-and-sharpness.md
- reference:zhao-2020-individual-calibration.md
- reference:dheur-2023-probabilistic-calibration-study.md
---
The rewrite should distinguish the calibration of the original predictive distributions from the project's global bias-adjusted PIT-W diagnostic. The latter is a custom location-adjusted measure and should not be presented as standard PIT calibration or as a substitute for assessing conditional calibration.
## Strategic direction agreed 2026-11-13

Discussed with the user: the paper should move more firmly into "methods
paper" territory to make it easier to publish — less descriptive/educational
framing, more mathematical, grounded in the cited literature already recorded
under `design/reference/`. Three concrete strands, each spawned as its own
task below:

1. Fix the calibration / dispersion-calibration terminology split (already
   flagged by the authors — see `task:clarify-bias-adjusted-pit-diagnostic.md`,
   extended with this detail).
2. Rewrite the introduction and problem framing to be mathematical and
   citation-grounded rather than descriptive
   (`task:reframe-introduction-as-mathematical-methods-paper.md`).
3. Reframe the four figure vignettes as supplementary materials with
   narrative context, not bare figure-generation scripts
   (`task:reframe-vignettes-as-supplementary-materials.md`).

The significance-test research direction (sample size vs. the limiting
behaviour of $D^*_{pit}$, and a test of the null hypothesis that an estimator
is dispersion-calibrated) is **not** part of this plan. It is
`plan:dispersion-calibration-significance-test.md`, whose first task is
blocked on the terminology fix here, because the null hypothesis the test
targets needs "dispersion calibration" nailed down as a distinct, well
defined quantity first.
