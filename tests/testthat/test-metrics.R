# Reference implementation of the metrics in main/main.tex.
# Tests are written against the PAPER (main.tex eq:cover, eq:pit2, eq:pit3,
# eq:tmp, eq:valid), not against the previous analysis.R behaviour, so a
# divergence between the two shows up as a failure rather than being silently
# inherited.

rank_of = function(n) seq(0.5 / n, 1 - 0.5 / n, length.out = n)
identity_cdf = function(x, mean, sd) x

# --- pit_w(): D*_pit (eq:pit2), U*_pit (eq:pit3) ------------------------------

test_that("a perfectly calibrated estimator scores zero on both metrics", {
  n = 101
  u = rank_of(n)  # PIT values already exactly uniform
  res = pit_w(u, u, rep(1, n), cdf = identity_cdf)
  expect_equal(res$d_pit, 0, tolerance = 1e-12)
  expect_equal(res$u_pit, 0, tolerance = 1e-12)
  expect_equal(res$bias, 0, tolerance = 1e-12)
})

test_that("D*_pit is invariant to bias in the estimates (eq:pit2)", {
  set.seed(1)
  n = 2000
  true_value = rnorm(n)
  unbiased = pit_w(true_value, true_value, rep(1, n))
  biased = pit_w(true_value, true_value + 0.7, rep(1, n))
  expect_equal(unbiased$d_pit, biased$d_pit, tolerance = 1e-3)
  # the raw, unadjusted Wasserstein distance does move with bias, which is the
  # reason the metric is bias-adjusted at all
  expect_gt(abs(biased$raw_wasserstein - unbiased$raw_wasserstein), 1e-3)
})

test_that("D*_pit reaches the documented maximum of 0.5 (main.tex:134)", {
  n = 500
  res = pit_w(rep(0, n), rep(0, n), rep(1, n), cdf = identity_cdf)
  expect_equal(res$d_pit, 0.5, tolerance = 1e-3)
})

test_that("U*_pit is +0.25 overconfident, -0.25 over-uncertain (eq:pit3)", {
  n = 400
  edges = rep(c(0, 1), length.out = n)
  over = pit_w(edges, edges, rep(1, n), cdf = identity_cdf)
  centre = rep(0.5, n)
  under = pit_w(centre, centre, rep(1, n), cdf = identity_cdf)
  expect_equal(over$u_pit, 0.25, tolerance = 1e-3)
  expect_equal(under$u_pit, -0.25, tolerance = 1e-3)
})

test_that("pit_w matches a hand-computed three-point case", {
  # PIT values 0.1, 0.2, 0.9 with no bias. ranks = 1/6, 3/6, 5/6.
  # D*_pit = mean(|ranks - sorted PIT|)
  u = c(0.1, 0.2, 0.9)
  res = pit_w(u, u, rep(1, 3), cdf = identity_cdf)
  expect_equal(res$d_pit, mean(abs(rank_of(3) - u)), tolerance = 1e-12)
  expect_equal(
    res$u_pit,
    mean((rank_of(3) - u) * sign(0.5 - rank_of(3))),
    tolerance = 1e-12
  )
})

test_that("pit_w is vectorised: a matrix of estimates gives one result per row", {
  set.seed(3)
  n = 300
  scenarios = 7
  true_value = rnorm(n)
  est_mean = matrix(true_value + rnorm(n * scenarios, 0, 0.5), scenarios, n,
                    byrow = TRUE)
  est_sd = matrix(exp(rnorm(n * scenarios, log(0.8), 0.3)), scenarios, n,
                  byrow = TRUE)
  one = pit_w(true_value, est_mean[1, ], est_sd[1, ])
  all_rows = pit_w(true_value, est_mean, est_sd)
  expect_equal(all_rows$d_pit[[1]], one$d_pit, tolerance = 1e-12)
  expect_length(all_rows$d_pit, scenarios)
  expect_length(all_rows$bias, scenarios)
})

# --- coverage_prob() (eq:cover) ----------------------------------------------

test_that("coverage_prob() is 0.5 for a well calibrated estimator", {
  set.seed(4)
  n = 100000
  # F_i = N(0,1) and X_i ~ N(0,1), so the PIT values are exactly uniform.
  pit = pnorm(rnorm(n), 0, 1)
  expect_equal(coverage_prob(pit, level = 0.5), 0.5, tolerance = 0.01)
})

test_that("coverage_prob() counts the interval endpoints inclusively", {
  # eq:cover is 1(0.25 <= F_i(X_i) <= 0.75), so exact quartiles count.
  expect_equal(coverage_prob(c(0.25, 0.75), level = 0.5), 1)
})

test_that("coverage_prob() is vectorised over rows", {
  set.seed(5)
  pit = matrix(runif(200 * 4), 4, 200)
  cp = coverage_prob(pit, level = 0.5)
  expect_length(cp, 4)
  expect_equal(cp[[1]], mean(pit[1, ] >= 0.25 & pit[1, ] <= 0.75))
})

# --- threshold_misclass() (eq:tmp) -------------------------------------------

test_that("threshold_misclass() is 0 when never wrong", {
  true_value = c(-2, -1, 1, 2)
  expect_equal(
    threshold_misclass(true_value, true_value, rep(0.01, 4), threshold = 0),
    0,
    tolerance = 1e-6
  )
})

test_that("threshold_misclass() is 1 when confidently always wrong", {
  expect_equal(
    threshold_misclass(c(1, 2), c(-1, -1), rep(0.01, 2), threshold = 0),
    1,
    tolerance = 1e-6
  )
})

test_that("threshold_misclass() weights by distance from the threshold", {
  # eq:tmp weights each prediction by |g(X_i) - g(T)|. Prediction 1 is far from
  # the threshold and correct; prediction 2 is next to it and wrong, so the
  # weighted score sits near 0, whereas an unweighted mean would give 0.5.
  res = threshold_misclass(c(10, 0.1), c(10, -0.1), rep(0.01, 2), threshold = 0)
  expect_equal(res, 0.1 / 10.1, tolerance = 1e-6)
})

test_that("threshold_misclass() applies the link function g() in eq:tmp", {
  # Two predictions whose errors differ, so the |g(X) - g(T)| weighting of
  # eq:tmp changes the answer: on the log scale the near-threshold point is
  # weighted less harshly than on the identity scale.
  true_value = c(0.9, 4)
  est_mean = c(0.5, 0.5)
  plain = threshold_misclass(true_value, est_mean, rep(0.5, 2), threshold = 1)
  logged = threshold_misclass(
    true_value, est_mean, rep(0.5, 2), threshold = 1, link = log
  )
  expect_equal(plain, 0.819, tolerance = 1e-3)
  expect_equal(logged, 0.793, tolerance = 1e-3)
})

# --- rlnorm4(): the sharpness sampler (eq:valid) -----------------------------

test_that("rlnorm4() is parameterised by median and coefficient of variation", {
  set.seed(6)
  x = rlnorm4(200000, median = 0.5, coef_variation = 0.1)
  expect_equal(median(x), 0.5, tolerance = 0.01)
  expect_equal(sd(x) / mean(x), 0.1, tolerance = 0.01)
})

test_that("rlnorm4() equals stats::rlnorm under the paper's reparametrisation", {
  # main.tex eq:valid: mu = log(median), sigma = sqrt(log(cv^2 + 1)).
  set.seed(7)
  a = rlnorm4(200000, median = 0.35, coef_variation = 0.2)
  b = rlnorm(200000, log(0.35), sqrt(log(0.2^2 + 1)))
  expect_equal(mean(a), mean(b), tolerance = 0.01)
  expect_equal(var(a), var(b), tolerance = 0.02)
})
