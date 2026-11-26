## Analytical null distributions for the PIT-Wasserstein metrics.
##
## Both metrics are functionals of the empirical quantile process of the PIT
## values. Under the null of exact calibration the PIT values are i.i.d.
## U(0,1), so sqrt(n) times each metric converges to the corresponding
## functional of a Brownian bridge B. The null is therefore
## distribution-free: it depends on the number of predictions and nothing
## else.
##
##   D*_pit  is a *linear* functional of the bridge and is exactly Gaussian,
##           D*_pit ~ N(0, 1/(48 n)).
##
##   U*_pit  is the integrated absolute bridge, sqrt(n) U*_pit => int |B|,
##           whose c.d.f. is given explicitly by Johnson & Killeen (1983).

#' Airy function `Ai(x)` for positive `x`
#'
#' Computed from the modified Bessel representation
#' \eqn{Ai(x) = \pi^{-1}\sqrt{x/3}\,K_{1/3}(\tfrac{2}{3}x^{3/2})}, so that no
#' external Airy implementation is required. The exponentially scaled Bessel
#' call keeps the large-`x` tail from underflowing prematurely.
#'
#' @param x a positive numeric vector
#' @returns `Ai(x)`, the same length as `x`
#' @noRd
.airy_ai = function(x) {
  zeta = 2 / 3 * x^(3 / 2)
  (1 / pi) * sqrt(x / 3) * besselK(zeta, 1 / 3, expon.scaled = TRUE) * exp(-zeta)
}

#' Derivative of the Airy function at a negative argument, `Ai'(-z)`
#'
#' Uses \eqn{Ai'(-z) = (z/3)\left[J_{-2/3}(\zeta) - J_{2/3}(\zeta)\right]} with
#' \eqn{\zeta = \tfrac{2}{3}z^{3/2}}. Base R's `besselJ()` does not accept a
#' negative order, so \eqn{J_{-2/3}} is obtained from the standard identity
#' \eqn{J_{-\nu}(x) = J_\nu(x)\cos(\nu\pi) - Y_\nu(x)\sin(\nu\pi)}.
#'
#' @param z a positive numeric vector
#' @returns `Ai'(-z)`, the same length as `z`
#' @noRd
.airy_ai_prime_neg = function(z) {
  zeta = 2 / 3 * z^(3 / 2)
  j = besselJ(zeta, 2 / 3)
  y = besselY(zeta, 2 / 3)
  j_neg = j * cos(2 * pi / 3) - y * sin(2 * pi / 3)
  (z / 3) * (j_neg - j)
}

.l1_bridge_cache = new.env(parent = emptyenv())

#' The first `k` zeros of `Ai'`, as positive magnitudes
#'
#' Found by scanning `Ai'(-z)` for sign changes and refining each bracket with
#' `uniroot()`, rather than relying on tabulated constants. Cached for the
#' session because the scan is the only slow part of the `U*_pit` null.
#'
#' @param k number of zeros required
#' @returns a numeric vector of length `k`, the magnitudes \eqn{|a'_j|}
#' @noRd
.ai_prime_zeros = function(k = 12L) {
  if (is.null(.l1_bridge_cache$zeros) || length(.l1_bridge_cache$zeros) < k) {
    # |a'_j| ~ (3 pi (4j-3) / 8)^(2/3), so this upper limit comfortably
    # brackets more than `k` zeros.
    upper = (3 * pi * (4 * (k + 2) - 3) / 8)^(2 / 3) + 1
    grid = seq(0.1, upper, length.out = 20L * (k + 2L))
    value = .airy_ai_prime_neg(grid)
    cross = which(value[-1] * value[-length(value)] < 0)
    .l1_bridge_cache$zeros = vapply(
      cross,
      function(i) {
        stats::uniroot(
          .airy_ai_prime_neg,
          c(grid[i], grid[i + 1]),
          tol = .Machine$double.eps^0.75
        )$root
      },
      numeric(1)
    )
  }
  .l1_bridge_cache$zeros[seq_len(k)]
}

#' Distribution of the L1 norm of the Brownian bridge
#'
#' The limiting null distribution of \eqn{\sqrt{n}\,U^*_{pit}}. For a standard
#' Brownian bridge \eqn{B}, Johnson & Killeen (1983) give the c.d.f. of
#' \eqn{L = \int_0^1 |B(t)|\,\mathrm{d}t} as the convergent series
#'
#' \deqn{P(L \le \ell) = \sqrt{\pi/2} \sum_{j=1}^{\infty} \delta_j^{-3/2}
#'   \psi(\ell / \delta_j^{3/2})}
#'
#' with \eqn{\psi(t) = 3^{2/3} t^{-1/3} e^{-2/(27 t^2)} Ai((3t)^{-4/3})} and
#' \eqn{\delta_j = |a'_j| / 2^{1/3}}, where \eqn{a'_j} is the \eqn{j}th zero of
#' \eqn{Ai'}. Terms are suppressed by \eqn{e^{-2/(27t^2)}} with
#' \eqn{t = q/\delta_j^{3/2}}, so the number of terms needed grows with `q`.
#' The default is ample over the whole range where the upper tail is
#' numerically distinguishable from zero; beyond `q = 10` the c.d.f. is
#' returned as exactly 1.
#'
#' @param q a vector of quantiles (non-negative)
#' @param terms number of terms of the series to sum
#' @returns `p_l1_bridge()` returns the c.d.f. evaluated at `q`;
#'   `q_l1_bridge()` returns the quantile function evaluated at `p`
#' @export
#' @concept significance
#'
#' @unit
#' # the mean of the L1 norm of the bridge is known exactly to be sqrt(2 pi)/8
#' m = integrate(function(x) 1 - p_l1_bridge(x), 0, 5, subdivisions = 500L)$value
#' testthat::expect_equal(m, sqrt(2 * pi) / 8, tolerance = 1e-5)
#'
#' # a proper distribution function
#' testthat::expect_equal(p_l1_bridge(0), 0)
#' testthat::expect_equal(p_l1_bridge(10), 1)
#' testthat::expect_true(all(diff(p_l1_bridge(seq(0.05, 1, 0.05))) > 0))
#'
#' # and its inverse
#' testthat::expect_equal(p_l1_bridge(q_l1_bridge(0.95)), 0.95, tolerance = 1e-6)
p_l1_bridge = function(q, terms = 30L) {
  delta = .ai_prime_zeros(terms) / 2^(1 / 3)
  scale = delta^(3 / 2)
  vapply(
    q,
    function(l) {
      if (!is.finite(l)) {
        return(if (is.na(l)) NA_real_ else 1)
      }
      if (l <= 0) {
        return(0)
      }
      # shortcut: survival is below 1e-30 here and the series would need
      # hundreds of terms, upgrade to a tail asymptotic only if ever needed
      if (l > 10) {
        return(1)
      }
      t = l / scale
      psi = 3^(2 / 3) * exp(-2 / (27 * t^2)) * t^(-1 / 3) * .airy_ai((3 * t)^(-4 / 3))
      min(1, sqrt(pi / 2) * sum(psi / scale))
    },
    numeric(1)
  )
}

#' @param p a vector of probabilities
#' @rdname p_l1_bridge
#' @concept significance
#' @export
q_l1_bridge = function(p, terms = 30L) {
  vapply(
    p,
    function(prob) {
      if (is.na(prob)) {
        return(NA_real_)
      }
      if (prob <= 0) {
        return(0)
      }
      if (prob >= 1) {
        return(Inf)
      }
      stats::uniroot(
        function(l) p_l1_bridge(l, terms) - prob,
        c(1e-6, 10),
        tol = .Machine$double.eps^0.5
      )$root
    },
    numeric(1)
  )
}

#' Significance test for the baseline PIT-Wasserstein metric
#'
#' Tests the strongest of the three null hypotheses in the PIT-Wasserstein
#' family: that the predictions are **fully probabilistically calibrated**, so
#' that the raw PIT values are i.i.d. \eqn{U(0,1)} — correct location *and*
#' correct dispersion *and* correct shape. The test is one-sided: `B_pit` is a
#' distance, so only large values are evidence against calibration.
#'
#' Under that null \eqn{\sqrt{n}\,B_{pit}} converges to \eqn{\int_0^1|B^\circ|},
#' the integrated absolute Brownian bridge, whose c.d.f. is [p_l1_bridge()].
#' Nothing is estimated from the data, so the null is exact and fully
#' analytical.
#'
#' `B_pit` rejects when *anything* is wrong and says nothing about what. Use it
#' as the omnibus first stage, then [d_pit_significance()] to test dispersion
#' free of any location error, and [u_pit_significance()] for the residual
#' shape.
#'
#' @param B_pit the baseline (unadjusted) PIT-Wasserstein metric, reported as
#'   `B_pit` by [pit_w()] and [prediction_scores()]
#' @param n_predictions the number of predictions each `B_pit` was computed
#'   from, as returned by [prediction_scores()]
#' @returns a dataframe with one row per input value and columns:
#' * `B_pit`, `n_predictions` — as supplied
#' * `statistic` — \eqn{\sqrt{n}\,B_{pit}}, the quantity with a fixed null
#' * `expected` — the null mean of `B_pit`, \eqn{\sqrt{2\pi}/(8\sqrt{n})}
#' * `critical_0.05` — the one-sided 5% critical value of `B_pit`
#' * `p_value` — the probability of a `B_pit` at least this large under full
#'   probabilistic calibration
#' @export
#' @concept significance
#'
#' @unit
#' # a calibrated forecaster sits near the null mean and is not significant
#' res = b_pit_significance(sqrt(2 * pi) / 8 / sqrt(100), 100)
#' testthat::expect_true(res$p_value > 0.3)
#'
#' # the 5% critical value has, by construction, a p value of 0.05
#' crit = b_pit_significance(0, 100)$critical_0.05
#' testthat::expect_equal(b_pit_significance(crit, 100)$p_value, 0.05, tolerance = 1e-5)
#'
#' # the critical value scales as 1/sqrt(n)
#' testthat::expect_equal(
#'   b_pit_significance(0, 400)$critical_0.05 * 2,
#'   b_pit_significance(0, 100)$critical_0.05,
#'   tolerance = 1e-6
#' )
#'
#' # and is strictly larger than the adjusted test's, which has estimated a
#' # location parameter from the same data
#' testthat::expect_true(
#'   b_pit_significance(0, 100)$critical_0.05 > u_pit_significance(0, 100)$critical_0.05
#' )
#'
#' # vectorised over both arguments
#' testthat::expect_equal(nrow(b_pit_significance(c(0.02, 0.09), c(76, 76))), 2L)
b_pit_significance = function(B_pit, n_predictions) {
  interfacer::recycle(B_pit, n_predictions)
  dplyr::tibble(
    B_pit = B_pit,
    n_predictions = n_predictions,
    statistic = sqrt(n_predictions) * B_pit,
    expected = sqrt(2 * pi) / 8 / sqrt(n_predictions),
    critical_0.05 = q_l1_bridge(0.95) / sqrt(n_predictions),
    p_value = 1 - p_l1_bridge(sqrt(n_predictions) * B_pit)
  )
}

#' Null distribution of the bias-adjusted undirected metric
#'
#' The bias adjustment estimates a location shift from the same data, which
#' removes one direction from the limiting bridge. Writing
#' \eqn{\kappa(t) = \varphi(\Phi^{-1}(t))/\varphi(0)} for the sensitivity of the
#' PIT values to that shift and \eqn{B^\circ(1/2)} for the component the median
#' centring pins down,
#'
#' \deqn{\sqrt{n}\,U_{pit} \Rightarrow \int_0^1 \left| B^\circ(t) -
#'   \kappa(t) B^\circ(1/2) \right| \mathrm{d}t}
#'
#' This is still distribution-free — it depends on nothing but `n` — but unlike
#' the baseline functional it has no published c.d.f., so the reference
#' distribution is generated once per session by simulating the limit process
#' directly. This is the Kolmogorov-Smirnov to Lilliefors step: same statistic,
#' one estimated parameter, a different and strictly smaller null.
#'
#' @param reps number of realisations of the limit process
#' @param m grid resolution for each bridge
#' @returns a sorted numeric vector of draws from the limit distribution
#' @noRd
.u_pit_null = function(reps = 20000L, m = 1000L) {
  key = sprintf("null_%d_%d", reps, m)
  if (is.null(.l1_bridge_cache[[key]])) {
    t = seq_len(m) / m
    kappa = stats::dnorm(stats::qnorm(t)) / stats::dnorm(0)
    chunk = 500L
    draws = unlist(lapply(
      seq_len(ceiling(reps / chunk)),
      function(.) {
        incr = matrix(stats::rnorm(chunk * m, sd = sqrt(1 / m)), chunk, m)
        wiener = t(apply(incr, 1, cumsum))
        bridge = wiener - outer(wiener[, m], t)
        rowMeans(abs(bridge - outer(bridge[, m %/% 2L], kappa)))
      }
    ))
    .l1_bridge_cache[[key]] = sort(draws)
  }
  .l1_bridge_cache[[key]]
}

#' Upper tail probability of the adjusted null
#'
#' Monte Carlo in the body, where resolution is ample, and a Gaussian-type tail
#' extrapolation beyond the 99th percentile, where it is not. Functionals of
#' this kind have log-survival asymptotically linear in the square of the
#' argument, so `log(S)` is regressed on `x^2` over the top 5% of the reference
#' sample and extrapolated.
#'
#' @param x a vector of values of the limit statistic
#' @returns the upper tail probability at `x`
#' @noRd
.p_u_pit_upper = function(x) {
  null = .u_pit_null()
  reps = length(null)
  cut = null[floor(0.99 * reps)]
  tail_i = seq(floor(0.95 * reps), reps - 1L)
  # shortcut: quadratic-exponential tail fit, replace if the limit functional
  # ever gets a published c.d.f. like the baseline one has
  fit = stats::lm(log(1 - (tail_i - 0.5) / reps) ~ I(null[tail_i]^2))
  vapply(
    x,
    function(v) {
      if (is.na(v)) {
        return(NA_real_)
      }
      if (v <= cut) {
        return((1 + sum(null >= v)) / (reps + 1))
      }
      min(1, exp(sum(stats::coef(fit) * c(1, v^2))))
    },
    numeric(1)
  )
}

#' Significance test for the bias-adjusted undirected PIT-Wasserstein metric
#'
#' Tests the weakest of the three null hypotheses in the PIT-Wasserstein
#' family: that the predictive distributions have the **right shape given an
#' arbitrary location error**. The bias adjustment absorbs any common shift, so
#' a rejection here means the shape of the predictive distribution is wrong —
#' skew, tail weight, or a mixture of dispersion errors — and not that the
#' forecasts are merely off-centre. One-sided, as `U_pit` is a distance.
#'
#' Because the adjustment estimates a parameter from the same data, the null is
#' **not** the baseline \eqn{\int_0^1|B^\circ|} of [b_pit_significance()]: it is
#' the bridge with the estimated direction projected out (see `.u_pit_null`),
#' giving a 5% critical value about `0.66` times the baseline one at every `n`.
#' Using the baseline null here would be badly conservative. The adjusted null
#' is still distribution-free — it depends on `n` and nothing else — but has no
#' published c.d.f., so it is simulated once per session and cached.
#'
#' `U_pit` says nothing about the *direction* of a dispersion error; pair it
#' with [d_pit_significance()], which does.
#'
#' @param U_pit the bias-adjusted undirected PIT-Wasserstein metric, as
#'   returned by [pit_w()] or [prediction_scores()]
#' @param n_predictions the number of predictions each `U_pit` was computed
#'   from, as returned by [prediction_scores()]
#' @returns a dataframe with one row per input value and columns:
#' * `U_pit`, `n_predictions` — as supplied
#' * `statistic` — \eqn{\sqrt{n}\,U_{pit}}, the quantity with a fixed null
#' * `expected` — the null mean of `U_pit`
#' * `critical_0.05` — the one-sided 5% critical value of `U_pit`
#' * `p_value` — the probability of a `U_pit` at least this large under the
#'   location-free null
#' @export
#' @concept significance
#'
#' @unit
#' # the adjusted null is strictly tighter than the baseline one
#' testthat::expect_lt(
#'   u_pit_significance(0, 100)$critical_0.05,
#'   b_pit_significance(0, 100)$critical_0.05
#' )
#'
#' # the critical value scales as 1/sqrt(n)
#' testthat::expect_equal(
#'   u_pit_significance(0, 400)$critical_0.05 * 2,
#'   u_pit_significance(0, 100)$critical_0.05,
#'   tolerance = 1e-6
#' )
#'
#' # a statistic at the null mean is not significant
#' testthat::expect_gt(u_pit_significance(u_pit_significance(0, 100)$expected, 100)$p_value, 0.3)
#'
#' # the 5% critical value returns a p value of about 0.05
#' crit = u_pit_significance(0, 100)$critical_0.05
#' testthat::expect_equal(u_pit_significance(crit, 100)$p_value, 0.05, tolerance = 0.005)
#'
#' # vectorised over both arguments
#' testthat::expect_equal(nrow(u_pit_significance(c(0.02, 0.09), c(76, 76))), 2L)
u_pit_significance = function(U_pit, n_predictions) {
  interfacer::recycle(U_pit, n_predictions)
  null = .u_pit_null()
  dplyr::tibble(
    U_pit = U_pit,
    n_predictions = n_predictions,
    statistic = sqrt(n_predictions) * U_pit,
    expected = mean(null) / sqrt(n_predictions),
    critical_0.05 = unname(stats::quantile(null, 0.95)) / sqrt(n_predictions),
    p_value = .p_u_pit_upper(sqrt(n_predictions) * U_pit)
  )
}

#' Significance test for the directed PIT-Wasserstein metric
#'
#' Tests the null hypothesis that the predictions are calibrated. `D_pit` is
#' signed, so unlike [u_pit_significance()] this test reports a direction:
#' positive values indicate **overconfidence** (predictive distributions too
#' narrow) and negative values **underconfidence** (too wide).
#'
#' `D_pit` is a linear functional of the empirical quantile process, so its
#' null is exactly Gaussian with a known variance,
#' \eqn{D^*_{pit} \sim \mathcal{N}(0, 1/(48n))}. No simulation, bootstrap or
#' nuisance parameter is required.
#'
#' The normal approximation to a sum of order statistics converges from above,
#' so for `n_predictions` below about 50 the test is mildly anti-conservative
#' (empirical size around 8% at `n = 10`, 6% at `n = 25`, 5.5% at `n = 50`);
#' treat small-sample p values as approximate.
#'
#' @param D_pit the directed PIT-Wasserstein metric, as returned by [pit_w()]
#'   or [prediction_scores()]
#' @param n_predictions the number of predictions each `D_pit` was computed
#'   from, as returned by [prediction_scores()]
#' @param alternative one of `"two.sided"` (any dispersion miscalibration),
#'   `"overconfident"` (positive `D_pit` only) or `"underconfident"`
#'   (negative `D_pit` only)
#' @returns a dataframe with one row per input value and columns:
#' * `D_pit`, `n_predictions` — as supplied
#' * `statistic` — the z score, \eqn{D^*_{pit}\sqrt{48n}}
#' * `se` — the null standard error, \eqn{1/\sqrt{48n}}
#' * `critical_0.05` — the magnitude of `D_pit` rejected at 5%
#' * `direction` — `"overconfident"`, `"underconfident"` or `"calibrated"`
#' * `p_value` — computed against `alternative`
#' @export
#' @concept significance
#'
#' @unit
#' # a z score of 1.96 is a two sided p of 0.05
#' res = d_pit_significance(qnorm(0.975) / sqrt(48 * 100), 100)
#' testthat::expect_equal(res$statistic, qnorm(0.975))
#' testthat::expect_equal(res$p_value, 0.05)
#' testthat::expect_equal(res$direction, "overconfident")
#'
#' # the one sided test is half the two sided test in the expected direction
#' testthat::expect_equal(
#'   d_pit_significance(0.01, 100, "overconfident")$p_value,
#'   d_pit_significance(0.01, 100)$p_value / 2
#' )
#'
#' # and is not fooled by a deviation in the other direction
#' testthat::expect_true(d_pit_significance(-0.03, 100, "overconfident")$p_value > 0.95)
#'
#' # exactly calibrated
#' testthat::expect_equal(d_pit_significance(0, 100)$p_value, 1)
#' testthat::expect_equal(d_pit_significance(0, 100)$direction, "calibrated")
d_pit_significance = function(
  D_pit,
  n_predictions,
  alternative = c("two.sided", "overconfident", "underconfident")
) {
  alternative = match.arg(alternative)
  interfacer::recycle(D_pit, n_predictions)

  se = 1 / sqrt(48 * n_predictions)
  z = D_pit / se

  p_value = switch(
    alternative,
    two.sided = 2 * stats::pnorm(-abs(z)),
    overconfident = stats::pnorm(z, lower.tail = FALSE),
    underconfident = stats::pnorm(z)
  )

  dplyr::tibble(
    D_pit = D_pit,
    n_predictions = n_predictions,
    statistic = z,
    se = se,
    critical_0.05 = stats::qnorm(if (alternative == "two.sided") 0.975 else 0.95) * se,
    direction = dplyr::case_when(
      D_pit > 0 ~ "overconfident",
      D_pit < 0 ~ "underconfident",
      TRUE ~ "calibrated"
    ),
    p_value = p_value
  )
}
