# The Log-Normal Distribution

Density, distribution function, quantile function and random generation
for the log-normal distribution whose logarithm has mean equal to
`meanlog` and standard deviation equal to `sdlog`.

## Usage

``` r
plnorm4(q, median = 1, kappa = 1, lower.tail = TRUE, log.p = FALSE)
```

## Source

`dlnorm` is calculated from the definition (in ‘Details’). `[pqr]lnorm`
are based on the relationship to the normal.

Consequently, they model a single point mass at `exp(meanlog)` for the
boundary case `sdlog = 0`.

## Arguments

- q:

  vector of quantiles

- median:

  the median value on the true scale (vectorised)

- kappa:

  a coefficient of variation (sd/mean). where 0 is no variability.

- lower.tail:

  logical; if `TRUE` (default), probabilities are \\P\[X \le x\]\\,
  otherwise, \\P\[X \> x\]\\.

- log.p:

  logical; if TRUE, probabilities p are given as log(p).

## Value

`dlnorm` gives the density, `plnorm` is the cumulative distribution
function, and `qlnorm` is the quantile function of the log-normal
distribution. `rlnorm` generates random deviates.

The length of the result is determined by `n` for `rlnorm`, and is the
maximum of the lengths of the numerical arguments for the other
functions.

The numerical arguments other than `n` are recycled to the length of the
result. Only the first elements of the logical arguments are used.

## Details

The log-normal distribution has density \$\$ f(x) =
\frac{1}{\sqrt{2\pi}\sigma x} e^{-(\log(x) - \mu)^2/2 \sigma^2}% \$\$
where \\\mu\\ and \\\sigma\\ are the mean and standard deviation of the
logarithm. The mean is \\E(X) = exp(\mu + 1/2 \sigma^2)\\, the median is
\\med(X) = exp(\mu)\\, and the variance \\Var(X) = exp(2\mu +
\sigma^2)(exp(\sigma^2) - 1)\\ and hence the coefficient of variation is
\\\sqrt{exp(\sigma^2) - 1}\\ which is approximately \\\sigma\\ when that
is small (e.g., \\\sigma \< 1/2\\).

## Note

The cumulative hazard \\H(t) = - \log(1 - F(t))\\ is
`-plnorm(t, r, lower = FALSE, log = TRUE)`.

## References

Becker RA, Chambers JM, Wilks AR (1988). *The New S Language*. Chapman
and Hall/CRC, London. ISBN 053409192X.

Johnson NL, Kotz S, Balakrishnan N (1994). *Continuous Univariate
Distributions*, volume 1. Wiley, New York. ISBN 978-0-471-58495-7.  
Chapter 14.

## See also

[Distributions](https://rdrr.io/r/stats/Distributions.html) for other
standard distributions, including
[`dnorm`](https://rdrr.io/r/stats/Normal.html) for the normal
distribution.

## Examples

``` r
plnorm4(seq(0, 4, 0.25), 2, 1)
#>  [1] 0.000000000 0.006250734 0.047945484 0.119379169 0.202547983 0.286196101
#>  [7] 0.364843702 0.436287899 0.500000000 0.556251399 0.605659085 0.648955445
#> [13] 0.686875521 0.720105290 0.749261327 0.774886293 0.797452017
```
