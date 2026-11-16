---
class: task
id: document-asymptotic-theory-as-future-work.md
title: State the asymptotic D*_pit question precisely as future work
status: todo
kind: paperFix
priority: low
touches:
- paper:main.tex
---
State the open asymptotic question precisely in `main.tex`'s discussion/
future-work section, replacing the current vague "further work is required"
(`main.tex:240`) with a specific statement of the problem once the bootstrap
test (`task:implement-bootstrap-test-for-dispersion-calibration.md`) exists:
a closed-form limiting distribution for $\sqrt{n}\,D^*_{pit}$ (or
$U^*_{pit}$) is not available because the bias-adjustment step estimates and
subtracts a link-scale shift from the same sample before computing the
Wasserstein-1-to-uniform distance, which existing asymptotic results for
that distance (without the adjustment) do not cover.

This is a documentation/framing task, not a derivation attempt — it closes
out the plan by recording the boundary of what was and wasn't established,
for a future paper or collaborator to pick up.
