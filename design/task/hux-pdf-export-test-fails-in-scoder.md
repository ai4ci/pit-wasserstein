---
class: task
id: hux-pdf-export-test-fails-in-scoder.md
title: Huxtable PDF export unit test fails in scoder
kind: issue
status: todo
priority: medium
touches:
- src:import-standalone-file-output-utils.R#.hux_save_as
---

<!-- loom:links start -->
- touches: [import-standalone-file-output-utils.R](../../R/import-standalone-file-output-utils.R)
<!-- loom:links end -->

Running the existing testthat suite in scoder reports one substantive failure and a generated source-link failure for the same test. The PDF/PNG call to `.hux_save_as()` raises “Unable to process html fragment”. The message comes from a nonzero exit of headless Chrome, whose stderr is suppressed by the export helper. Reproduce with Chrome diagnostics visible to determine whether this is environment-specific. The scoring and significance test files passed in the same run.


The failure appears likely to be sandbox-specific. Keep this issue open pending the maintainer’s recheck outside scoder.