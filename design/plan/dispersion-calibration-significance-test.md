---
class: plan
id: dispersion-calibration-significance-test.md
title: 'Significance test for H0: estimator is dispersion-calibrated'
status: draft
rationale: 'Picks up the papers own stated limitation (main.tex:240): characterise D*_pit vs sample size and develop a significance test.'
informedBy:
- reference:zhao-2020-individual-calibration.md
- reference:diebold-1998-density-forecast-evaluation.md
- reference:panaretos-2019-wasserstein-distances.md
- reference:siegert-2017-detecting-skill-improvements.md
- reference:bhattacharya-2021-brownian-bridge.md
- reference:takacs-1993-absolute-brownian-motion.md
spawns:
- task:characterise-d-pit-sampling-distribution-by-simulation.md
- task:implement-bootstrap-test-for-dispersion-calibration.md
- task:document-asymptotic-theory-as-future-work.md
- task:derive-analytical-null-distribution-for-pit-w-metrics.md
- task:restore-pivotality-of-the-bias-adjustment.md
- task:two-part-test-decomposition-d-then-u.md
---
Strategic direction agreed 2026-11-13. The paper already states this as an
open limitation (`main.tex:240`):

> "Further work is required to characterise the behaviour of this in small
> samples, and to identify thresholds for significance."

This plan picks that up: study the relationship between sample size and the
limiting behaviour of $D^*_{pit}$, and develop a significance test for
$H_0$: the estimator is dispersion-calibrated (the ratio
$\sigma_\mathcal{S}/\sigma_\mathcal{E} = 1$).

Agreed approach (discussed with the user): bootstrap/simulation-based test
first, ship that for this paper; state the asymptotic question (a closed-form
limiting distribution for the bias-adjusted Wasserstein-1-to-uniform
statistic) explicitly as future work rather than attempting to derive it now
— the bias-adjustment step (estimating and subtracting a link-scale shift
before computing the distance) means existing asymptotic results for
Wasserstein-1-to-uniform distances of an empirical process do not apply
directly; deriving the adjusted case is open-ended research, not a bounded
task for this paper.

Blocked on `task:clarify-bias-adjusted-pit-diagnostic.md` (in
`plan:paper-rewrite.md`): the null hypothesis this plan tests needs
"dispersion calibration" defined as a distinct, precisely stated quantity
first, not the currently conflated "calibration".
