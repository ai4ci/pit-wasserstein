---
class: plan
id: dispersion-calibration-significance-test.md
title: 'Significance test for H0: estimator is dispersion-calibrated'
status: active
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
- task:document-three-part-test-decomposition.md
- task:derive-cdf-of-the-adjusted-u-pit-null.md
---
Strategic direction agreed 2026-11-13; **scope and approach revised
2026-11-17** after the analytical nulls turned out to be tractable.

The paper states this as an open limitation (`main.tex:240`):

> "Further work is required to characterise the behaviour of this in small
> samples, and to identify thresholds for significance."

### Revised approach

The original plan was a bootstrap test, with closed-form asymptotics deferred
to future work on the grounds that the bias-adjustment step put existing
Wasserstein-1-to-uniform results out of reach. That judgement was wrong, and
in an instructive way: the adjustment does not break the asymptotics, it
**changes which functional of the Brownian bridge you land on**.

The deliverable is now a **family of three distribution-free significance
tests**, one per metric, with nested null hypotheses:

| Metric | $H_0$ | Limit of $\sqrt{n}\times$metric |
|---|---|---|
| `B_pit` | PIT values are i.i.d. $U(0,1)$ — calibrated, full stop | $\int_0^1\|B^\circ\|$ |
| `D_pit` | dispersion correct, **location arbitrary** | $\mathcal{N}(0, 1/48)$ |
| `U_pit` | shape correct, **location arbitrary** | $\int_0^1\|B^\circ(t)-\kappa(t)B^\circ(\tfrac12)\|$ |

with $\kappa(t)=\varphi(\Phi^{-1}(t))/\varphi(0)$. Every null depends on the
number of predictions and nothing else. The first two have closed-form
c.d.f.s — Johnson & Killeen (1983) and the normal respectively — and the
third is identified and numerically verified but is evaluated by simulating
its limit process pending `task:derive-cdf-of-the-adjusted-u-pit-null.md`.

Implemented in `src:significance.R`. The bootstrap is superseded; see the note
on `task:implement-bootstrap-test-for-dispersion-calibration.md`.

### Two findings worth carrying into the paper

- **The adjustment is free for `D_pit` and expensive for `U_pit`.** $D_{pit}$
  is already orthogonal to a location shift, so its null is $N(0,1/48n)$
  adjusted or not. $U_{pit}$ pays the usual estimated-parameter price and its
  5% critical value is a stable 0.66 times `B_pit`'s, at every $n$ tested and
  under heteroscedasticity. This is the Kolmogorov–Smirnov to Lilliefors step.
- **The three metrics are a family, not a metric plus a flawed predecessor.**
  The unadjusted statistic is not hard to interpret — it is the omnibus test
  of full probabilistic calibration, and it is *more* interpretable than a
  proper score, being a bounded distance with a known null and a p value. The
  paper should present the adjustment as partitioning total miscalibration
  into location and the rest, not as repairing a defective metric.

### Caveat that applies to all three

Every null rests on the PIT values being independent. Overlapping forecast
windows — exactly what the EpiEstim example in `doc:paper-rewrite-skeleton.md`
§7 uses — violate that. The tests remain correct as stated; what needs saying
in the paper is that $n$ is the number of *independent* predictions, and that
serial dependence inflates the apparent significance.

Blocked on `task:clarify-bias-adjusted-pit-diagnostic.md` (in
`plan:paper-rewrite.md`): the three null hypotheses need "dispersion
calibration" defined as a distinct, precisely stated quantity first.
