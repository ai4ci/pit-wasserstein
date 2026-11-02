---
class: issue
title: "The vendored dist_fns class is incomplete and cannot carry the metrics"
status: open
severity: minor
ownership: preExisting
raised: 2026-11-02
tags: [metrics, vendoring]
---

# Symptom

`R/s3-dist_fns-class.R` (1264 lines, byte-identical to upstream
`ai4ci/tidyabc`) and `R/import-standalone-distributions.R` were added with the
intention of using `dist_fns` objects as the handle for the predictive family
in `pit_w()`. They cannot be used that way, and are not usable at all as
vendored:

1. `.Rprofile` never sources `R/import-standalone-distributions.R`, so `pnull`,
   `qnull`, `dnull`, `rlnorm2` etc. are undefined and `new_dist_fns()` on its
   defaults fails with `object 'qnull' not found`.
2. Two helpers the class needs live in tidyabc files that were **not** vendored:
   `.make_square` (`tidyabc/R/import-standalone-recycle.R:155`, used at
   `R/s3-dist_fns-class.R:69` and `:204`) and `.qual`
   (`tidyabc/R/utils-crate.R:561`, used at `R/s3-dist_fns-class.R:170`). So
   vectorised-parameter construction and `as.dist_fns()` both fail.
3. Even when built by hand —
   `new_dist_fns("norm", pfn = pnorm, qfn = qnorm, rfn = rnorm, dfn = dnorm, mean = 0, sd = 1)`
   — the parameters are frozen at construction inside the `carrier::crate`
   closures. A prediction set needs one $F_i$ per row, i.e. one `dist_fns` per
   prediction: measured at **2167 ms and 151 MB for 10,000** of them, versus
   **380 ms** for one whole-matrix `pnorm(x, mean, sd)`.
4. `dist_fns_list` has no vectorised call: `$p` returns a *list* of closures, so
   `L$p(x)` is `attempt to apply non-function`.

# Why it does not matter anyway

Vectorising the metric is not the bottleneck. Over a 1000 x 10000 grid,
map-per-scenario and fully-vectorised both take ~1.4 s — a **1.0x** ratio. The
row-wise `sort()` dominates, not the CDF evaluation.

# Decision

Decided 2026-11-02: the metrics take a plain vectorised `cdf` argument
(`pit_w(..., cdf = stats::pnorm)`) and the `dist_fns` class is not on the metric
path — see `adr:paper-is-primary-and-metrics-are-a-reference-implementation.md`.

# Suggested fix

Delete `R/s3-dist_fns-class.R` and `R/import-standalone-distributions.R`
(`R/import-standalone-mixture-distributions.R` is likewise unused — grep for its
exported samplers returns nothing in `analysis.R`). If the class is wanted later
for a different purpose, vendor the whole tidyabc dependency set
(`import-standalone-recycle.R`, `utils-crate.R`) rather than a subset, and
attach dplyr/tidyr/magrittr in `.Rprofile`, which currently does not.

Left open because the files were added deliberately and deleting them is the
author's call, not a drive-by cleanup.
