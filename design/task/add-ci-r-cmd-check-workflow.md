---
class: task
id: add-ci-r-cmd-check-workflow.md
title: No CI runs R CMD check or the test suite
status: todo
kind: chore
priority: medium
---
No CI currently runs `R CMD check` or the test suite on this repository:
`.github/workflows/` exists but is empty. For r-universe, the package only
needs to build and install cleanly (r-universe itself runs the check that
matters), but a standard `R-CMD-check` GitHub Actions workflow would catch the
three issues above (and future ones) before they reach r-universe at all.

Suggested fix: `usethis::use_github_action("check-standard")` (or
equivalent), commit the generated workflow, and confirm it passes once
`task:fix-description-placeholder-metadata.md`,
`task:add-missing-scoringrules-import.md` and
`task:regenerate-stale-generated-unit-tests.md` are done.

Note: `.github/` may be read-only in this sandbox depending on
`.sandbox/readonly` — check with `mount` before assuming this can be done
from inside a scoder session; it may need doing on the host.
