---
class: plan
id: r-universe-release-readiness.md
title: Make the package build and check cleanly for r-universe
status: done
rationale: Package is functionally complete but under-documented, with a stale test suite; not destined for CRAN, only r-universe (already registered elsewhere).
spawns:
- task:fix-description-placeholder-metadata.md
- task:add-missing-scoringrules-import.md
- task:regenerate-stale-generated-unit-tests.md
- task:add-ci-r-cmd-check-workflow.md
---
Strategic direction agreed 2026-11-13: the package is functionally complete
but not well documented, and its test suite is stale. It is not destined for
CRAN, only an r-universe repository (already registered elsewhere — this
repo just needs to build cleanly for it), so the bar is "builds and checks
cleanly on r-universe", not full CRAN submission polish. Each spawned task
below is a specific, verified defect rather than a general audit.

Explicitly out of scope, checked with the user: `R/interfaces.R`'s `iface`
contracts need no roxygen of their own — `pkgtools::pkgtools_rd` already
projects each field's inline description into the generated `.Rd` for every
function that uses one (confirmed via `man/prediction_scores.Rd`, which lists
`true_value`, `location`, `scale`, etc. with their `iface` descriptions). That
is self-documenting by construction.

---

## Complete (2026-11-18) — done

All four spawned tasks are closed: the `DESCRIPTION` placeholder metadata, the
missing `scoringRules` import, the stale generated unit tests, and the
`R-CMD-check` GitHub Actions workflow, which now exists alongside a `pkgdown`
workflow.

Not verified from inside the sandbox: that the workflow has actually run green
on GitHub, and that the r-universe build picks the package up. Both are
host-side checks. If either fails, raise it as a new issue rather than
reopening this plan — the readiness work it scoped is done.
