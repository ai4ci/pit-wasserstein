library(tidyverse)
devtools::load_all()

config = tibble(
  true_value = 1,
  bias_location = c(1),
  bias_scale = c(1),
  sharpness_location = c(0.5),
  sharpness_scale = 0.4,
  bias_quantile = c(0.7),
  sharpness_quantile = c(0.5)
)

.gg_pedantic()

subplot = configuration_plot(config, xlim = c(-2, 5), labels = FALSE) + theme_void()

geom_hexagon = function(radius, x = 0, y = 0, ..., label = NA) {
  hexd = data.frame(
    x_coord = c(rep(-sqrt(3) / 2, 2), 0, rep(sqrt(3) / 2, 2), 0),
    y_coord = c(0.5, -0.5, -1, -0.5, 0.5, 1)
  )
  hexd = rbind(hexd, hexd[1, ])

  hexd2 = hexd %>% mutate(
    x_coord = x_coord * radius + x,
    y_coord = y_coord * radius + y,
  )

  out = geom_polygon(aes(x = !!sym("x_coord"), y = !!sym("y_coord")), data = hexd2, ...)
  if (is.list(label)) {
    label = as.list(label)
    label = modifyList(
      list(edge = 1, vjust = 0.9, hjust = 0.5, text = "set text"),
      label
    )
    i = (label$edge - 1) %/% 6 + 1
    xstart = rev(hexd$x_coord)[i]
    xend = rev(hexd$x_coord)[i + 1]
    ystart = rev(hexd$y_coord)[i]
    yend = rev(hexd$y_coord)[i + 1]

    angle = atan2((yend - ystart), (xend - xstart)) * 180 / pi
    x_coord = ((xend - xstart) * label$hjust + xstart) * label$vjust
    y_coord = ((yend - ystart) * label$hjust + ystart) * label$vjust

    x_coord = x_coord * radius + x
    y_coord = y_coord * radius + y

    params = label[!names(label) %in% c("edge", "vjust", "text", "angle", "geom")]
    params$x = x_coord
    params$y = y_coord
    params$label = label$text
    params$angle = angle
    params$geom = "text"

    out = list(out, rlang::exec(.fn = ggpp::annotate, !!!params))
  }
  return(out)
}
# ggplot() +
#   geom_hexagon(
#     1,
#     colour = "black",
#     fill = NA,
#     label = list(text = "hello", size = 40, size.unit="pt",vjust=0.9,hjust=1)
#   )

radius = 1
p = ggplot() +
  geom_hexagon(
    1 * radius,
    fill = "darkorange",
    colour = "black",
    linewidth = 0.1
  ) +
  geom_hexagon(
    0.9 * radius,
    fill = "white",
    colour = "black",
    linewidth = 0.1,
    label = list(
      text = "pitw",
      size = 12,
      size.unit = "pt",
      vjust = 0.85,
      hjust = 0,
      colour = "darkorange"
    )
  ) +
  ggpp::annotate(
    geom = "plot",
    x = 0,
    y = 0,
    label = list(subplot),
    vp.width = 0.7,
    vp.height = 0.7
  ) +
  theme_void() +
  coord_fixed()

.gg_save_as(
  p,
  filename = .here("man/figures/logo"),
  formats = c("svg", "png"),
  maxHeight = 2,
  aspectRatio = 1
)
