---
class: plan
id: paper-rewrite.md
title: Rewrite the appendix as a standalone methods paper
status: active
rationale: The agreed JMLR scope covers the original PIT distance, the two location-adjusted diagnostics and their sampling references.
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
- task:review-revised-paper-and-vignettes.md
- task:online-supporting-materials.md
- task:confirm-epiestim-window-and-reference-day.md
- task:clarify-epiestim-figure-and-inference.md
- task:clarify-calibration-and-diagnostic-claims.md
- task:clarify-location-shift-and-fitted-reference.md
- task:clarify-power-and-replicate-envelopes.md
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

The [significance-test plan](dispersion-calibration-significance-test.md) developed the independent-prediction references. The terminology task is complete and the manuscript uses its definitions.

The author-reviewed [manuscript](../../vignettes/main/main.tex) includes the independent-prediction reference distributions and four figures. The EpiEstim figure uses one estimate per series within each population and window setting. Six supplementary articles give the simulation designs and calculations. The proposed rejection-rate table is commented out of the manuscript. The [significance article](../../vignettes/significance-testing.Rmd) computes the marginal rejection rates with the sample median. The linked paper tasks record the remaining decisions. Serial dependence and multivariate prediction are separate future plans.