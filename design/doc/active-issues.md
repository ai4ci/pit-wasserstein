---
class: doc
title: "Active issues"
tags: [meta]
---

# Active issues

Pre-existing issues found during the layout/dependency rework and the hybrid
package migration. **Not fixed** — each needs a decision from the author.
Suggested fixes are indicative only. Per `AGENTS.md`, issues *introduced by the
current change* are fixed immediately instead of recorded here; `ownership`
distinguishes the two.

<!-- loom view: openIssues -->

- [Sample size of the validation simulation disagrees between paper and code](../issue/sample-size-discrepancy.md)
- [Figures are not reproducible](../issue/figures-not-reproducible.md)
- [Sorting is implicit in the definition of D*_pit](../issue/implicit-sorting-notation.md)
- [No usable LaTeX inside the scoder sandbox](../issue/no-latex-in-sandbox.md)
- [tab1-params.pdf cannot be faithfully re-rendered outside the author's machine](../issue/tab1-needs-chromium.md)
- [patchwork 1.3.2 is incompatible with ggplot2 4.x](../issue/patchwork-ggplot2-incompatibility.md)
- [Roboto is not installed system-wide in the sandbox](../issue/roboto-not-installed.md)
<!-- loom view: openIssues end -->

## Resolved

Kept here (rather than as `status: fixed` instances) only until the fix is
verified, per `AGENTS.md` "remove an active issue when it is fixed":

- Sign error in the $U^*_{pit}$ prose — over-confidence is $+0.25$, excessive
  uncertainty $-0.25$ (verified numerically).
- `eq:bias` used $g'$ where $g^{-1}$ (inverse link) was meant.
- Sentence fragment about universal residuals.
- `ggoutbreak` dependency — `R/` standalones are `source()`d instead (itself
  superseded by `task:p2-extract-metric-api.md` step 3).
- `ggpp` dependency — its single `geom_label_npc()` call replaced with
  `geom_label(x = 0.02, y = Inf)`.
- CRPS recycling bug in `run_scenario()` (`true_values` → `true_value`) — the
  reason `issue:sample-size-discrepancy.md` is still dangerous.
- Layout: paper in `main/`, literature in `references/`, script at root.
- No top-level plot auto-prints any more, so a headless run no longer dies on
  the default pdf device.
