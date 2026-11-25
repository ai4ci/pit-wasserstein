---
class: plan
id: dispersion-calibration-significance-test.md
title: 'Significance test for H0: estimator is dispersion-calibrated'
status: active
rationale: 'Picks up the papers own stated limitation (main.tex:240): characterise D*_pit vs sample size and develop a significance test.'
informedBy:
- reference:zhao-2020-individual-calibration.md
- reference:diebold-1998-density-forecast-evaluation.md
- reference:panaretos-2019-wasserstein-distances.md
- reference:siegert-2017-detecting-skill-improvements.md
- reference:bhattacharya-2021-brownian-bridge.md
- reference:takacs-1993-absolute-brownian-motion.md
spawns:
- task:characterise-d-pit-sampling-distribution-by-simulation.md
- task:implement-bootstrap-test-for-dispersion-calibration.md
- task:document-asymptotic-theory-as-future-work.md
- task:derive-analytical-null-distribution-for-pit-w-metrics.md
- task:restore-pivotality-of-the-bias-adjustment.md
- task:document-three-part-test-decomposition.md
- task:derive-cdf-of-the-adjusted-u-pit-null.md
---
This plan originally proposed a bootstrap and was revised after deriving the limiting reference distributions. The current paper uses three marginal tests on independent predictions. The baseline score compares the original PITs with independent uniform draws, with limiting reference $\int |G(t)|\,dt$ for a Brownian bridge $G$. For the fitted scores, the manuscript assumes Gaussian errors with common scale on the chosen link and estimates a median shift in each sample.

With $k(t)=\varphi(\Phi^{-1}(t))/\varphi(0)$, the adjusted unsigned limit integrates $|G(t)-k(t)G(1/2)|$. The package simulates this reference. Deriving its CDF or tabulating it more precisely remains [open](../task/derive-cdf-of-the-adjusted-u-pit-null.md). The fitted term integrates to zero for the signed weight in this model, giving variance $1/48$ in the scaled Gaussian limit. Other families and varying scales can change the effect of fitting location. A zero net directed score alone does not determine its reference variance.

The [EpiEstim example](../../vignettes/sir-epiestim-example.Rmd) uses 100 independent series at each population and window setting. It uses the fitted Gaussian limits descriptively. The original within-series rolling-window design has been superseded. [Serially dependent forecasts](serially-dependent-forecasts.md) are future work outside the paper.