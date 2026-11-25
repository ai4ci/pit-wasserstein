# Density: gamma distribution constrained to have mean \> sd

Density, distribution function, quantile function and random generation
for the Gamma distribution with parameters `shape` and `scale`.

## Usage

``` r
dcgamma(x, median, kappa = 1/median, log = FALSE)
```

## Arguments

- x:

  vector of quantiles

- median:

  the median value on the true scale (vectorised)

- kappa:

  a coefficient of variation (sd/mean). where 0 is no variability.

- log:

  logical; if TRUE, probabilities p are given as log(p).

## Value

`dgamma` gives the density, `pgamma` is the cumulative distribution
function, and `qgamma` is the quantile function of the Gamma
distribution. `rgamma` generates random deviates.

Invalid arguments will result in return value `NaN`, with a warning.

The length of the result is determined by `n` for `rgamma`, and is the
maximum of the lengths of the numerical arguments for the other
functions.

The numerical arguments other than `n` are recycled to the length of the
result. Only the first elements of the logical arguments are used.

## See also

[`stats::dgamma()`](https://rdrr.io/r/stats/GammaDist.html)

## Examples

``` r
dcgamma(seq(0, 4, 0.25), 2, 0.5)
#>  [1] 0.00000000 0.01870009 0.09453427 0.20161303 0.30198845 0.37271418
#>  [7] 0.40698198 0.40838623 0.38521436 0.34658963 0.30043019 0.25268366
#> [13] 0.20729956 0.16654831 0.13144674 0.10216333 0.07834959
```
