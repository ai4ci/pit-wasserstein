# Significance test for the bias-adjusted undirected PIT-Wasserstein metric

Tests the weakest of the three null hypotheses in the PIT-Wasserstein
family: that the predictive distributions have the **right shape given
an arbitrary location error**. The bias adjustment absorbs any common
shift, so a rejection here means the shape of the predictive
distribution is wrong — skew, tail weight, or a mixture of dispersion
errors — and not that the forecasts are merely off-centre. One-sided, as
`U_pit` is a distance.

## Usage

``` r
u_pit_significance(U_pit, n_predictions)
```

## Arguments

- U_pit:

  the bias-adjusted undirected PIT-Wasserstein metric, as returned by
  [`pit_w()`](https://ai4ci.github.io/pit-wasserstein/reference/pit_w.md)
  or
  [`prediction_scores()`](https://ai4ci.github.io/pit-wasserstein/reference/prediction_scores.md)

- n_predictions:

  the number of predictions each `U_pit` was computed from, as returned
  by
  [`prediction_scores()`](https://ai4ci.github.io/pit-wasserstein/reference/prediction_scores.md)

## Value

a dataframe with one row per input value and columns:

- `U_pit`, `n_predictions` — as supplied

- `statistic` — \\\sqrt{n}\\U\_{pit}\\, the quantity with a fixed null

- `expected` — the null mean of `U_pit`

- `critical_0.05` — the one-sided 5% critical value of `U_pit`

- `p_value` — the probability of a `U_pit` at least this large under the
  location-free null

## Details

Because the adjustment estimates a parameter from the same data, the
null is **not** the baseline \\\int_0^1\|B^\circ\|\\ of
[`b_pit_significance()`](https://ai4ci.github.io/pit-wasserstein/reference/b_pit_significance.md):
it is the bridge with the estimated direction projected out (see
`.u_pit_null`), giving a 5% critical value about `0.66` times the
baseline one at every `n`. Using the baseline null here would be badly
conservative. The adjusted null is still distribution-free — it depends
on `n` and nothing else — but has no published c.d.f., so it is
simulated once per session and cached.

`U_pit` says nothing about the *direction* of a dispersion error; pair
it with
[`d_pit_significance()`](https://ai4ci.github.io/pit-wasserstein/reference/d_pit_significance.md),
which does.

## Unit tests



    # the adjusted null is strictly tighter than the baseline one
    testthat::expect_lt(
      u_pit_significance(0, 100)$critical_0.05,
      b_pit_significance(0, 100)$critical_0.05
    )

    # the critical value scales as 1/sqrt(n)
    testthat::expect_equal(
      u_pit_significance(0, 400)$critical_0.05 * 2,
      u_pit_significance(0, 100)$critical_0.05,
      tolerance = 1e-6
    )

    # a statistic at the null mean is not significant
    testthat::expect_gt(u_pit_significance(u_pit_significance(0, 100)$expected, 100)$p_value, 0.3)

    # the 5% critical value returns a p value of about 0.05
    crit = u_pit_significance(0, 100)$critical_0.05
    testthat::expect_equal(u_pit_significance(crit, 100)$p_value, 0.05, tolerance = 0.005)

    # vectorised over both arguments
    testthat::expect_equal(nrow(u_pit_significance(c(0.02, 0.09), c(76, 76))), 2L)
