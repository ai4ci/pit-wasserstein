# Set sizes in ggplot uniformly

Set the default sizes of lines, points and fonts in ggplot geoms, and
text labels in ggplot axes to get a single consistent look and feel.

## Usage

``` r
.gg_set_size_defaults(
  lineSize = 0.5,
  fontSizePts = 4 + lineSize * 8,
  font = "Roboto",
  size = lineSize * 2
)
```

## Arguments

- lineSize:

  the width of lines (default `` `0.5` `` \[numeric\])

- fontSizePts:

  the size of labels and other on plot text in pts. (default
  `` `4 + lineSize * 8` ``)

- font:

  the font family name (default `` `Roboto` `` \[character\])

- size:

  the size of points (the default size aesthetic) (default
  `` `lineSize * 2` ``)

## Value

nothing

## Unit tests



    .gg_set_size_defaults(lineSize = 0.25)
