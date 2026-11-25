# Produce a summary plot of a experimental configuration.

Produce a summary plot of a experimental configuration.

## Usage

``` r
configuration_plot(config = i_sim_plot, xlim = c(NA, NA), labels = TRUE, ...)
```

## Arguments

- config:

  dataframe grouped by designed panels - a dataframe with columns:

  - bias_quantile (numeric + default(0.5)) - The quantile of bias of the
    plotted prediction

  - sharpness_quantile (numeric + default(0.5)) - The quantile of
    sharpness of the plotted prediction

  - true_value (numeric + default(0)) - the true value being estimated

  - estimator_dist (character + default("norm")) - the estimator
    distribution name (e.g. norm) parameterised by location
    (true_value+bias) and scale (sharpness)

  - bias_dist (character + default("norm")) - the distribution name of
    the estimator generation error function

  - bias_location (numeric + default(0)) - the location of the estimator
    generation error function, this is the true bias / mu_e

  - bias_scale (numeric + default(1)) - the scale of the estimator
    generation error function, this is the true uncertainty of the
    estimator / sigma_e

  - sharpness_dist (character + default("lnorm4")) - the distribution of
    the stated uncertainty of the estimator

  - sharpness_location (numeric + default(1)) - the location of the
    stated uncertainty of the estimator / sigma_s

  - sharpness_scale (numeric + default(0)) - the scale of the stated
    uncertainty of the estimator, determines how consistent the stated
    uncertainty is realtive to the true uncertainty / kappa,

  Any grouping allowed.

- xlim:

  limits on the x-axis (default `` `c(NA, NA)` `` \[logical\])

- labels:

  include labels on graphs - too cluttered on mulitple panels (default
  `` `TRUE` `` \[logical\])

- ...:

  addtionally passed on to

## Value

a ggplot
