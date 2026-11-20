---
class: task
id: getting-started-vignette.md
title: Add and verify the pitw getting-started vignette
status: done
kind: chore
priority: medium
touches:
- vignette:pitw.Rmd
---

<!-- loom:links start -->
- touches: [pitw.Rmd](../../vignettes/pitw.Rmd)

### Backlinks
- spawns: [Add a getting-started vignette and review the vignette series](../plan/vignette-guide-and-editorial-review.md)
<!-- loom:links end -->

The getting-started vignette gives an executable normal-forecast example and links to the six vignettes in reading order. R Markdown and pkgdown rendered the new page. Both outputs link to the six registered articles in the intended order. The default pkgdown navbar points Get started to articles/pitw.html.

The pkgdown check used a temporary process-local shim for the system package metadata lookup. The installed jQuery 3.7.1 files were present, but the package database lookup could not find them.
