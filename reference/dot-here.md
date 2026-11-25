# Drop in replacement for `here` (`here` pkg)

Drop in replacement for `here` (`here` pkg)

## Usage

``` r
.here(..., projRoot = .locate_project())
```

## Arguments

- ...:

  the relative path within the project

- projRoot:

  the project root - defaults to
  [`.locate_project()`](https://ai4ci.github.io/pit-wasserstein/reference/dot-locate_project.md)
  (default `` `.locate_project()` `` \[character\])

## Value

a path

## Unit tests



    .here("vignettes")
