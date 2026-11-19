---
class: task
id: qgamma4-not-the-inverse-of-pgamma4.md
title: qgamma4 reparametrises with kappa/median and is not the inverse of pgamma4
status: done
kind: issue
priority: high
touches:
- src:import-standalone-distributions.R
---
Found 2026-11-18 while writing `vignette:model-misspecification.Rmd`.
**Pre-existing, not introduced by that work; not fixed.**

`qgamma4()` reparametrises with `kappa / median` where every other function in
the `gamma4` family uses `kappa` directly:

```r
# src:import-standalone-distributions.R, qgamma4()
params = .reparam.gamma4(median, kappa / median)   # <- divided

# dgamma4(), pgamma4()
params = .reparam.gamma4(median, kappa)            # <- not divided
```

`qgamma4()` also defaults `kappa = 1` where `dgamma4()`/`pgamma4()` default it
to `1 / median`, which is the same inconsistency showing up a second time.

## Consequence

`qgamma4()` is not the inverse of `pgamma4()`:

```r
pgamma4(qgamma4(0.9, median = 2, kappa = 0.5), median = 2, kappa = 0.5)
#> 0.734     # should be 0.9
```

The median is unaffected — `.reparam.gamma4()` solves the rate to hit the
requested median whatever the shape — so `qgamma4(0.5, ...)` is correct and
the defect is invisible in any check that only looks at the centre. Every
other quantile is wrong, and the error grows with the distance of `median`
from 1:

| `median` | `qgamma4(0.9, m, 0.5)` | `pgamma4()` of it |
|---|---|---|
| 0.5 | 1.661 | 0.998 |
| 2 | 2.718 | 0.734 |
| 8 | 8.658 | 0.561 |

It can also produce `NaN` outright: for `kappa = 1.2` and a `median` below
about 0.03, `kappa / median` gives a shape small enough that `stats::qgamma()`
fails.

A round-trip check over the other families shows `gamma4` is the only one
affected — `lnorm4`, `norm4`, `cgamma` and `gamma2` all satisfy
`p(q(0.9)) == 0.9`. (`lnorm2` errors on the same check, but for an unrelated
signature reason that is not part of this issue.)

## Why it matters here

`pit_w()` and `prediction_scores()` call both `cdf` and `inv_cdf` for the
named distribution — the CDF for the PIT values and the quantile function for
the predictive medians used by the bias adjustment, and for the interval
widths and coverage columns. With `dist = "gamma4"` those two disagree, so the
bias adjustment is computed against wrong medians and the coverage statistics
are wrong. Results reported for `gamma4` cannot be trusted until this is
fixed.

`vignette:model-misspecification.Rmd` guards against this: it drops `NaN`
cells and flags every `gamma4`-reported result as indicative.

## Suggested fix

```r
params = .reparam.gamma4(median, kappa)
```

and align the default to `kappa = 1 / median` to match `dgamma4()`/`pgamma4()`.
Then add a round-trip unit test for every `*4` family:

```r
testthat::expect_equal(pgamma4(qgamma4(0.9, 2, 0.5), 2, 0.5), 0.9)
```

The absence of such a test is why this survived; the existing `@unit` block
for `calibrated_locations()` exercises `qgamma4` only through a construction
that cancels the error out.

---

## Fixed (2026-11-18)

Fixed by the user in `src:import-standalone-distributions.R`, with tests added.
All three four-parameter families now round-trip:

```r
pgamma4(qgamma4(0.9, 2, 0.5), 2, 0.5)   #> 0.9
plnorm4(qlnorm4(0.9, 2, 0.5), 2, 0.5)   #> 0.9
pnorm4( qnorm4( 0.9, 2, 0.5), 2, 0.5)   #> 0.9
```

including at the small-median, large-`kappa` corner that previously returned
`NaN` (`pgamma4(qgamma4(0.1, 0.03, 1.2), 0.03, 1.2)` is now `0.1`).

The workaround in `vignette:model-misspecification.Rmd` has been removed: the
`suppressWarnings()`, the `drop_na()`/`na.rm` guards, the dropped-cell report
and the caveat flagging `gamma4` results as indicative are all gone. The
round-trip check survives as a positive confirmation rather than a warning,
and all `gamma4` numbers in that vignette are now exact.
