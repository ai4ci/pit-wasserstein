---
class: issue
title: "Sample size of the validation simulation disagrees between paper and code"
status: open
severity: blocker
ownership: preExisting
raised: 2026-09-11
tags: [correctness, paper]
followUp: task:p4-reproducibility-ci.md
---

# Symptom

`main.tex` (Validation, `\eqref{eq:valid2}` area) states the 1000 random
configurations were each assessed "based on 10000 simulated true value and
probabilistic prediction pairs". The two `run_scenario()` calls that produce
Fig 3 and Fig 4 pass `true_value` — the **1000**-element vector defined near the
top of `analysis.R`. Only the Fig 2 scenario grid uses the 10000-element
`true_values`.

# Why it needs an author decision

Pick one and make it agree:

- if 10000 pairs is the intention, pass `true_values` to both calls **and**
  change the `n` in the `unbiased_percent_50_ci` beta adjustment, which
  currently silently uses the global `n = 1000`; or
- if 1000 is the intention, change the two numbers in the Validation text.

This is the same class of bug that kept the CRPS recycling bug invisible: with
`true_values` (10000) in scope, `crps_norm()` (`analysis.R:172`) silently
recycled the 1000-element estimate vectors 10× and returned a mean CRPS ~80% too
high. Fixing the call without the `n` reintroduces exactly that.
