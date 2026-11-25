# The Log-Normal Distribution

Density, distribution function, quantile function and random generation
for the log-normal distribution whose logarithm has mean equal to
`meanlog` and standard deviation equal to `sdlog`.

## Usage

``` r
rlnorm2(n, mean = 1, sd = sqrt(exp(1) - 1))
```

## Source

`dlnorm` is calculated from the definition (in ‘Details’). `[pqr]lnorm`
are based on the relationship to the normal.

Consequently, they model a single point mass at `exp(meanlog)` for the
boundary case `sdlog = 0`.

## Arguments

- n:

  number of observations. If `length(n) > 1`, the length is taken to be
  the number required.

- mean:

  the mean value on the true scale (vectorised)

- sd:

  the standard deviation on the true scale (vectorised)

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
rlnorm2(10, 2, 1)
#>  [1] 1.6196681 1.8766942 1.8108340 1.7634985 2.6187000 2.5559880 0.9237888
#>  [8] 3.0957796 1.1469043 0.7678374
```
