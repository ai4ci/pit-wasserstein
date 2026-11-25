# Uniform predictions for testing (general)

For a general (non-scale) family, solve it numerically instead:

## Usage

``` r
calibrated_locations_general(
  pfn,
  median,
  kappa,
  n = 100,
  interval = c(1e-08, 1e+08)
)
```

## Arguments

- pfn:

  a CDF parametrised by mean and the spread parameter

- median:

  the median

- kappa:

  a spread parameter, typically dispersion (sigma/mu)

- n:

  the number of samples (default `` `100` `` \[numeric\])

- interval:

  uniroot limits (default `` `c(1e-08, 1e+08)` `` \[numeric\])

## Value

a set of locations for a distribution family that map directly to
uniform PIT values.
