---
class: task
id: document-asymptotic-theory-as-future-work.md
title: State the asymptotic D*_pit question precisely as future work
status: dropped
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

---

## Superseded (2026-11-18) — dropped

This task existed to record, as future work, a question that has since been
answered. Its premise was that a closed-form limiting distribution is
unavailable because the bias adjustment estimates a shift from the same
sample. That turned out to be wrong in an instructive way: the adjustment does
not prevent the asymptotics, it changes which functional of the Brownian
bridge you land on.

See `task:derive-analytical-null-distribution-for-pit-w-metrics.md`. All three
metrics now have distribution-free nulls, two of them in closed form, and they
are implemented in `src:significance.R` and documented in
`vignette:significance-testing.Rmd`.

The one genuinely open piece has been split out as
`task:derive-cdf-of-the-adjusted-u-pit-null.md` — the adjusted $U_{pit}$ limit
is identified and numerically verified but has no published c.d.f. That task,
not this one, is what the paper's future-work paragraph should point at.

Dropped rather than done: the documentation change it asked for would now say
the opposite of what is true.
