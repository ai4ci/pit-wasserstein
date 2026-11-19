#' Generate an set of scenarios for testing scoring
#'
#' Scenarios are based on an estimator producing predictions as parametrised
#' distributions, and the estimator can be characterised in terms of the bias
#' and sharpness distributions that govern predictions. Predictions are
#' then expressed as samples from these bias and sharpness distributions and
#' the associated distribution function (which will be parameterised with
#' `mean = bias` and `sd = sharpness`)
#'
#' @iparam config the simulation configuration
#' @param true_value_fn a function that generates the true values e.g. a random sampler
#' @export
#'
#' @returns a
#' @examples
#' config = dplyr::tibble(samples = 100)
#' config %>% generate_simulation()
generate_simulation = function(config = i_sim_config, true_value_fn = NULL) {
  config = interfacer::ivalidate(config, .fix = TRUE)

  tmp = config %>%
    dplyr::mutate(
      run_id = dplyr::row_number(),
      calibration = sharpness_location / bias_scale
    ) %>%
    dplyr::group_by(dplyr::pick(-true_value)) %>%
    dplyr::group_modify(function(d, g, ...) {
      rbias_fn = rlang::as_function(sprintf("r%s", g$bias_dist))
      rsharpness_fn = rlang::as_function(sprintf("r%s", g$sharpness_dist))

      if (!is.null(true_value_fn)) {
        true_value_fn = rlang::as_function(true_value_fn)
        true_value = true_value_fn(g$samples)
      } else {
        true_value = d$true_value
      }
      bias = rbias_fn(g$samples, g$bias_location, g$bias_scale)
      sharpness = rsharpness_fn(g$samples, g$sharpness_location, g$sharpness_scale)

      return(dplyr::tibble(
        estimate_id = seq_len(g$samples),
        true_value = true_value,
        location = true_value + bias,
        scale = sharpness,
      ))
    }) %>%
    dplyr::rename(dist = estimator_dist)

  interfacer::ireturn(tmp, i_comparison, .fix = TRUE)
}


#' Uniform predictions for testing
#'
#' Predictions whose PIT values are exactly uniform, for a scale family
#' (gamma4, lnorm4, ...) where `location` is the median.
#'
#' @param n the number of samples
#' @param median the median
#' @param kappa a spread parameter, typically dispersion (sigma/mu)
#' @param qfn a quantile function parametrised by median and something else
#'
#' @returns a set of locations for a distribution family that map directly
#' to uniform PIT values.
#'
#' @export
#'
#' @examples
#' loc = calibrated_locations(qfn = qgamma4, median = 1, kappa = 0.5)
#' pit_w(1, loc, 0.5, dist = "gamma4", link = "log")$B_pit # ~1e-17
calibrated_locations = function(qfn, median, kappa, n = 100) {
  qs = seq(1, 2 * n - 1, 2) / (2 * n)
  median / qfn(1 - qs, 1, kappa)
}

#' Uniform predictions for testing (general)
#'
#' For a general (non-scale) family, solve it numerically instead:
#'
#' @param n the number of samples
#' @param median the median
#' @param kappa a spread parameter, typically dispersion (sigma/mu)
#' @param pfn a CDF parametrised by mean and the spread parameter
#' @param interval uniroot limits
#'
#' @returns a set of locations for a distribution family that map directly
#' to uniform PIT values.
#' @export
calibrated_locations_general = function(pfn, median, kappa, n = 100, interval = c(1e-8, 1e8)) {
  qs = seq(1, 2 * n - 1, 2) / (2 * n)
  vapply(qs, function(q) {
    stats::uniroot(function(mu) pfn(median, mu, kappa) - (1 - q), interval)$root
  }, numeric(1))
}
