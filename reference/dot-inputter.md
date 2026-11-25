# Find a file in a data directory.

This function generates a function that resolves a file path fragment to
a specific file location in an input directory.

## Usage

``` r
.inputter(directory = .here("input"))
```

## Arguments

- directory:

  the root of the input (default `` `.here("input")` `` \[fs_path\])

## Value

a function that takes a relative path and returns the absolute path of
the input file. The function can take the same arguments as
[`fs::dir_ls`](https://fs.r-lib.org/reference/dir_ls.html), and
particularly useful is `glob` and `type`. The function

## Unit tests



    inp = .inputter(tempdir())
    uniq = as.integer(Sys.time())
    file_fn = function(i) return(sprintf("test_%d_%s.txt",uniq, as.character(i) ))
    for (i in 1:10) {
      fs::file_touch(fs::path(tempdir(), file_fn(i)))
    }

    testthat::expect_true(fs::file_exists(inp(file_fn(2))))
    testthat::expect_error(inp(file_fn(0)))

    testthat::expect_equal(length(inp(glob=paste0("*/",file_fn("*")))),10)
