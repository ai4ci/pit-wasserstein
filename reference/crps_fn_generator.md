# Generate a CRPS calculating function based on a parametrised distribution name

`scoringRules` has implementations of common functions but not so much
for re-parametrisations. This detects if a re-parametrisation is
available for a distribution name and remaps the input to a more common
distribution that `scoringRules` has support for.

## Usage

``` r
crps_fn_generator(dist_name)
```

## Arguments

- dist_name:

  the name of the distribution, e.g. `norm`, `lnorm4`

## Value

a function which takes 3 parameters: true_value, location, and scale and
returns a CRPS for them.

## Unit tests



    fn=crps_fn_generator("lnorm4")
    mapped = fn(1:5,1,2)
    tmp = .reparam.lnorm4(1,2)
    direct = scoringRules::crps(1:5, tmp$dist, meanlog = tmp$meanlog, sdlog = tmp$sdlog)
    testthat::expect_equal(mapped, direct)
