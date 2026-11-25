# The Beta Distribution

Density, distribution function, quantile function and random generation
for the Beta distribution with parameters `shape1` and `shape2` (and
optional non-centrality parameter `ncp`).

## Usage

``` r
rbeta2(n, prob, kappa)
```

## Arguments

- n:

  number of observations

- prob:

  the mean probability (vectorised)

- kappa:

  a coefficient of variation (sd/mean). where 0 is no variability.

## Value

`dbeta` gives the density, `pbeta` is the cumulative distribution
function, and `qbeta` is the quantile function of the Beta distribution.
`rbeta` generates random deviates.

Invalid arguments will result in return value `NaN`, with a warning.

The length of the result is determined by `n` for `rbeta`, and is the
maximum of the lengths of the numerical arguments for the other
functions.

The numerical arguments other than `n` are recycled to the length of the
result. Only the first elements of the logical arguments are used.

## See also

[`stats::rbeta()`](https://rdrr.io/r/stats/Beta.html)

## Examples

``` r
rbeta2(3, c(0.1, 0.5, 0.9), 0.1)
#> [1] 0.1071844 0.5484614 0.8936490
```
