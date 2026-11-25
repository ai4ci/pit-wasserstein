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
| [Assess multivariate predictive distributions through their copulas](../plan/multivariate-copula-calibration.md) | draft |
| [Rewrite the appendix as a standalone methods paper](../plan/paper-rewrite.md) | active |
| [Score forecasts supplied as draws or quantiles](../plan/prediction-distribution-inputs.md) | draft |
| [Significance tests for serially dependent forecasts](../plan/serially-dependent-forecasts.md) | draft |
<!-- loom view: activePlans end -->

## Open tasks

<!-- loom view: openTasks -->

| uri | status | priority |
| --- | --- | --- |
| [Clarify Figure 4 and the limits of the EpiEstim comparison](../task/clarify-epiestim-figure-and-inference.md) | todo | high |
| [Package documentation describes limiting PIT-Wasserstein tests as exact](../task/clarify-pit-test-reference-approximations.md) | todo | high |
| [Confirm the EpiEstim observation windows and reference day](../task/confirm-epiestim-window-and-reference-day.md) | todo | high |
| [Integrate JMLR LaTeX style file for the paper](../task/integrate-jmlr-latex-style.md) | doing | high |
| [Find or tabulate a c.d.f. for the bias-adjusted U_pit null](../task/derive-cdf-of-the-adjusted-u-pit-null.md) | todo | medium |
| [Huxtable PDF export unit test fails in scoder](../task/hux-pdf-export-test-fails-in-scoder.md) | todo | medium |
| [Verify GitHub license recognition for Reservoir](../task/verify-reservoir-license-detection.md) | todo | medium |
| [Clarify what the three statistics can diagnose](../task/clarify-calibration-and-diagnostic-claims.md) | todo | medium |
| [Clarify common shifts and the fitted Gaussian reference](../task/clarify-location-shift-and-fitted-reference.md) | todo | medium |
| [Clarify the replicate ranges and power statements in Figures 2 and 3](../task/clarify-power-and-replicate-envelopes.md) | todo | medium |
| [Gather the supporting materials at one online address](../task/online-supporting-materials.md) | todo | medium |
| [Accept posterior samples via an empirical CDF](../task/score-posterior-sample-forecasts.md) | todo | medium |
| [Accept forecasts specified by predictive quantiles](../task/score-quantile-forecasts.md) | todo | medium |
| [Separate PIT construction and adjustment from metric calculation](../task/separate-pit-construction-and-scoring.md) | todo | medium |
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
