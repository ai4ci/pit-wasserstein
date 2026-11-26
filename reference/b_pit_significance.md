# Significance test for the baseline PIT-Wasserstein metric

Tests the strongest of the three null hypotheses in the PIT-Wasserstein
family: that the predictions are **fully probabilistically calibrated**,
so that the raw PIT values are i.i.d. \\U(0,1)\\ — correct location
*and* correct dispersion *and* correct shape. The test is one-sided:
`B_pit` is a distance, so only large values are evidence against
calibration.

## Usage

``` r
b_pit_significance(B_pit, n_predictions)
```

## Arguments

- B_pit:

  the baseline (unadjusted) PIT-Wasserstein metric, reported as `B_pit`
  by
  [`pit_w()`](https://ai4ci.github.io/pit-wasserstein/reference/pit_w.md)
  and
  [`prediction_scores()`](https://ai4ci.github.io/pit-wasserstein/reference/prediction_scores.md)

- n_predictions:

  the number of predictions each `B_pit` was computed from, as returned
  by
  [`prediction_scores()`](https://ai4ci.github.io/pit-wasserstein/reference/prediction_scores.md)

## Value

a dataframe with one row per input value and columns:

- `B_pit`, `n_predictions` — as supplied

- `statistic` — \\\sqrt{n}\\B\_{pit}\\, the quantity with a fixed null

- `expected` — the null mean of `B_pit`, \\\sqrt{2\pi}/(8\sqrt{n})\\

- `critical_0.05` — the one-sided 5% critical value of `B_pit`

- `p_value` — the probability of a `B_pit` at least this large under
  full probabilistic calibration

## Details

Under that null \\\sqrt{n}\\B\_{pit}\\ converges to
\\\int_0^1\|B^\circ\|\\, the integrated absolute Brownian bridge, whose
c.d.f. is
[`p_l1_bridge()`](https://ai4ci.github.io/pit-wasserstein/reference/p_l1_bridge.md).
Nothing is estimated from the data, so the null is exact and fully
analytical.

`B_pit` rejects when *anything* is wrong and says nothing about what.
Use it as the omnibus first stage, then
[`d_pit_significance()`](https://ai4ci.github.io/pit-wasserstein/reference/d_pit_significance.md)
to test dispersion free of any location error, and
[`u_pit_significance()`](https://ai4ci.github.io/pit-wasserstein/reference/u_pit_significance.md)
for the residual shape.

## Unit tests



    # a calibrated forecaster sits near the null mean and is not significant
    res = b_pit_significance(sqrt(2 * pi) / 8 / sqrt(100), 100)
    testthat::expect_true(res$p_value > 0.3)

    # the 5% critical value has, by construction, a p value of 0.05
    crit = b_pit_significance(0, 100)$critical_0.05
    testthat::expect_equal(b_pit_significance(crit, 100)$p_value, 0.05, tolerance = 1e-5)

    # the critical value scales as 1/sqrt(n)
    testthat::expect_equal(
      b_pit_significance(0, 400)$critical_0.05 * 2,
      b_pit_significance(0, 100)$critical_0.05,
      tolerance = 1e-6
    )

    # and is strictly larger than the adjusted test's, which has estimated a
    # location parameter from the same data
    testthat::expect_true(
      b_pit_significance(0, 100)$critical_0.05 > u_pit_significance(0, 100)$critical_0.05
    )

    # vectorised over both arguments
    testthat::expect_equal(nrow(b_pit_significance(c(0.02, 0.09), c(76, 76))), 2L)
