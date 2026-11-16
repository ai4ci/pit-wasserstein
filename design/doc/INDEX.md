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
| [Decide: short communication vs full methods paper](../plan/decide-publication-strategy.md) | active |
| [Significance test for H0: estimator is dispersion-calibrated](../plan/dispersion-calibration-significance-test.md) | draft |
| [Rewrite the appendix as a standalone short paper](../plan/paper-rewrite.md) | active |
| [Make the package build and check cleanly for r-universe](../plan/r-universe-release-readiness.md) | active |
<!-- loom view: activePlans end -->

## Open tasks

<!-- loom view: openTasks -->

| uri | status | priority |
| --- | --- | --- |
| [Use the existing non-normal distribution capability to test bias-adjustment robustness](../task/add-non-normal-distribution-robustness-study.md) | todo | high |
| [EpiEstim on simulated SEIR data: differential calibration at low vs high prevalence](../task/add-real-worked-example.md) | todo | high |
| [Characterise D*_pit sampling distribution under H0 by simulation](../task/characterise-d-pit-sampling-distribution-by-simulation.md) | todo | high |
| [main.tex cite keys do not match refs.bib and the bibliography does not build](../task/citation-keys-do-not-match-refs-bib.md) | todo | high |
| [Clarify standard calibration versus the bias-adjusted PIT diagnostic](../task/clarify-bias-adjusted-pit-diagnostic.md) | todo | high |
| [Decide: short communication or full methods paper](../task/decide-publication-format-short-communication-or-full-paper.md) | todo | high |
| [Derive the analytical null distribution of the PIT-W metrics](../task/derive-analytical-null-distribution-for-pit-w-metrics.md) | todo | high |
| [DESCRIPTION still has placeholder Title and Description](../task/fix-description-placeholder-metadata.md) | todo | high |
| [Implement a bootstrap significance test for H0: dispersion-calibrated](../task/implement-bootstrap-test-for-dispersion-calibration.md) | todo | high |
| [Reframe the introduction as a mathematical methods paper, not an educational piece](../task/reframe-introduction-as-mathematical-methods-paper.md) | todo | high |
| [Settle the bias adjustment: x-space kept, PIT-space ruled out](../task/restore-pivotality-of-the-bias-adjustment.md) | todo | high |
| [Frame the metrics as a two-part test: D* for median dispersion, U* for residual shape](../task/two-part-test-decomposition-d-then-u.md) | todo | high |
| [No CI runs R CMD check or the test suite](../task/add-ci-r-cmd-check-workflow.md) | todo | medium |
| [U*_pit and D*_pit are swapped in README relative to main.tex and the code](../task/pit-w-notation-swapped-between-readme-and-paper.md) | todo | medium |
| [Reframe the four figure vignettes as supplementary materials](../task/reframe-vignettes-as-supplementary-materials.md) | todo | medium |
| [State the asymptotic D*_pit question precisely as future work](../task/document-asymptotic-theory-as-future-work.md) | todo | low |
| [refs.bib has two entries for Dheur & Ben Taieb (2023)](../task/duplicate-dheur-bib-entry.md) | todo | low |
<!-- loom view: openTasks end -->

## References

<!-- loom view: references -->

| uri | citeKey | year |
| --- | --- | --- |
| [Enforcing tail calibration when training probabilistic forecast models](../reference/wessel-2025-tail-calibration.md) | Wessel_Schillinger_Kwasniok_Allen_2025 | 2025 |
| [Evaluating Forecasts with scoringutils in R](../reference/bosse-2024-scoringutils.md) | Bosse_Gruson_Cori_Leeuwen_Funk_Abbott_2024 | 2024 |
| [Automatic Miscalibration Diagnosis: Interpreting Probability Integral Transform (PIT) Histograms](../reference/podsztavek-2024-automatic-miscalibration-diagnosis.md) | Podsztavek_Jordan_Tvrdík_Polsterer_2024 | 2024 |
| [A Large-Scale Study of Probabilistic Calibration in Neural Network Regression](../reference/dheur-2023-probabilistic-calibration-study.md) | Dheur_Taieb_2023 | 2023 |
| [Regression Diagnostics meets Forecast Evaluation: Conditional Calibration, Reliability Diagrams, and Coefficient of Determination](../reference/gneiting-resin-2023-regression-diagnostics.md) | Gneiting_Resin_2023 | 2023 |
| [Metrics of Calibration for Probabilistic Predictions](../reference/arrieta-ibarra-2022-metrics-of-calibration.md) | Arrieta-Ibarra_Gujral_Tannen_Tygert_Xu_2022 | 2022 |
| [Estimating Uncertainty Intervals from Collaborating Networks](../reference/zhou-2021-collaborating-networks.md) | Zhou_Li_Wu_Carlson_2021 | 2021 |
| [Individual Calibration with Randomized Forecasting](../reference/zhao-2020-individual-calibration.md) | Zhao_Ma_Ermon_2020a | 2020 |
| [Statistical Aspects of Wasserstein Distances](../reference/panaretos-2019-wasserstein-distances.md) | Panaretos_Zemel_2019 | 2019 |
| [Accurate Uncertainties for Deep Learning Using Calibrated Regression](../reference/kuleshov-2018-calibrated-regression.md) | Kuleshov_Fenner_Ermon_2018 | 2018 |
| [Enforcing calibration in ensemble postprocessing](../reference/wilks-2018-enforcing-calibration.md) | Wilks_2018 | 2018 |
| [On Calibration of Modern Neural Networks](../reference/guo-2017-calibration-neural-networks.md) | Guo_Pleiss_Sun_Weinberger_2017 | 2017 |
| [Detecting improvements in forecast correlation skill: Statistical testing and power analysis](../reference/siegert-2017-detecting-skill-improvements.md) | Siegert_Bellprat_Ménégoz_Stephenson_Doblas-Reyes_2017 | 2017 |
| [Universal residuals: A multivariate transformation](../reference/brockwell-2007-universal-residuals.md) | Brockwell_2007 | 2007 |
| [Probabilistic forecasts, calibration and sharpness](../reference/gneiting-2007-calibration-and-sharpness.md) | Gneiting_Balabdaoui_Raftery_2007 | 2007 |
| [Interpretation of Rank Histograms for Verifying Ensemble Forecasts](../reference/hamill-2001-rank-histograms.md) | Hamill_2001 | 2001 |
| [Evaluating Density Forecasts with Applications to Financial Risk Management](../reference/diebold-1998-density-forecast-evaluation.md) | Diebold_Gunther_Tay_1998 | 1998 |
| [Present Position and Potential Developments: Some Personal Views Statistical Theory the Prequential Approach](../reference/dawid-1984-prequential-approach.md) | Dawid_1984 | 1984 |
| [The Comparison and Evaluation of Forecasters](../reference/degroot-1983-comparison-of-forecasters.md) | Degroot_Fienberg_1983 | 1983 |
<!-- loom view: references end -->

## Releases

<!-- loom view: releases -->

| uri | version | kind | released |
| --- | --- | --- | --- |
| [Initial package conversion](../release/v0-0-0-9000.md) | 0.0.0.9000 | software |  |
<!-- loom view: releases end -->

## Documents

- [Literature review](literature-review.md)
