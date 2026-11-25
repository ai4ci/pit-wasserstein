# The Gamma Distribution

Density, distribution function, quantile function and random generation
for the Gamma distribution with parameters `shape` and `scale`.

## Usage

``` r
rgamma2(n, mean, sd = sqrt(mean))
```

## Arguments

- n:

  number of observations

- mean:

  the mean value on the true scale (vectorised)

- sd:

  the standard deviation on the true scale (vectorised)

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
rgamma2(10, 2, 1)
#>  [1] 4.5122750 0.7622801 3.1430014 1.9125340 1.0761388 1.6252616 2.5901717
#>  [8] 2.4897070 2.5802684 0.9316853
```
