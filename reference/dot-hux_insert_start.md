# Insert row at start maintaining format

Insert row at start maintaining format

## Usage

``` r
.hux_insert_start(hux, ..., fill = "", colspan = 1)
```

## Arguments

- hux:

  a huxtable

- ...:

  stuff to insert into cells

- fill:

  padding for empty cells. (default ``` `` ``` \[character\])

- colspan:

  how far to span first inserted cell? (default `` `1` `` \[numeric\])

## Value

a huxtable with row inserted at start in the same format
