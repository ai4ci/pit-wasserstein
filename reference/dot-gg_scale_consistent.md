# Use a colour scale from one plot in another

Multiple factor levels with custom labels are difficult to sync between
graphs if some levels are missing in the second plot. This copies the
palette from one plot to another. It is sometimes the case that we want
to reuse the fill from one plot as the color for another.

## Usage

``` r
.gg_scale_consistent(
  plot,
  original_aesthetic = c("fill", "color"),
  target_aesthetic = original_aesthetic,
  ...
)
```

## Arguments

- plot:

  a ggplot with a colour scale to clone

- original_aesthetic:

  the original aesthetic we are cloning (fill or color) (default
  `` `fill ` ``; allowed: `` `fill `,`color` ``)

- target_aesthetic:

  the aesthetic in the new plot we want to match. (default
  `` `original_aesthetic` ``)

- ...:

  Additional named arguments passed on to
  [`ggplot2::scale_fill_manual`](https://ggplot2.tidyverse.org/reference/scale_manual.html)

  `...`

  :   Arguments passed on to discrete_scale

      limitsOne of:

      NULL to use the default scale values A character vector that
      defines possible values of the scale and their order A function
      that accepts the existing (automatic) values and returns new ones.
      Also accepts rlang lambda function notation.

      dropShould unused factor levels be omitted from the scale? The
      default, TRUE, uses the levels that appear in the data; FALSE
      includes the levels in the factor. Please note that to display
      every level in a legend, the layer should use show.legend = TRUE.
      na.translateUnlike continuous scales, discrete scales can easily
      show missing values, and do so by default. If you want to remove
      missing values from a discrete scale, specify na.translate =
      FALSE. nameThe name of the scale. Used as the axis or legend
      title. If waiver(), the default, the name of the scale is taken
      from the first mapping used for that aesthetic. If NULL, the
      legend title will be omitted. minor_breaksOne of:

      NULL for no minor breaks waiver() for the default breaks (none for
      discrete, one minor break between each major break for continuous)
      A numeric vector of positions A function that given the limits
      returns a vector of minor breaks. Also accepts rlang lambda
      function notation. When the function has two arguments, it will be
      given the limits and major break positions.

      labelsOne of the options below. Please note that when labels is a
      vector, it is highly recommended to also set the breaks argument
      as a vector to protect against unintended mismatches.

      NULL for no labels waiver() for the default labels computed by the
      transformation object A character vector giving labels (must be
      same length as breaks) An expression vector (must be the same
      length as breaks). See ?plotmath for details. A function that
      takes the breaks as input and returns labels as output. Also
      accepts rlang lambda function notation.

      guideA function used to create a guide or its name. See guides()
      for more information. callThe call used to construct the scale for
      reporting messages. superThe super class to use for the
      constructed scale

  `breaks`

  :   One of:

      NULL for no breaks waiver() for the default breaks (the scale
      limits) A character vector of breaks A function that takes the
      limits as input and returns breaks as output

  `na.value`

  :   The aesthetic value to use for missing (NA) values
