# Sampling: gamma distribution constrained to have median \> sd

Density, distribution function, quantile function and random generation
for the Gamma distribution with parameters `shape` and `scale`.

## Usage

``` r
rcgamma(n, median, kappa = 1/median)
```

## Arguments

- n:

  number of observations

- median:

  the median value on the true scale (vectorised)

- kappa:

  a coefficient of variation (sd/mean). where 0 is no variability.

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

[`stats::rgamma()`](https://rdrr.io/r/stats/GammaDist.html)

## Examples

``` r
rcgamma(10, 2, 0.5)
#>  [1] 1.4579142 2.0142742 1.7935787 0.7571468 1.6451190 0.7045221 4.3477662
#>  [8] 2.6952499 0.7436123 2.8849468
```
