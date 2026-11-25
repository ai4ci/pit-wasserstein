# Generate an set of scenarios for testing scoring

Scenarios are based on an estimator producing predictions as
parametrised distributions, and the estimator can be characterised in
terms of the bias and sharpness distributions that govern predictions.
Predictions are then expressed as samples from these bias and sharpness
distributions and the associated distribution function (which will be
parameterised with `mean = bias` and `sd = sharpness`)

## Usage

``` r
generate_simulation(config = i_sim_config, true_value_fn = NULL)
```

## Arguments

- config:

  the simulation configuration - a dataframe with columns:

  - samples (integer) - The number of estimators simulated

  - link (character + default("identity")) - a transformation that puts
    the quantity being estimated on a linear scale

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

- true_value_fn:

  a function that generates the true values e.g. a random sampler
  (default `` `NULL` `` \[NULL\])

## Value

a

## Examples

``` r
config = dplyr::tibble(samples = 100)
config %>% generate_simulation()
#> interfacer: development mode active (test environment).
#> This message is displayed once every 8 hours.
#> Warning: unexpected groups in the return value of generate_simulation(...):
#> observed: samples+link+dist+bias_dist+bias_location+bias_scale+sharpness_dist+sharpness_location+sharpness_scale+run_id+calibration+adjust
#> expected: <any>+dist+link+calibration+adjust
#> Warning: ireturn validation did not pass without changing the value. 
#> # A tibble: 100 × 16
#> # Groups:   samples, bias_dist, bias_location, bias_scale, sharpness_dist,
#> #   sharpness_location, sharpness_scale, run_id, dist, link, calibration,
#> #   adjust [1]
#>    samples link     dist  bias_dist bias_location bias_scale sharpness_dist
#>  *   <int> <chr>    <chr> <chr>             <dbl>      <dbl> <chr>         
#>  1     100 identity norm  norm                  0          1 lnorm4        
#>  2     100 identity norm  norm                  0          1 lnorm4        
#>  3     100 identity norm  norm                  0          1 lnorm4        
#>  4     100 identity norm  norm                  0          1 lnorm4        
#>  5     100 identity norm  norm                  0          1 lnorm4        
#>  6     100 identity norm  norm                  0          1 lnorm4        
#>  7     100 identity norm  norm                  0          1 lnorm4        
#>  8     100 identity norm  norm                  0          1 lnorm4        
#>  9     100 identity norm  norm                  0          1 lnorm4        
#> 10     100 identity norm  norm                  0          1 lnorm4        
#> # ℹ 90 more rows
#> # ℹ 9 more variables: sharpness_location <dbl>, sharpness_scale <dbl>,
#> #   run_id <int>, calibration <dbl>, estimate_id <int>, true_value <dbl>,
#> #   location <dbl>, scale <dbl>, adjust <chr>
```
