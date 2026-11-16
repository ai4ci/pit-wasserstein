---
class: task
id: pit-w-notation-swapped-between-readme-and-paper.md
title: U*_pit and D*_pit are swapped in README relative to main.tex and the code
status: todo
kind: issue
priority: medium
touches:
- src:scoring.R#pit_w
- paper:main.tex
blocks:
- task:derive-analytical-null-distribution-for-pit-w-metrics.md
---
Pre-existing, found while deriving the null distributions. The two metrics'
symbols are swapped between documents.

**`main.tex` and `R/scoring.R` agree** (and are self-consistent):
- `main.tex:148` eq:pit2 — $U^*_{pit}=\frac1n\sum|rank_i-u_{i,adj}|$,
  **undirected**, range [0, 0.5].
- `main.tex:157` eq:pit3 — $D^*_{pit}=\frac1n\sum(rank_i-u_{i,adj})\operatorname{sgn}(0.5-rank_i)$,
  **directed**, range [-0.25, +0.25].
- `src:scoring.R#pit_w` returns `U_pit` = `mean(abs(pit - rank))` (undirected)
  and `D_pit` = directed. Matches the paper.

**`README.md` has them swapped**:
- line 52: "### Adjusted PIT-Wasserstein ($D^*_{pit}$)" followed by the
  *undirected* formula and range [0, 0.5].
- line 63: "### Directed PIT-Wasserstein ($U^*_{pit}$)" followed by the
  *directed* formula and range [-0.25, +0.25].

`tests/testthat/test-metrics.R` follows the README convention (`res$d_pit`
for the undirected quantity with max 0.5, `res$u_pit` for the ±0.25 directed
one), so it contradicts the field names the code actually returns. That file
is already known-stale for other reasons — it tests an API with `cdf=`,
`res$bias` and `res$raw_wasserstein` that `pit_w()` no longer has, see
`task:testthat-runner-is-pre-package.md` — but the notation swap is a
separate defect that would survive fixing the API drift.

Suggested fix: adopt the `main.tex`/code convention ($U^*$ undirected, $D^*$
directed) everywhere, correct `README.md`, and align the test file's field
names when it is rewritten. Worth doing before the theory section is written,
since the analytical results differ per metric ($N(0,1/48n)$ for the directed
one, Kac-Takács for the undirected) and a symbol swap there would be
genuinely confusing.