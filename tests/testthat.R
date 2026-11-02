# Not a package: source the reference implementation, then run the suite.
#   Rscript tests/testthat.R
if (file.exists("R/metrics.R")) source("R/metrics.R")
testthat::test_dir("tests/testthat", stop_on_failure = TRUE, package = NULL)
