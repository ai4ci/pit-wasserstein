#' Score a parametrised probability distribution
#'
#' Create a basket of scores for a set of paramtrised probabilistic predictions compared
#' to a known ground truth, predictions are assumed to be distributional and
#' associated with a link function that transforms them to linear space.
#'
#' @iparam df input dataframe
#' @param summarise produce the results as a groupwise summary or a prediction by prediction metric
#' @param threshold If given calculates the threshold misclassification probability
#' @returns a dataframe. columns depend on `summarise`
#' @unit
#' qs = seq(1,199,2)/200
#' df = tidyr::crossing(
#'     true_value = 0,
#'     location = qnorm(qs, 1, 1),
#'     scale = c(1/2,1/1.5,1,1.5,2),
#'     dist="norm", link="identity") %>%
#'   dplyr::mutate(calibration=scale) %>%
#'   dplyr::group_by(dist, link, calibration)
#' df %>% prediction_scores() %>% view()
prediction_scores = function(df = i_comparison, summarise = TRUE, threshold = NA_real_) {
  df = interfacer::ivalidate(df)
  # bias is positive if prediction mean > true value

  out = df %>%
    dplyr::group_modify(
      function(d, g, ..) {
        ln = make.link(g$link)
        cdf = rlang::as_function(sprintf("p%s", g$dist))
        inv_cdf = rlang::as_function(sprintf("q%s", g$dist))

        if (length(intersect(c("mean", "sd"), names(formals(pnorm)))) != 2) {
          stop("the prediction distribution must be parametrised by mean and SD")
        }

        medians = inv_cdf(0.5, d$location, d$scale)
        link_bias = mean(ln$linkfun(medians) - ln$linkfun(d$true_value))

        crps_fn = crps_fn_generator(g$dist)
        tmp = d %>%
          dplyr::mutate(
            bias = ln$linkinv(link_bias),
            adj_true_value = ln$linkinv(ln$linkfun(true_value) + link_bias),
            # adj_location = ln$linkinv(ln$linkfun(location) - link_bias),
            u_i_unadj = cdf(true_value, location, scale),
            univ_resid = 2 * u_i_unadj - 1,
            u_i = cdf(adj_true_value, location, scale),
            # u_i = cdf(true_value, adj_location, scale),
            rank_order = rank(u_i, ties.method = "first"),
            unif = (rank_order * 2 - 1) / (2 * g$samples),
            u_pit_unadj = abs(unif - u_i_unadj),
            u_pit = abs(unif - u_i),
            d_pit = (unif - u_i) * sign(0.5 - unif),
            P_i_err = abs(cdf(threshold) - (adj_true_value < threshold)),
            abs_diff_gX_gT = abs(ln$linkfun(true_value) - ln$linkfun(threshold)),
            crps = crps_fn(
              true_value = true_value,
              location = location,
              scale = scale
            ),
            pred_interval_width.0.5 = inv_cdf(0.75, location, scale) - inv_cdf(0.25, location, scale),
            covered.0.5_adj = (inv_cdf(0.75, location, scale)) > adj_true_value & (adj_true_value > inv_cdf(0.25, location, scale)),
            covered.0.5 = (inv_cdf(0.75, location, scale)) > true_value & (true_value > inv_cdf(0.25, location, scale)),
            covered.0.95 = (inv_cdf(0.975, location, scale)) > true_value & (true_value > inv_cdf(0.025, location, scale))
          )
        return(tmp)
      }
    )

  if (!summarise) {
    return(out)
  }

  tmp2 = out %>%
    dplyr::summarise(
      bias = mean(bias),
      universal_bias = mean(univ_resid),
      mean_crps = mean(crps),
      mean_pred_interval_width.0.5 = mean(pred_interval_width.0.5),
      mean_coverage.0.5 = mean(covered.0.5),
      mean_coverage.0.5_adj = mean(covered.0.5_adj),
      mean_coverage.0.95 = mean(covered.0.95),
      U_pit_unadj = mean(u_pit_unadj),
      U_pit = mean(u_pit),
      D_pit = mean(d_pit),
      P_misclass = sum(P_i_err * abs_diff_gX_gT) / sum(abs_diff_gX_gT),
      calibration = mean(calibration),
      .groups = "keep"
    )

  return(tmp2)
}


#' Calculate a pit-wasserstein value for a single estimator
#'
#' An estimator produces multiple parametrised probability distributions, from
#' which we can calculate scores such as CPRS and PIT-W
#'
#' @param true_value The true value
#' @param location The central estimate of the probabilistic prediction
#' @param scale The spread estimate of the probabilisitic prediction
#' @param dist The distribution name of the prediction
#' @param link A link function mapping the value space to a linear one, e.g. "identity", "log"
#'
#' @returns a one row data frame with:
#' * `U_pit` an undirected pit-wasserstein
#' * `D_pit` a directed pit-wasserstein
#' * `U_pit_unadj` raw unadjusted undrected pit-wasserstein
#' @export
#'
#' @unit
#' qs = seq(1,199,2)/200
#' scores = pit_w(0, qnorm(qs, 0, 1), 1, dist = "norm", link="identity")
#' testthat::expect_equal(scores$undirected_pit_w, 0)
#'
#' scores = pit_w(1, qlnorm4(qs, 1, 1), 1, dist = "lnorm4", link="log")
#' testthat::expect_equal(scores$undirected_pit_w, 0)
#'
#' scores = pit_w(1, qlnorm4(qs, 1, 1), 1, dist = "lnorm4", link="log")
#' testthat::expect_equal(scores$undirected_pit_w, 0)
#'
pit_w = function(
  true_value,
  location,
  scale,
  dist = "norm",
  link = "identity"
) {
  n = interfacer::recycle(true_value, location, scale)

  cdf = rlang::as_function(sprintf("p%s", dist))
  inv_cdf = rlang::as_function(sprintf("q%s", dist))
  ln = make.link(link)

  link_medians = ln$linkfun(inv_cdf(0.5, location, scale))
  link_true_value = ln$linkfun(true_value)
  link_bias = mean(link_medians - link_true_value)
  adj_true_value = ln$linkinv(link_true_value + link_bias)

  pit_unadj = cdf(true_value, location, scale)
  pit_unadj = sort(pit_unadj)

  pit = cdf(adj_true_value, location, scale)
  pit = sort(pit)

  rank = seq(0.5 / n, 1 - 0.5 / n, length.out = n)

  return(dplyr::tibble(
    U_pit = mean(abs(pit - rank)),
    U_pit_unadj = mean(abs(pit_unadj - rank)),
    D_pit = mean((rank - pit) * sign(0.5 - rank)),
  ))
}

#' Generate a CRPS calculating function based on a parametrised distribution name
#'
#' `scoringRules` has implementations of common functions but not so much for
#' re-parametrisations. This detects if a re-parametrisation is available for a
#' distribution name and remaps the input to a more common distribution that
#' `scoringRules` has support for.
#'
#' @param dist_name the name of the distribution, e.g. `norm`, `lnorm4`
#'
#' @returns a function which takes 3 parameters: true_value, location, and scale
#' and returns a CRPS for them.
#' @export
#'
#' @unit
#' fn=crps_fn_generator("lnorm4")
#' mapped = fn(1:5,1,2)
#' tmp = .reparam.lnorm4(1,2)
#' direct = scoringRules::crps(1:5, tmp$dist, meanlog = tmp$meanlog, sdlog = tmp$sdlog)
#' testthat::expect_equal(mapped, direct)
crps_fn_generator = function(dist_name) {
  reparam_fn = try(
    rlang::as_function(sprintf(".reparam.%s", dist_name)),
    silent = TRUE
  )

  if (!inherits(reparam_fn, "try-error")) {
    tmp = reparam_fn(NA, NA)
    dist_name_2 = tmp$dist
    param_name = names(tmp)[2:3]
  } else {
    tmp_fn = try(rlang::as_function(sprintf("r%s", dist_name)), silent = TRUE)
    if (inherits(tmp_fn, "try-error")) {
      stop(
        "cannot resolve function for: ",
        dist_name,
        " and no reparameterisation exists"
      )
    }
    dist_name_2 = dist_name
    param_name = names(formals(tmp_fn))[2:3]
  }

  crps_args = list(y = 0, family = dist_name_2)
  crps_args[param_name] = NA
  tmp = try(
    rlang::exec(scoringRules::crps.numeric, !!!crps_args),
    silent = TRUE
  )
  if (inherits(tmp, "try-error") && stringr::str_detect(tmp, "Could not find parametric family")) {
    stop(sprintf(
      "no crps method for `%s` (reparameterised from `%s`)",
      dist_name_2,
      dist_name
    ))
  }

  if (inherits(reparam_fn, "try-error")) {
    # direct CRPS
    return(function(true_value, location, scale) {
      crps_args = list(y = true_value, family = dist_name_2)
      crps_args[[param_name[1]]] = location
      crps_args[[param_name[2]]] = scale
      return(rlang::exec(scoringRules::crps.numeric, !!!crps_args))
    })
  } else {
    # transform then CRPS
    return(function(true_value, location, scale) {
      tmp = reparam_fn(location, scale)
      crps_args = c(list(y = true_value, family = dist_name_2), tmp[2:3])
      return(rlang::exec(scoringRules::crps.numeric, !!!crps_args))
    })
  }
}
