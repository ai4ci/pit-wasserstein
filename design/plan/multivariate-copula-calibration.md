---
class: plan
id: multivariate-copula-calibration.md
title: Assess multivariate predictive distributions through their copulas
status: draft
informedBy:
- reference:brockwell-2007-universal-residuals.md
---

<!-- loom:links start -->
- informedBy: [Universal residuals: A multivariate transformation](../reference/brockwell-2007-universal-residuals.md)
<!-- loom:links end -->

Long-term research question. For a single forecast of several related outcomes, can we detect an incorrect dependence structure when each marginal prediction is calibrated? The predicted copula gives the reference dependence of the marginal PITs. Uniform margins alone are compatible with many different copulas.

Start with independent forecast occasions and paired observations or joint posterior draws within each occasion. Compare the empirical dependence with the forecast copula, or study a conditional PIT (Rosenblatt transform) with a specified component order. Work out the interpretation of any distance, its sensitivity to ordering and dimension, and which adjustments can preserve the predicted dependence. Check the independent-components case, correct dependent forecasts, wrong dependence with correct margins, and wrong margins with correct dependence. Dependence between forecast occasions is a separate research question.