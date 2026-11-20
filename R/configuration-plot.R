#' Produce a summary plot of a experimental configuration.
#'
#' @iparam config dataframe grouped by designed panels
#' @param xlim limits on the x-axis
#' @param labels include labels on graphs - too cluttered on mulitple panels
#' @param ... addtionally passed on to
#' @concept simulations
#'
#' @returns a ggplot
#' @export
configuration_plot = function(config = i_sim_plot, xlim = c(NA, NA), labels = TRUE, ...) {
  config = interfacer::ivalidate(config, .fix = TRUE)
  config = config %>% dplyr::distinct()

  config = config %>% dplyr::group_modify(function(d, g, ...) {
    if (nrow(d) > 1) stop("grouping must result in unique rows")

    bias_qfn = function(q) {
      rlang::as_function(sprintf("q%s", d$bias_dist))(
        q,
        d$bias_location,
        d$bias_scale
      )
    }
    bias_dfn = function(x) {
      rlang::as_function(sprintf("d%s", d$bias_dist))(
        x,
        d$bias_location,
        d$bias_scale
      )
    }

    sharpness_qfn = function(q) {
      rlang::as_function(sprintf("q%s", d$sharpness_dist))(
        q,
        d$sharpness_location,
        d$sharpness_scale
      )
    }
    sharpness_dfn = function(x) {
      rlang::as_function(sprintf("d%s", d$sharpness_dist))(
        x,
        d$sharpness_location,
        d$sharpness_scale
      )
    }

    bias_value = bias_qfn(d$bias_quantile)
    sharpness_value = sharpness_qfn(d$sharpness_quantile)

    estimator_qfn = function(q) {
      rlang::as_function(sprintf("q%s", d$estimator_dist))(
        q,
        d$true_value + bias_value,
        sharpness_value
      )
    }
    estimator_dfn = function(x) {
      rlang::as_function(sprintf("d%s", d$estimator_dist))(
        x,
        d$true_value + bias_value,
        sharpness_value
      )
    }
    #
    xmin = min(c(
      d$true_value,
      bias_qfn(0.025) + d$true_value,
      estimator_qfn(0.025),
      d$true_value + bias_value + bias_qfn(0.025)
    ))
    xmax = max(c(
      d$true_value,
      bias_qfn(0.975) + d$true_value,
      estimator_qfn(0.975),
      d$true_value + bias_value + bias_qfn(0.975)
    ))
    expand = (xmax - xmin) * 0.1
    xmin = xmin - expand
    xmax = xmax + expand
    if (!is.na(xlim[1])) xmin = xlim[1]
    if (!is.na(xlim[2])) xmax = xlim[2]


    xseq = seq(xmin, xmax, 0.01)
    # Offset bias distribution by true value
    y_bias = bias_dfn(xseq - d$true_value)
    # Offset sharpness distribution to selected bias & true value
    y_sharpness = sharpness_dfn(xseq - d$true_value - bias_value)
    y_estimator = estimator_dfn(xseq)

    d %>% dplyr::mutate(
      xmax = xmax,
      xmin = xmin,
      bias_qfn = list(bias_qfn),
      bias_dfn = list(bias_dfn),
      sharpness_qfn = list(sharpness_qfn),
      sharpness_dfn = list(sharpness_dfn),
      estimator_qfn = list(estimator_qfn),
      estimator_dfn = list(estimator_dfn),
      bias_value = bias_value,
      bias_value_density = bias_dfn(bias_value),
      bias_max_value = bias_dfn(bias_qfn(0.5)),
      sharpness_value = sharpness_value,
      sharpness_value_density = sharpness_dfn(sharpness_value),
      sharpness.0.5 = sharpness_qfn(0.5),
      estimate.0.025 = estimator_qfn(0.025),
      estimate.0.5 = estimator_qfn(0.5),
      estimate.0.975 = estimator_qfn(0.975),
      distributions = list(dplyr::tibble(
        x = xseq,
        y_bias = ifelse(y_bias > 0, y_bias, NA),
        y_sharpness = ifelse(y_sharpness > 0, y_sharpness, NA),
        y_estimator = ifelse(y_estimator > 0, y_estimator, NA)
      )),
      bias_q = list(dplyr::tibble(
        q = c(0.025, 0.5, 0.975),
        x = bias_qfn(q) + d$true_value,
        p = bias_dfn(bias_qfn(q))
      )),
      sharpness_q = list(dplyr::tibble(
        q = c(0.025, 0.5, 0.975),
        x = sharpness_qfn(q) + d$true_value + bias_value,
        p = sharpness_dfn(sharpness_qfn(q))
      )),
      estimator_q = list(dplyr::tibble(
        q = c(0.025, 0.5, 0.975),
        x = estimator_qfn(q),
        p = estimator_dfn(estimator_qfn(q))
      ))
    )
  })

  grps = dplyr::group_vars(config)

  btrans = function(y) {
    return(y + 0.1)
  }

  strans = function(y) {
    return(-y * 0.1 - 0.1)
  }

  etrans = function(y) {
    return(y)
  }

  # fig1_intro =
  tmp = ggplot2::ggplot() +
    ggplot2::theme(
      axis.line.y = ggplot2::element_blank(),
      axis.ticks.y = ggplot2::element_blank(),
      axis.text.y = ggplot2::element_blank(),
      axis.title.y = ggplot2::element_blank()
    ) +
    # True value
    ggplot2::geom_vline(
      data = config,
      mapping = ggplot2::aes(xintercept = true_value),
      colour = "blue",
      size = 0.75
    ) +
    (if (labels) {
      ggplot2::geom_text(
        data = config,
        mapping = ggplot2::aes(x = true_value, y = strans(0)),
        label = "true value",
        hjust = 1,
        vjust = -0.5,
        angle = 90,
        colour = "blue"
      )
    } else {
      NULL
    }) +
    ggplot2::geom_errorbarh(
      data = config,
      ggplot2::aes(
        xmin = true_value,
        xmax = bias_location + true_value,
        y = btrans(bias_max_value)
      ),
      colour = "blue",
      width = 0.05,
      linewidth = 1
    ) +
    # Spread distribution
    ggplot2::geom_ribbon(
      data = config %>% tidyr::unnest(distributions),
      ggplot2::aes(x = x, ymin = strans(y_sharpness), ymax = strans(0)),
      fill = "orange",
      colour = "orange",
      alpha = 0.2
    ) +
    ggplot2::geom_segment(
      data = config %>% tidyr::unnest(sharpness_q),
      ggplot2::aes(
        x = x,
        y = strans(p),
        xend = x,
        yend = strans(0)
      ),
      linetype = "dashed",
      colour = "orange",
    ) +
    ggplot2::geom_errorbarh(
      data = config,
      ggplot2::aes(
        xmin = bias_value + true_value,
        xmax = bias_value + true_value + sharpness.0.5,
        y = strans(0)
      ),
      colour = "orange",
      width = 0.05,
      linewidth = 1
    ) +
    (if (labels) {
      ggplot2::geom_text(
        data = config,
        ggplot2::aes(x = xmax),
        y = strans(0),
        label = "estimator spread distribution",
        hjust = 1,
        vjust = 0,
        colour = "orange"
      )
    } else {
      NULL
    }) +
    # Bias Function
    ggplot2::geom_ribbon(
      data = config %>% tidyr::unnest(distributions),
      ggplot2::aes(x = x, ymin = btrans(0), ymax = btrans(y_bias)),
      fill = "red",
      colour = "red",
      alpha = 0.2
    ) +
    ggplot2::geom_segment(
      data = config %>% tidyr::unnest(bias_q),
      ggplot2::aes(x = x, y = btrans(p), xend = x, yend = btrans(0)),
      linetype = "dashed",
      colour = "red",
    ) +
    (if (labels) {
      ggplot2::geom_text(
        data = config,
        ggplot2::aes(x = xmax),
        y = btrans(0),
        label = "estimator error distribution",
        hjust = 1,
        vjust = 0,
        colour = "red"
      )
    } else {
      NULL
    }) +
    ggplot2::geom_errorbarh(
      data = config,
      ggplot2::aes(
        xmin = bias_location + true_value,
        xmax = bias_location + true_value + bias_scale,
        y = 0.1
      ),
      colour = "red",
      width = 0.05,
      linewidth = 1
    ) +
    # Estimate Function
    ggplot2::geom_ribbon(
      data = config %>% tidyr::unnest(distributions),
      ggplot2::aes(x = x, ymin = etrans(y_estimator), ymax = etrans(0)),
      fill = "black",
      colour = "black",
      alpha = 0.2
    ) +
    ggplot2::geom_segment(
      data = config %>% tidyr::unnest(estimator_q),
      ggplot2::aes(x = x, y = etrans(p), xend = x, yend = etrans(0)),
      linetype = "dashed",
      colour = "black",
    ) +
    (if (labels) {
      ggplot2::geom_text(
        data = config,
        ggplot2::aes(x = xmax),
        y = etrans(0),
        label = "one prediction distribution",
        hjust = 1,
        vjust = 0,
        colour = "black"
      )
    } else {
      NULL
    }) +
    ggplot2::geom_errorbarh(
      data = config,
      ggplot2::aes(
        xmin = bias_value + true_value,
        xmax = bias_value + true_value + sharpness_value,
        y = etrans(0)
      ),
      colour = "black",
      width = 0.05,
      linewidth = 1
    ) +
    (if (labels) {
      ggplot2::geom_text(
        data = config,
        ggplot2::aes(x = bias_value + true_value + sharpness_value * 0.5),
        y = etrans(0),
        label = "SD",
        hjust = 0,
        vjust = 1.5,
        colour = "black"
      )
    } else {
      NULL
    }) +
    ggplot2::geom_point(
      data = config,
      ggplot2::aes(x = bias_value + true_value, y = btrans(bias_value_density)),
      colour = "grey20",
      size = 2
    ) +
    ggplot2::geom_segment(
      data = config,
      ggplot2::aes(
        x = bias_value + true_value,
        y = btrans(bias_value_density),
        xend = bias_value + true_value
      ),
      yend = etrans(0),
      arrow = ggplot2::arrow(
        angle = 20,
        length = ggplot2::unit(2, "mm"),
        type = "closed"
      ),
      colour = "grey20"
    ) +
    ggplot2::geom_point(
      data = config,
      ggplot2::aes(
        x = bias_value + true_value + sharpness_value,
        y = strans(sharpness_value_density)
      ),
      colour = "grey20",
      size = 2
    ) +
    ggplot2::geom_segment(
      data = config,
      ggplot2::aes(
        x = bias_value + true_value + sharpness_value,
        y = strans(sharpness_value_density),
        xend = bias_value + true_value + sharpness_value
      ),
      yend = etrans(0),
      arrow = ggplot2::arrow(
        angle = 20,
        length = ggplot2::unit(2, "mm"),
        type = "closed"
      ),
      colour = "grey20"
    )

  if (length(grps) > 0) {
    if (length(grps) == 2) {
      tmp = tmp + ggplot2::facet_grid(
        stats::as.formula(sprintf("%s ~ %s", grps[1], grps[2])),
        ...
      )
    } else {
      tmp = tmp + ggplot2::facet_wrap(grps, ...)
    }
  }

  return(tmp)
}
