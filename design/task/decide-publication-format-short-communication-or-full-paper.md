---
class: task
id: decide-publication-format-short-communication-or-full-paper.md
title: 'Decide: short communication or full methods paper'
status: done
kind: chore
priority: high
blocks:
- task:reframe-introduction-as-mathematical-methods-paper.md
- task:implement-bootstrap-test-for-dispersion-calibration.md
---
Decide: short communication (tight scope, incremental novelty honestly
stated) or full methods paper (broader framing, significance test as a
headline result), once the feasibility signal is in from
[task:characterise-d-pit-sampling-distribution-by-simulation.md](characterise-d-pit-sampling-distribution-by-simulation.md).

Decision criteria to apply once that task reports back:

- **Short communication** if the null distribution of $D^*_{pit}$ is messy,
  strongly dependent on nuisance parameters ($\kappa_\mathcal{S}$, the choice
  of `dist`/`link`), or only tractable by heavy simulation with no usable
  closed form or stable empirical critical-value table — i.e. the test isn't
  going to be a clean, citable result on the timeline available.
- **Full methods paper** if the characterisation task produces a usable,
  reasonably stable empirical null (even without an asymptotic closed form)
  that the bootstrap test
  ([task:implement-bootstrap-test-for-dispersion-calibration.md](implement-bootstrap-test-for-dispersion-calibration.md))
  can be built on with confidence.

Either way, state the decision and its reasoning in this task's body before
closing it, and update
[plan:paper-rewrite.md](../plan/paper-rewrite.md)'s rationale to reflect the
chosen scope — the blocked tasks below should not proceed until this is
closed.

## Update 2026-11-18

Significance testing and 3 metric family (B_pit, D_pit, U_pit) repositioning 
make this a full methods paper.
