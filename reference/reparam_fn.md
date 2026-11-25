# Get a converter that maps an unusual parametrisation to a canonical one.

Get a converter that maps an unusual parametrisation to a canonical one.

## Usage

``` r
reparam_fn(dist_name)
```

## Arguments

- dist_name:

  the distribution family as a string, e.g. `lnorm4`

## Value

a function that takes 2 parameters of the original distrbition and
returns a list with the parameters and name of the canonical
distribution.

## Examples

``` r
tmp_fn = reparam_fn("lnorm2")
tmp_fn(mean = 1, sd = 2)
#> $dist
#> [1] "lnorm"
#> 
#> $meanlog
#> [1] -0.804719
#> 
#> $sdlog
#> [1] 1.268636
#> 
```
