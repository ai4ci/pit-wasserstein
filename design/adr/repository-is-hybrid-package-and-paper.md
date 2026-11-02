---
class: adr
title: "The repository is a hybrid R package and paper"
status: superseded
decided: 2026-11-02
tags: [structure, packaging]
---

# Context

The repo is currently paper-only: `analysis.R` (1010 lines) holds both the
metric definitions and the figure code, `R/` holds only vendored `ggrrr`
plotting helpers, and there is no `DESCRIPTION`, `NAMESPACE`, `LICENSE`, `man/`
or `tests/`. The metric functions are unreachable to anyone who does not
`source()` the whole script, which makes the published figures unreviewable.

# Decision

This repository is **both** an R package and the paper. Neither half is
subordinate: the paper is the citable artefact, the package is what makes the
figures reproducible by someone other than the author.

Concretely:

- `R/` becomes the package namespace and holds the metric functions.
- The paper's simulation/plotting script moves out of the package's runtime
  path (a package must not write into its own source tree), becoming an explicit
  reproducibility script.
- `main/` and `references/` are excluded from the build with `.Rbuildignore`.

# Consequences

- The `.Rprofile` hack that `source()`s `R/import-standalone-*.R` into the
  global environment must go: it is incompatible with `R/` being a namespace,
  and it must not ship.
- `here::here()` stops working inside the package (`here` is disabled for
  packages), so the figure output path cannot stay as written.
- Every current symbol in `R/` is dot-prefixed, so nothing is exported today;
  `NAMESPACE` will need explicit exports and internal helpers will keep the dot.
