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

  interfacer::ireturn(tmp, i_comparison)
}
