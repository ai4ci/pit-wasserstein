# Convert a single pdf to multiple pngs one per page

Convert a single pdf to multiple pngs one per page

## Usage

``` r
.convert_pdf_to_pngs(pdfFile)
```

## Arguments

- pdfFile:

  an input pdf file

## Value

a list of png files one per page.

## Unit tests



    testthat::skip_on_cran()
    hux = iris %>% huxtable::as_hux() %>% huxtable::theme_mondrian(font="Arial")
    html = hux %>% huxtable::to_html()
    tmp = .print_html_with_chrome(html,maxWidth = std_size$A4$width,maxHeight = std_size$A4$height)
    pngs = .convert_pdf_to_pngs(tmp)
