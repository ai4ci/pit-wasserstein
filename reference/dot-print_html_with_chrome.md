# Print a HTML fragment using chrome

Print a HTML fragment using chrome

## Usage

``` r
.print_html_with_chrome(
  htmlFragment,
  pdfFile = tempfile(fileext = ".pdf"),
  css = list(),
  chromeBinary = getOption("ggrrr.chrome", default = .find_chrome()),
  maxWidth = NULL,
  maxHeight = NULL
)
```

## Arguments

- htmlFragment:

  an HTML fragment

- pdfFile:

  the pdf file (default `` `tempfile(fileext = ".pdf")` ``
  \[character\])

- css:

  a list of valid css style specifications (not urls to stylesheets)
  (default `` `list()` `` \[list\])

- chromeBinary:

  the chrome browser (or chromium) path (default
  `` `getOption("ggrrr.chrome", default = .find_chrome())` ``
  \[character\])

- maxWidth:

  the maximum width of the output in inches (default `` `NULL` ``
  \[NULL\])

- maxHeight:

  the maximum height of the output in inches (default `` `NULL` ``
  \[NULL\])

## Value

the pdf path

## Unit tests




    testthat::skip_on_cran()

    tryCatch(.find_chrome(), error = function(e) testthat::skip())

    hux = iris %>% huxtable::as_hux() %>% huxtable::theme_mondrian(font="Roboto")
    html = hux %>% huxtable::to_html()

    testthat::expect_no_error({
      tmp = .print_html_with_chrome(html,maxWidth = 5,maxHeight = std_size$A4$height)
    })

    # browseURL(tmp)
    # exact binary copy may depend on versions of chrome etc:
    # The resulting pdf has fonts embedded & is multipage.
