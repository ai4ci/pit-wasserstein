---
class: plan
id: serially-dependent-forecasts.md
title: Significance tests for serially dependent forecasts
status: draft
informedBy:
- reference:diebold-1998-density-forecast-evaluation.md
---

<!-- loom:links start -->
- informedBy: [Evaluating Density Forecasts with Applications to Financial Risk Management](../reference/diebold-1998-density-forecast-evaluation.md)
<!-- loom:links end -->

Future methodology, outside the current paper. A forecaster issuing overlapping horizons or rolling estimates may generate a serially dependent sequence of PIT values even when their marginal distribution is uniform. The current EpiEstim application uses one estimate per independent observation series at each window setting. It needs no temporal correction.

For a stationary, short-memory PIT series, investigate the limit of the centred empirical CDF. The candidate Gaussian process has covariance
$$K(s,t)=\sum_{k\in\mathbb Z}\operatorname{Cov}\bigl(\mathbf1\{U_0\le s\},\mathbf1\{U_k\le t\}\bigr).$$
Independence recovers the Brownian bridge kernel. A single effective sample size rescales the entire process only when the new kernel is proportional to that kernel. Dependence can differ between the centre and tails, including when the autocorrelation of the raw PITs is zero. Dependent KS and Cramér–von Mises tests provide a precedent. [Chicheportiche & Bouchaud](https://arxiv.org/abs/1106.3016)

For the directed statistic under the symmetric reference model, start from the candidate influence function $\psi(u)=|u-1/2|-1/4$. Its marginal variance under uniformity is $\gamma_0=1/48$. If the fitted location term still cancels to first order, estimate $\Omega=\gamma_0+2\sum_{k>0}\operatorname{Cov}(\psi(U_0),\psi(U_k))$ with a long-run variance estimator. Then $n_{\rm eff,D}=n\gamma_0/\Omega$ would match the directed variance when $\Omega>0$. Positive covariance of extremeness reduces the equivalent sample size. This is a statistic-specific proposal to derive and test.

For the unsigned scores, compare the absolute area of the dependent process with that of its fitted counterpart, including estimation of the median shift. Investigate centred block or dependent-multiplier resampling under marginal uniformity. Preserve time order within blocks, forecast horizons and independent series boundaries. Refit the shift or reproduce its linearised effect in each resample. Raw block resampling about an observed alternative would carry its departure into the null. Forecast-density tests and dependent empirical-process bootstraps give starting points. [Rossi & Sekhposyan](https://www.crei.cat/wp-content/uploads/2017/07/RossiSekhposyan2017Revised.pdf) · [Bücher & Kojadinovic](https://arxiv.org/abs/1306.3930)

Compare empirical size and power with the existing independent benchmarks across series lengths, overlap, dependence in levels and dependence in extremeness. Check sensitivity to lag or block length and where stationarity fails over epidemic phases. Establish assumptions and finite-sample performance before exposing any adjusted p-value.