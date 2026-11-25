# Calculate a pit-wasserstein value for a single estimator

An estimator produces multiple parametrised probability distributions,
from which we can calculate scores such as CPRS and PIT-W

## Usage

``` r
pit_w(
  true_value,
  location,
  scale,
  dist = "norm",
  link = "identity",
  adjust = c("link", "probit")
)
```

## Arguments

- true_value:

  The true value

- location:

  The central estimate of the probabilistic prediction

- scale:

  The spread estimate of the probabilisitic prediction

- dist:

  The distribution name of the prediction (default `` `norm` ``
  \[character\])

- link:

  A link function mapping the value space to a linear one, e.g.
  "identity", "log" (default `` `identity` `` \[character\])

- adjust:

  adjustment method for constructing the pit value (default
  `` `link ` ``; allowed: `` `link `,`probit` ``)

## Value

a one row data frame with:

- `U_pit` an undirected pit-wasserstein

- `D_pit` a directed pit-wasserstein

- `B_pit` raw unadjusted undrected pit-wasserstein

## Unit tests




    scores = pit_w(0, qnorm(seq(1,199,2)/200, 0, 1), 1, dist = "norm", link="identity")
    testthat::expect_equal(scores$U_pit, 0)

    scores = pit_w(1, calibrated_locations(qlnorm4, 1, 1), 1, dist = "lnorm4", link="log")
    testthat::expect_equal(scores$U_pit, 0)

    scores = pit_w(1, calibrated_locations(qlnorm4, 1, 1), 1, dist = "lnorm4", link="log")
    testthat::expect_equal(scores$U_pit, 0)

    scores = pit_w(1, calibrated_locations(qgamma4, 1, 0.5), 0.5, dist = "gamma4", link="log")
    testthat::expect_equal(scores$U_pit, 0, tolerance = 10^-5)
