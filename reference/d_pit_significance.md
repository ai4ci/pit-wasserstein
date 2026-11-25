# Significance test for the directed PIT-Wasserstein metric

Tests the null hypothesis that the predictions are calibrated. `D_pit`
is signed, so unlike
[`u_pit_significance()`](https://ai4ci.github.io/pit-wasserstein/reference/u_pit_significance.md)
this test reports a direction: positive values indicate
**overconfidence** (predictive distributions too narrow) and negative
values **underconfidence** (too wide).

## Usage

``` r
d_pit_significance(
  D_pit,
  n_predictions,
  alternative = c("two.sided", "overconfident", "underconfident")
)
```

## Arguments

- D_pit:

  the directed PIT-Wasserstein metric, as returned by
  [`pit_w()`](https://ai4ci.github.io/pit-wasserstein/reference/pit_w.md)
  or
  [`prediction_scores()`](https://ai4ci.github.io/pit-wasserstein/reference/prediction_scores.md)

- n_predictions:

  the number of predictions each `D_pit` was computed from, as returned
  by
  [`prediction_scores()`](https://ai4ci.github.io/pit-wasserstein/reference/prediction_scores.md)

- alternative:

  one of `"two.sided"` (any dispersion miscalibration),
  `"overconfident"` (positive `D_pit` only) or `"underconfident"`
  (negative `D_pit` only) (default `` `two.sided ` ``; allowed:
  `` `two.sided `,`overconfident `,`underconfident` ``)

## Value

a dataframe with one row per input value and columns:

- `D_pit`, `n_predictions` — as supplied

- `statistic` — the z score, \\D^\*\_{pit}\sqrt{48n}\\

- `se` — the asymptotic standard error, \\1/\sqrt{48n}\\

- `critical_0.05` — the magnitude of `D_pit` rejected at 5%

- `direction` — `"overconfident"`, `"underconfident"` or `"calibrated"`

- `p_value` — computed against `alternative`

## Details

The test uses a Gaussian reference with mean zero and variance
\\1/(48n)\\ at sample size \\n\\. This follows from the limiting
Brownian bridge for independent uniform PIT values when the estimated
location shift cancels to first order, as in the common-scale Gaussian
location model with median adjustment. The p-values and critical values
are large-sample approximations.

In the vignette simulations, the nominal 5% test rejects about 8% of the
time at `n = 10`, 6% at `n = 25`, and 5.5% at `n = 50`.

## Unit tests



    # a z score of 1.96 is a two sided p of 0.05
    res = d_pit_significance(qnorm(0.975) / sqrt(48 * 100), 100)
    testthat::expect_equal(res$statistic, qnorm(0.975))
    testthat::expect_equal(res$p_value, 0.05)
    testthat::expect_equal(res$direction, "overconfident")

    # the one sided test is half the two sided test in the expected direction
    testthat::expect_equal(
      d_pit_significance(0.01, 100, "overconfident")$p_value,
      d_pit_significance(0.01, 100)$p_value / 2
    )

    # and is not fooled by a deviation in the other direction
    testthat::expect_true(d_pit_significance(-0.03, 100, "overconfident")$p_value > 0.95)

    # exactly calibrated
    testthat::expect_equal(d_pit_significance(0, 100)$p_value, 1)
    testthat::expect_equal(d_pit_significance(0, 100)$direction, "calibrated")
