---
class: issue
title: "patchwork 1.3.2 is incompatible with ggplot2 4.x"
status: open
severity: cosmetic
ownership: preExisting
raised: 2026-09-11
tags: [environment, dependencies]
---

# Symptom

`ggplot + ggplot` aborts with "Can't add `b` to a ggplot object" under ggplot2
4.0.3, so the Fig 3 / Fig 4 compositions cannot use `+ plot_layout(...)`.

# Status

The **code** side is worked around: the Fig 3/4 grids use
`patchwork::wrap_plots(...)` (see `analysis.R:642`, `analysis.R:809`), which
works on both old and new patchwork. The environment fact is unchanged, and
which way round the repo should depend on it is still the author's call.

# Suggested fix

Keep `wrap_plots()` and say so in the paper's reproduce instructions, **or**
install patchwork >= 1.4 / pin ggplot2 3.5.x and go back to the `+` style. The
hybrid package needs this decided before `DESCRIPTION` can state a version
constraint (`task:p1-package-skeleton.md`).
