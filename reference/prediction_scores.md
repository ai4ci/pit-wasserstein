# Score a parametrised probability distribution

Create a basket of scores for a set of paramtrised probabilistic
predictions compared to a known ground truth, predictions are assumed to
be distributional and associated with a link function that transforms
them to linear space.

## Usage

``` r
prediction_scores(df = i_comparison, summarise = TRUE, threshold = NA_real_)
```

## Arguments

- df:

  input dataframe - a dataframe with columns:

  - true_value (numeric) - the true value

  - link (character + default("identity")) - a transformation that puts
    the quantity being estimated on a linear scale

  - location (numeric) - the location parameter is the estimator mean or
    median (i.e. the central estimate)

  - scale (numeric) - the scale parameter is the stated estimator
    uncertainty (i.e. the sharpness)

  - dist (character + default("norm")) - the estimator distribution name
    (e.g. norm) parameterised by location and scale

  - calibration (numeric) - the calibration as determined by the SD of
    the probabilistic prediction (sharpness) / the SD of the true values
    distribution, overconfident is \<1, and conservative is \>1

  - adjust (character + default("link")) - method for adjusting for
    bias. Either link function adjustment of true values, or probit
    adjustment of PIT values

  Minimally grouped by: dist + link + calibration + adjust (and other
  groupings allowed).

- summarise:

  produce the results as a groupwise summary or a prediction by
  prediction metric (default `` `TRUE` `` \[logical\])

- threshold:

  If given calculates the threshold misclassification probability
  (default `` `NA` `` \[numeric\])

## Value

a dataframe. columns depend on `summarise`

## Examples

``` r
qs = seq(1, 199, 2) / 200
df = tidyr::crossing(
  true_value = 0,
  location = stats::qnorm(qs, 1, 1),
  scale = c(1 / 2, 1 / 1.5, 1, 1.5, 2),
  dist = "norm",
  link = "identity"
) %>%
  dplyr::mutate(calibration = scale) %>%
  dplyr::group_by(dist, link, calibration)
df %>%
  prediction_scores() %>%
  dplyr::glimpse()
#> Rows: 5
#> Columns: 16
#> Groups: dist, link, calibration, adjust [5]
#> $ dist                         <chr> "norm", "norm", "norm", "norm", "norm"
#> $ link                         <chr> "identity", "identity", "identity", "iden…
#> $ calibration                  <dbl> 0.5000000, 0.6666667, 1.0000000, 1.500000…
#> $ adjust                       <chr> "link", "link", "link", "link", "link"
#> $ n_predictions                <int> 100, 100, 100, 100, 100
#> $ bias                         <dbl> 1, 1, 1, 1, 1
#> $ universal_bias               <dbl> -0.6289060, -0.5946298, -0.5206077, -0.42…
#> $ mean_crps                    <dbl> 0.9426907, 0.8947629, 0.8330495, 0.806015…
#> $ mean_pred_interval_width.0.5 <dbl> 0.6744898, 0.8993197, 1.3489795, 2.023469…
#> $ mean_coverage.0.5            <dbl> 0.16, 0.22, 0.32, 0.48, 0.63
#> $ mean_coverage.0.5_adj        <dbl> 0.26, 0.34, 0.50, 0.68, 0.82
#> $ mean_coverage.0.95           <dbl> 0.47, 0.61, 0.83, 0.97, 1.00
#> $ B_pit                        <dbl> 0.3146440, 0.2973149, 0.2603038, 0.210670…
#> $ U_pit                        <dbl> 1.024331e-01, 6.284547e-02, 3.320261e-17,…
#> $ D_pit                        <dbl> 1.024331e-01, 6.284547e-02, -6.834810e-18…
#> $ P_misclass                   <dbl> NA, NA, NA, NA, NA
```
