# A space saving ggplot theme

A ggplot theme with minimal fluff and with the defaults set small.

## Usage

``` r
.gg_tiny_theme(baseSize = 8, font = "Roboto")
```

## Arguments

- baseSize:

  the size of the base font. (default `` `8` `` \[numeric\])

- font:

  the font family name (default `` `Roboto` `` \[character\])

## Value

a ggplot theme

## Unit tests



    ggplot2::ggplot(ggplot2::diamonds,
      ggplot2::aes(x=carat,y=price,color=color))+
      ggplot2::geom_point()+
      .gg_tiny_theme()
