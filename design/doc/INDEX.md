---
class: doc
id: INDEX.md
title: Design index
---
Design index for the pit-wasserstein repository. Everything below is generated
by `loom render` from `design/document-model.mmd`.

## Active plans

<!-- loom view: activePlans -->

| uri | status |
| --- | --- |
| [Significance test for H0: estimator is dispersion-calibrated](../plan/dispersion-calibration-significance-test.md) | active |
| [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md) | active |
<!-- loom view: activePlans end -->

## Open tasks

<!-- loom view: openTasks -->

| uri | status | priority |
| --- | --- | --- |
| [Revisit the EpiEstim reference values and inference with overlapping windows](../task/check-epiestim-vignette-inference.md) | todo | high |
| [Package documentation describes limiting PIT-Wasserstein tests as exact](../task/clarify-pit-test-reference-approximations.md) | todo | high |
| [Qualify vignette claims about what PIT departures identify](../task/qualify-vignette-diagnostic-interpretation.md) | todo | high |
| [Integrate JMLR LaTeX style file for the paper](../task/integrate-jmlr-latex-style.md) | doing | high |
| [Reconcile vignette metric explanations with the formulas and figures](../task/correct-metrics-vignette-interpretation.md) | todo | medium |
| [Correct the sample-size vignette descriptions of the plots and power](../task/correct-power-vignette-interpretation.md) | todo | medium |
| [Find or tabulate a c.d.f. for the bias-adjusted U_pit null](../task/derive-cdf-of-the-adjusted-u-pit-null.md) | todo | medium |
| [Huxtable PDF export unit test fails in scoder](../task/hux-pdf-export-test-fails-in-scoder.md) | todo | medium |
| [Verify GitHub license recognition for Reservoir](../task/verify-reservoir-license-detection.md) | todo | medium |
| [Correct the DOI for Johnson and Killeen (1983)](../task/verify-johnson-killeen-doi.md) | todo | low |
| [Expose Lean declarations as Loom source anchors](../task/expose-lean-declarations-in-loom.md) | todo | low |
<!-- loom view: openTasks end -->

## References

<!-- loom view: references -->

| uri | citeKey | year |
| --- | --- | --- |
| [Enforcing tail calibration when training probabilistic forecast models](../reference/wessel-2025-tail-calibration.md) | wessel2025 | 2025 |
| [Evaluating Forecasts with scoringutils in R](../reference/bosse-2024-scoringutils.md) | bosse2024 | 2024 |
| [Automatic Miscalibration Diagnosis: Interpreting Probability Integral Transform (PIT) Histograms](../reference/podsztavek-2024-automatic-miscalibration-diagnosis.md) | podsztavek2024 | 2024 |
| [Scoring Epidemiological Forecasts on Transformed Scales](../reference/bosse-2023-scoring-epidemiological.md) | bosse2023 | 2023 |
| [A Large-Scale Study of Probabilistic Calibration in Neural Network Regression](../reference/dheur-2023-probabilistic-calibration-study.md) | dheur2023 | 2023 |
| [Regression Diagnostics meets Forecast Evaluation: Conditional Calibration, Reliability Diagrams, and Coefficient of Determination](../reference/gneiting-resin-2023-regression-diagnostics.md) | gneiting2023 | 2023 |
| [Metrics of Calibration for Probabilistic Predictions](../reference/arrieta-ibarra-2022-metrics-of-calibration.md) | arrieta-ibarra2022 | 2022 |
| [The Brownian Bridge](../reference/bhattacharya-2021-brownian-bridge.md) | bhattacharya2021 | 2021 |
| [Estimating Uncertainty Intervals from Collaborating Networks](../reference/zhou-2021-collaborating-networks.md) | zhou2021 | 2021 |
| [Individual Calibration with Randomized Forecasting](../reference/zhao-2020-individual-calibration.md) | zhao2020 | 2020 |
| [Statistical Aspects of Wasserstein Distances](../reference/panaretos-2019-wasserstein-distances.md) | panaretos2019 | 2019 |
| [Enforcing calibration in ensemble postprocessing](../reference/wilks-2018-enforcing-calibration.md) | wilks2018 | 2018 |
| [Accurate Uncertainties for Deep Learning Using Calibrated Regression](../reference/kuleshov-2018-calibrated-regression.md) | kuleshov2018 | 2018 |
| [On Calibration of Modern Neural Networks](../reference/guo-2017-calibration-neural-networks.md) | guo2017 | 2017 |
| [Detecting improvements in forecast correlation skill: Statistical testing and power analysis](../reference/siegert-2017-detecting-skill-improvements.md) | siegert2017 | 2017 |
| [On Reliability Analysis of Multi-Categorical Forecasts](../reference/brocker-2008-multi-categorical-reliability.md) | brocker2008 | 2008 |
| [Universal residuals: A multivariate transformation](../reference/brockwell-2007-universal-residuals.md) | brockwell2007 | 2007 |
| [Probabilistic forecasts, calibration and sharpness](../reference/gneiting-2007-calibration-and-sharpness.md) | gneiting2007 | 2007 |
| [Interpretation of Rank Histograms for Verifying Ensemble Forecasts](../reference/hamill-2001-rank-histograms.md) | hamill2001 | 2001 |
| [Evaluating Density Forecasts with Applications to Financial Risk Management](../reference/diebold-1998-density-forecast-evaluation.md) | diebold1998 | 1998 |
| [A Method for Producing and Evaluating Probabilistic Forecasts from Ensemble Model Integrations](../reference/anderson-1996-ensemble-integration.md) | anderson1996 | 1996 |
| [On the Distribution of the Integral of the Absolute Value of the Brownian Motion](../reference/takacs-1993-absolute-brownian-motion.md) | takacs1993 | 1993 |
| [Present Position and Potential Developments: Some Personal Views Statistical Theory the Prequential Approach](../reference/dawid-1984-prequential-approach.md) | dawid1984 | 1984 |
| [The Comparison and Evaluation of Forecasters](../reference/degroot-1983-comparison-of-forecasters.md) | degroot1983 | 1983 |
| [An explicit formula for the c.d.f. of the L1 norm of the Brownian bridge](../reference/johnson-killeen-1983-l1-brownian-bridge.md) | johnson-killeen-1983 | 1983 |
| [The Probability Integral Transformation When Parameters are Estimated from the Sample](../reference/david-1948-pit-estimated.md) | david1948 | 1948 |
<!-- loom view: references end -->

## Releases

<!-- loom view: releases -->

| uri | version | kind | released |
| --- | --- | --- | --- |
| [Initial package conversion](../release/v0-0-0-9000.md) | 0.0.0.9000 | software |  |
<!-- loom view: releases end -->

## Documents

- [Literature review](literature-review.md)
- [Paper rewrite skeleton](paper-rewrite-skeleton.md)
