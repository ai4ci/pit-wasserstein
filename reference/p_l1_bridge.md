# Distribution of the L1 norm of the Brownian bridge

The limiting null distribution of \\\sqrt{n}\\U^\*\_{pit}\\. For a
standard Brownian bridge \\B\\, Johnson & Killeen (1983) give the c.d.f.
of \\L = \int_0^1 \|B(t)\|\\\mathrm{d}t\\ as the convergent series

## Usage

``` r
p_l1_bridge(q, terms = 30L)

q_l1_bridge(p, terms = 30L)
```

## Arguments

- q:

  a vector of quantiles (non-negative)

- terms:

  number of terms of the series to sum (default `` `30` `` \[integer\])

- p:

  a vector of probabilities

## Value

`p_l1_bridge()` returns the c.d.f. evaluated at `q`; `q_l1_bridge()`
returns the quantile function evaluated at `p`

## Details

\$\$P(L \le \ell) = \sqrt{\pi/2} \sum\_{j=1}^{\infty} \delta_j^{-3/2}
\psi(\ell / \delta_j^{3/2})\$\$

with \\\psi(t) = 3^{2/3} t^{-1/3} e^{-2/(27 t^2)} Ai((3t)^{-4/3})\\ and
\\\delta_j = \|a'\_j\| / 2^{1/3}\\, where \\a'\_j\\ is the \\j\\th zero
of \\Ai'\\. Terms are suppressed by \\e^{-2/(27t^2)}\\ with \\t =
q/\delta_j^{3/2}\\, so the number of terms needed grows with `q`. The
default is ample over the whole range where the upper tail is
numerically distinguishable from zero; beyond `q = 10` the c.d.f. is
returned as exactly 1.

## Unit tests



    # the mean of the L1 norm of the bridge is known exactly to be sqrt(2 pi)/8
    m = integrate(function(x) 1 - p_l1_bridge(x), 0, 5, subdivisions = 500L)$value
    testthat::expect_equal(m, sqrt(2 * pi) / 8, tolerance = 1e-5)

    # a proper distribution function
    testthat::expect_equal(p_l1_bridge(0), 0)
    testthat::expect_equal(p_l1_bridge(10), 1)
    testthat::expect_true(all(diff(p_l1_bridge(seq(0.05, 1, 0.05))) > 0))

    # and its inverse
    testthat::expect_equal(p_l1_bridge(q_l1_bridge(0.95)), 0.95, tolerance = 1e-6)
