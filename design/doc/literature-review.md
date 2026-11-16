---
class: doc
id: literature-review.md
title: 'Literature review: PIT-based calibration metrics'
---
A map of the PIT-calibration literature collected in the `pit-wasserstein`
Zotero collection. One `reference` instance per paper; this page is the index
and the positioning argument.

## How the adjusted PIT-Wasserstein ($D^*_{pit}$) relates to existing work

```
          PIT uniformity as a calibration criterion
            (Dawid 1984; Diebold et al. 1998)
                              |
            ┌─────────────────┼─────────────────┐
            |                 |                 |
       Visual PIT      Formal testing      Quantified metrics
       (histogram)     (KS test, AD test)        |
            |                 |         ┌────────┼──────────────┐
      Hamill 2001      scoringutils   Binned   PCE / sup-norm  Wasserstein / L1
      Gneiting 2007    (Bosse 2024)   ECE      (Kuleshov 2018)      |
                                      (Guo 2017)                    |
                                                             ┌──────┴──────┐
                                                         Raw PIT    Bias-adjusted PIT
                                                             |             |
                                                     Wessel 2025     $D^*_{pit}$ ← THIS
                                                     Wilks 2018   (Challen & Danon)
                                                     Zhao 2020
```

Off to one side: Gneiting & Resin (2023) measure miscalibration as a *score
decomposition* component (MCB, via isotonic recalibration) rather than as a
distance from the PIT distribution to the uniform — the main alternative
answer to the same question, and an unfortunate name collision with Wessel et
al.'s MCB.

$D^*_{pit}$ is the only metric in this set that de-biases the PIT values before
measuring their departure from uniformity, and the only one that reports a
signed direction ($U^*_{pit}$) separating overconfidence from over-conservatism.
The Wasserstein-1-to-uniform construction itself is **not** novel: Zhao, Ma &
Ermon (2020) use it per input as a training objective, and Wessel et al. (2025)
use its sample version as a loss penalty.

## Collected references

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

## Must cite in the standalone paper

| Reference | Why |
|-----------|-----|
| [Gneiting et al. (2007)](../reference/gneiting-2007-calibration-and-sharpness.md) | Canonical PIT/calibration framework |
| [Hamill (2001)](../reference/hamill-2001-rank-histograms.md) | PIT histogram origins |
| [Panaretos & Zemel (2019)](../reference/panaretos-2019-wasserstein-distances.md) | Wasserstein distance theory |
| [Wessel et al. (2025)](../reference/wessel-2025-tail-calibration.md) | Closest existing metric (MCB = $D^*_{pit}$ without bias adjustment) |
| [Wilks (2018)](../reference/wilks-2018-enforcing-calibration.md) | First PIT-uniformity penalty |
| [Kuleshov et al. (2018)](../reference/kuleshov-2018-calibrated-regression.md) | PCE, the main competing calibration metric |
| [Dheur & Ben Taieb (2023)](../reference/dheur-2023-probabilistic-calibration-study.md) | Large-scale PCE study |
| [Bosse et al. (2024)](../reference/bosse-2024-scoringutils.md) | scoringutils, the current standard R tooling |
| [Dawid (1984)](../reference/dawid-1984-prequential-approach.md) | Origin of the probabilistic calibration criterion |
| [Diebold et al. (1998)](../reference/diebold-1998-density-forecast-evaluation.md) | PIT i.i.d. $U(0,1)$ result; "tests are not constructive" motivation |
| [Zhao et al. (2020)](../reference/zhao-2020-individual-calibration.md) | Prior use of Wasserstein-1 PIT-to-uniform distance — novelty must be argued against it |
| [Gneiting & Resin (2023)](../reference/gneiting-resin-2023-regression-diagnostics.md) | Calibration hierarchy; MCB score decomposition as the alternative |
| [Guo et al. (2017)](../reference/guo-2017-calibration-neural-networks.md) | ECE, the default ML metric and its binning problem |

Lower priority: [DeGroot & Fienberg (1983)](../reference/degroot-1983-comparison-of-forecasters.md)
(calibration/refinement origins), [Siegert et al. (2017)](../reference/siegert-2017-detecting-skill-improvements.md)
(paired testing and power when comparing dependent forecast systems), and
[Zhou et al. (2021)](../reference/zhou-2021-collaborating-networks.md)
(application-side example only).
