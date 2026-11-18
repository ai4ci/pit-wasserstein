---
class: task
id: fix-description-placeholder-metadata.md
title: DESCRIPTION still has placeholder Title and Description
status: done
kind: issue
priority: high
blocks:
- task:add-ci-r-cmd-check-workflow.md
---
Pre-existing. `DESCRIPTION` still has the placeholder text from
`usethis::create_package()`:

```
Title: Analysis package to demonstrate pit wasserstein methods for
Description: What the package does (one paragraph).
```

The `Title` is also truncated mid-sentence ("...methods for" — for what?).
r-universe builds `R CMD check --as-cran`-style metadata checks against
`DESCRIPTION`; a placeholder `Description` is a NOTE at minimum and may block
listing.

Suggested fix: write a real one-paragraph `Description` describing the
adjusted PIT-Wasserstein metric and its purpose (bias-independent dispersion
calibration), and complete the `Title`.
