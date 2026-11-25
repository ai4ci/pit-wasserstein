# A tidy article theme for huxtables

The main aim is to get something that works with google docs when you
copy and paste.

## Usage

``` r
.hux_default_layout(
  hux,
  defaultFontSize = 8,
  defaultFont = "Roboto",
  headerRows = 1
)
```

## Arguments

- hux:

  a huxtable object

- defaultFontSize:

  default size of font in points (8) (default `` `8` `` \[numeric\])

- defaultFont:

  the font family name (default `` `Roboto` `` \[character\])

- headerRows:

  the number of rows that are headers (default `` `1` `` \[numeric\])

## Value

the formatted huxtable.

## Unit tests



    hux = iris %>% .hux_default_layout()
