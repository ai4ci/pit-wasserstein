---
class: plan
id: decide-publication-strategy.md
title: 'Decide: short communication vs full methods paper'
status: done
rationale: Incremental on existing Wasserstein-PIT work unless the significance test lands; gate scope decisions on the feasibility signal rather than guessing.
informedBy:
- reference:wessel-2025-tail-calibration.md
- reference:zhao-2020-individual-calibration.md
- reference:dheur-2023-probabilistic-calibration-study.md
spawns:
- task:decide-publication-format-short-communication-or-full-paper.md
---
Strategic question raised 2026-11-13, discussed with the user. As a bias
adjustment plus a signed direction on an existing construction — Zhao et al.
(2020) already define the unadjusted Wasserstein-1-to-uniform PIT distance,
Wessel et al. (2025) already use its sample version as a training loss — the
method on its own is honestly short-communication scope: tight, incremental,
easy to publish. A working significance test
(`plan:dispersion-calibration-significance-test.md`) would change that
calculus into a fully-fledged methods paper, but only if it actually lands.

Rather than guess, gate the decision on the feasibility signal from
`task:characterise-d-pit-sampling-distribution-by-simulation.md` (does the
null distribution of $D^*_{pit}$ have a usable, stable shape as a function of
$n$?), and make explicit which other work can proceed regardless of the
outcome:

- **Proceeds either way**: terminology fix
  (`task:clarify-bias-adjusted-pit-diagnostic.md`), the non-normal
  distribution robustness study, the Fig. 3 rework (unadjusted vs. adjusted
  comparison, and the PCE/MCB quantified comparison), package/vignette
  hygiene. None of these differ in scope between a short communication and a
  full paper.
- **Blocked on the decision**: the depth of the introduction rewrite
  (`task:reframe-introduction-as-mathematical-methods-paper.md` — a short
  communication needs a terser, narrower framing than a full methods paper
  does), and whether to build the full bootstrap significance test
  (`task:implement-bootstrap-test-for-dispersion-calibration.md` — a short
  communication would state the characterisation result and stop, a full
  paper builds and ships the test).

---

## Resolved (2026-11-18) — done

The question is settled: **JMLR**, as a full methods paper rather than a short
communication. See
`task:decide-publication-format-short-communication-or-full-paper.md`.

The gate this plan set was whether a usable null distribution existed — a
short communication if the null turned out to be messy or
nuisance-dependent, a full paper if it did not. It did not: all three metrics
have distribution-free nulls, two in closed form
(`task:derive-analytical-null-distribution-for-pit-w-metrics.md`), which is
comfortably enough material for a full paper and is now its headline
contribution rather than a deferred limitation.

The contribution is also larger than the "bias adjustment plus a sign on an
existing construction" this plan worried about. The null distribution applies
to the *unadjusted* statistic that Zhao et al. (2020) and Wessel et al. (2025)
already use and report without one, so the paper gives the existing literature
a test it does not currently have, and the adjustment then partitions that
into location and dispersion.

Execution moves to `plan:paper-rewrite.md`.
