# Uniform predictions for testing

Predictions whose PIT values are exactly uniform, for a scale family
(gamma4, lnorm4, ...) where `location` is the median.

## Usage

``` r
calibrated_locations(qfn, median, kappa, n = 100)
```

## Arguments

- qfn:

  a quantile function parametrised by median and something else

- median:

  the median

- kappa:

  a spread parameter, typically dispersion (sigma/mu)

- n:

  the number of samples (default `` `100` `` \[numeric\])

## Value

a set of locations for a distribution family that map directly to
uniform PIT values.

## Examples

``` r
loc = calibrated_locations(qfn = qgamma4, median = 1, kappa = 0.5)
pit_w(1, loc, 0.5, dist = "gamma4", link = "log")$B_pit # ~1e-17
#> [1] 6.716849e-17
```
