---
class: issue
title: "Sorting is implicit in the definition of D*_pit"
status: open
severity: major
ownership: preExisting
raised: 2026-09-11
tags: [paper, notation]
---

# Symptom

`eq:pit2` writes $D^*_{pit} = \frac{1}{n}\sum_i |rank_i - u_{i,adj}|$ where
$rank_i$ is ordered but $u_{i,adj} = F_i(X_{i,adj})$ is **not** stated to be
sorted. The code sorts (`sort(u)` inside `pitw()`, `analysis.R:120`). The
earlier "assume $X_i$ ascending" convention only implies sorted PIT values if the
predictions are also ordered, which is not guaranteed.

# Suggested fix

Use order-statistic notation $u_{(i),adj}$ in `eq:pit2` and `eq:pit3`. This
matters for P2: the extracted `pitw()` should sort explicitly and the test
should assert the ordering rather than inherit it from the data.
