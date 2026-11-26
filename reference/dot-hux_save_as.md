# Save a table to a variety of formats

depending on the context return the correct format for a document. The
basic output here is to use HTML as an output if possible and convert it
to an image or a PDF that can then be included into a latex document for
example.

## Usage

``` r
.hux_save_as(
  hux,
  filename,
  size = std_size$full,
  maxWidth = size$width,
  maxHeight = size$height,
  aspectRatio = maxWidth/maxHeight,
  formats = c("html", "docx"),
  defaultFontSize = 8,
  sheetname = fs::path_ext_remove(fs::path_file(filename)),
  pdfConverter = .print_html_with_chrome,
  webfontFinder = ~return(list())
)
```

## Arguments

- hux:

  the huxtable to save

- filename:

  the filename, which may omit the extension

- size:

  a `std_size` list entry (default `` `std_size$full` `` \[list\])

- maxWidth:

  or the maximum width in inches (default `` `size$width` ``)

- maxHeight:

  and either the maximum height in inches (default `` `size$height` ``)

- aspectRatio:

  or the minimum allowed aspect ratio (default
  `` `maxWidth/maxHeight` ``)

- formats:

  if the extension is omitted, all the formats described here will be
  saved. Currently supported outputs are
  "html","png","pdf","docx","xlsx" (default `` `c("html", "docx")` ``
  \[character\])

- defaultFontSize:

  the default font size (default `` `8` `` \[numeric\])

- sheetname:

  if saving as an xlsx file. (default
  `` `fs::path_ext_remove(fs::path_file(filename))` ``)

- pdfConverter:

  a function that takes an HTML fragment and returns a pdf file.
  (default `` `.print_html_with_chrome` `` \[function\])

- webfontFinder:

  a function that takes a set of font families and returns a css
  webfonts directive (default `` `~return(list())` `` \[formula\])

## Value

the output depends on if the function is called in a knitr session. It
maybe the HTML or a link to the pdf output for example.

## Unit tests




    testthat::skip_on_cran()

    hux = iris %>% huxtable::as_hux() %>%
      huxtable::theme_mondrian(font="Roboto")
    out = .hux_save_as(hux, tempfile())
    # browseURL(out$html)

    out2 = .hux_save_as(hux, tempfile(), formats=c("pdf","png"))
    as.character(out2)
    # The resulting pdf has fonts embedded & is multipage.
