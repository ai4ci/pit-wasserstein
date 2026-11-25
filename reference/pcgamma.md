# Cumulative probability: gamma distribution constrained to have mean \> sd

The following conversion describes the parameters mean and kappa

## Usage

``` r
pcgamma(q, median, kappa = 1/median, lower.tail = TRUE, log.p = FALSE)
```

## Arguments

- q:

  vector of quantiles

- median:

  the median value on the true scale (vectorised)

- kappa:

  a coefficient of variation (sd/mean). where 0 is no variability.

- lower.tail:

  logical; if TRUE (default), probabilities are `P[X<=x]` otherwise
  `P[X>x]`.

- log.p:

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

## Details

\$\$ \text{shape:} \alpha = \frac{1}{\kappa} \\ \text{rate:} \beta =
\frac{1}{\mu \times \kappa} \\ \text{scale:} \sigma = \mu \times \kappa
\\ \$\$

## See also

[`stats::pgamma()`](https://rdrr.io/r/stats/GammaDist.html)

## Examples

``` r
pcgamma(seq(0, 4, 0.25), 2, 0.5)
#>  [1] 0.000000000 0.001284828 0.014367425 0.051168021 0.114566332 0.199644891
#>  [7] 0.297856598 0.400384907 0.500000000 0.591708114 0.672672631 0.741796608
#> [13] 0.799216025 0.845835931 0.882963317 0.912045554 0.934501515
```
