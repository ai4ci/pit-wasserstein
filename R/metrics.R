# Reference implementation of the metrics defined in main/main.tex.
#
# Not a package: .Rprofile sources this file into the global environment, the
# same way it sources the vendored standalones in R/. Tests live in
# tests/testthat/ and are written against the paper's equations rather than
# against the previous inline behaviour of analysis.R.
#
#   eq:pit2  D*_pit   adjusted PIT-Wasserstein       -> pit_w()$d_pit
#   eq:pit3  U*_pit   directed PIT-Wasserstein       -> pit_w()$u_pit
#   eq:cover P_X,0.5  coverage probability           -> coverage_prob()
#   eq:tmp   P_err    threshold misclassification    -> threshold_misclass()
#   eq:valid lognormal sharpness by median and CV    -> rlnorm4()
#
# Convention shared by every function here: `true_value` is one vector of the
# n true values for an estimator; `est_mean` / `est_sd` are either that same
# length-n vector (a single estimator) or an S x n matrix whose ROWS are
# estimators. Functions return one value per row, or a scalar for one row.

# --- helpers ------------------------------------------------------------------

#' The ideal PIT quantiles: rank_i = (i - 0.5) / n of eq:pit2
#' @param n number of predictions
#' @return an increasing vector of length n from 0.5/n to 1 - 0.5/n
rank_of = function(n) seq(0.5 / n, 1 - 0.5 / n, length.out = n)

#' Row-wise sort, keeping a single row as a matrix
.sort_rows = function(m) {
  m = if (is.matrix(m)) m else matrix(m, nrow = 1)
  t(apply(m, 1, sort))
}

#' Lay a length-n vector out as an S x n matrix with identical rows
#'
#' Elementwise recycling against a matrix walks the vector down the *columns*
#' (storage order), so `mat - true_value` silently misaligns unless S == n.
#' Every place a per-prediction vector meets a per-estimator matrix goes
#' through here.
#' @param x a vector of length n
#' @param rows number of estimators S
.recyc_rows = function(x, rows) matrix(x, nrow = rows, ncol = length(x), byrow = TRUE)

#' Broadcast one value per estimator across the n predictions of that row
#' @param x a vector of length S (one value per estimator row)
#' @param n number of predictions
.recyc_cols = function(x, n) matrix(x, nrow = length(x), ncol = n)

#' Coerce estimator parameters to one row per estimator
#' @param x a length-n vector or an S x n matrix
#' @param n number of predictions
.as_rows = function(x, n) {
  if (is.matrix(x)) {
    if (ncol(x) != n) {
      stop("estimator matrix has ", ncol(x), " columns but there are ", n, " true values")
    }
    return(x)
  }
  if (length(x) != n) stop("estimator parameters must have length ", n)
  matrix(x, nrow = 1, ncol = n)
}

# --- pit_w(): D*_pit (eq:pit2) and U*_pit (eq:pit3) --------------------------

#' Adjusted PIT-Wasserstein metrics
#'
#' The reference implementation of the paper's two headline metrics. The
#' estimates are first adjusted for the estimator's average bias, the PIT
#' values are recomputed from the adjusted estimates, and their Wasserstein
#' distance to the uniform is taken.
#'
#' `d_pit` (D*_pit, eq:pit2) is the mean absolute distance between the sorted
#' adjusted PIT values and \code{rank_i}. It is non-negative, 0 for a perfectly
#' calibrated estimator and 0.5 when all PIT mass sits at one point, and it is
#' invariant to bias by construction.
#'
#' `u_pit` (U*_pit, eq:pit3) weights each move by \code{sign(0.5 - rank_i)}, so
#' mass moving away from the centre (over-confidence) is positive and mass
#' moving towards it (excessive uncertainty) is negative. It spans
#' \code{[-0.25, 0.25]} and 0 is ideal.
#'
#' @param true_value vector of the n true values
#' @param est_mean central value of each prediction: length n, or S x n
#' @param est_sd dispersion of each prediction: length n, or S x n
#' @param cdf cumulative distribution function of the predictive family, called
#'   as \code{cdf(q, mean, sd)}. Defaults to \code{stats::pnorm}.
#' @return a list of numeric vectors, one element per estimator: `d_pit`,
#'   `u_pit`, `bias`, and `raw_wasserstein` (the unadjusted distance, kept
#'   because it is what bias does to a naive PIT-Wasserstein).
pit_w = function(true_value, est_mean, est_sd, cdf = stats::pnorm) {
  fn = match.fun(cdf)
  n = length(true_value)
  est_mean = .as_rows(est_mean, n)
  est_sd = .as_rows(est_sd, n)
  if (nrow(est_sd) != nrow(est_mean)) {
    stop("est_mean and est_sd must have the same number of estimator rows")
  }
  tv = .recyc_rows(true_value, nrow(est_mean))
  ranks = .recyc_rows(rank_of(n), nrow(est_mean))

  # bias = mean(est_mean - true_value), the estimator-level average bias
  bias = rowMeans(est_mean - tv)
  adj_mean = est_mean - .recyc_cols(bias, n)

  pit_adj = .sort_rows(fn(tv, adj_mean, est_sd))
  diff = ranks - pit_adj
  structure(
    list(
      d_pit = rowMeans(abs(diff)),
      u_pit = rowMeans(diff * .recyc_rows(sign(0.5 - rank_of(n)), nrow(est_mean))),
      bias = bias,
      raw_wasserstein = rowMeans(abs(ranks - .sort_rows(fn(tv, est_mean, est_sd))))
    ),
    class = "pitw"
  )
}

# --- coverage_prob() (eq:cover) ----------------------------------------------

#' Coverage probability
#'
#' The proportion of predictions whose PIT value falls in the central interval
#' of eq:cover. Indicators are inclusive of the interval endpoints, as written
#' in the paper: \code{1(level_lo <= F_i(X_i) <= level_hi)}. A well calibrated
#' estimator scores `level`; over-confident estimators score lower and
#' excessively conservative ones higher.
#'
#' @param pit PIT values, or an S x n matrix of them
#' @param level the interval width, e.g. 0.5 for the inter-quartile range
#' @return one proportion per row, or a scalar for a plain vector
coverage_prob = function(pit, level = 0.5) {
  lo = (1 - level) / 2
  hi = 1 - lo
  pit = if (is.matrix(pit)) pit else matrix(pit, nrow = 1)
  rowMeans(pit >= lo & pit <= hi)
}

# --- threshold_misclass() (eq:tmp) -------------------------------------------

#' Threshold misclassification probability
#'
#' eq:tmp. Each prediction's error is \code{|F_i(T) - 1(X_i <= T)|}: how far
#' the probability the estimator assigns to being below the threshold sits from
#' the truth. Those errors are averaged weighted by \code{|g(X_i) - g(T)|}, so
#' predictions far from the threshold dominate -- the decisions that are easy
#' are the ones that count most. For R_t the threshold is 1 and g is usually
#' \code{log}.
#'
#' @inheritParams pit_w
#' @param threshold the decision threshold T, e.g. 1 for R_t
#' @param link the function g of eq:tmp, applied to both X and T
#' @return one probability per estimator; lower is better
threshold_misclass = function(true_value, est_mean, est_sd, threshold,
                              link = identity, cdf = stats::pnorm) {
  fn = match.fun(cdf)
  n = length(true_value)
  est_mean = .as_rows(est_mean, n)
  est_sd = .as_rows(est_sd, n)
  tv = .recyc_rows(true_value, nrow(est_mean))
  err = matrix(
    fn(threshold, est_mean, est_sd), nrow = nrow(est_mean), ncol = n
  ) - .recyc_rows(as.numeric(true_value <= threshold), nrow(est_mean))
  w = .recyc_rows(abs(link(true_value) - link(threshold)), nrow(est_mean))
  rowSums(abs(err) * w) / rowSums(w)
}

# --- rlnorm4(): the sharpness sampler (eq:valid) -----------------------------

#' Sample a lognormal by median and coefficient of variation
#'
#' The \eqn{\sigma_i} sharpness draw of eq:valid. Kept from analysis.R and now
#' tested: it is equivalent to \code{stats::rlnorm(n, log(median),
#' sqrt(log(coef_variation^2 + 1)))}.
#'
#' @param n number of draws
#' @param median the median of the resulting distribution
#' @param coef_variation standard deviation divided by mean
rlnorm4 = function(n, median, coef_variation) {
  stats::rlnorm(n, log(median), sqrt(log(coef_variation^2 + 1)))
}
