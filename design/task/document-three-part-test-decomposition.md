---
class: task
id: document-three-part-test-decomposition.md
title: 'Document the three-part PIT-Wasserstein test decomposition in the paper'
status: done
kind: paperFix
priority: high
touches:
- src:scoring.R#pit_w
- paper:main.tex
- vignette:pit-w-metrics.Rmd
- vignette:significance-testing.Rmd
blocks:
- task:implement-bootstrap-test-for-dispersion-calibration.md
---
Arising from the fig. 3C/3D observation (user, 2026-11-13): $U^*_{pit}$ has a
minimum strictly above zero when $\kappa_\mathcal{S}>0$, whereas $D^*_{pit}$
passes through zero regardless. This supports a **two-part test**, which may
be the most useful framing of the metrics for a methods paper.

## Measured behaviour ($n=20000$, 200 reps, x-space adjustment, no bias)

$\mathbb{E}[D^*_{pit}]$ at $c=1$:

| $\kappa$ | 0 | 0.5 | 1 | 2 |
|---|---|---|---|---|
| $\mathbb{E}[D^*]$ | 5.9e-5 | 4.7e-5 | 7.3e-5 | 6.2e-5 |
| $\mathbb{E}[U^*]$ | 0.0015 | 0.0108 | 0.0251 | 0.0410 |

The root of $D^*$ does **not** move with $\kappa$ — it is zero at $c=1$ to
within Monte Carlo error for every $\kappa$ tested. $U^*$ rises 27-fold over
the same range.

## Mechanism

A lognormal scale mixture of normals is **leptokurtic**: excess mass at the
edges *and* at the centre, deficit in between, so the PIT histogram under
$\kappa>0$ is **W-shaped**, not U-shaped. $D^*$ weights edge departures $+$
and centre departures $-$, so they cancel; $U^*$ takes absolute values, so
they accumulate. This should be stated explicitly in the paper — it explains
both panels and is a selling point for reporting the pair rather than either
alone.

(Worth checking whether the cancellation is exact or merely near-exact for
asymmetric mixtures; the result above is for a symmetric lognormal scale
mixture.)

## Proposed framing

- $D^*_{pit}$: tests whether the **median** dispersion is right. Immune to
  bias *and* to $\kappa$. $H_0: c=1$.
- $U^*_{pit}$ given $D^*\approx0$: residual **shape** mismatch.

**Do not overclaim on the second.** $U^*\!\mid\!D^*\!=\!0$ detects any residual
shape departure — wrong distributional family, skew, tail misspecification —
not $\kappa$ specifically. The correct statement is "shape mismatch, of which
spread-error decoupling is the leading cause", not an identification of
$\kappa$.

## Statistical caveat: $D^*$ is unbiased under $\kappa$ but not pivotal

$\mathbb{E}[D^*]=0$ at $c=1$ for all $\kappa$, but $n\mathrm{Var}(D^*)$
inflates from $1/48=0.0208$ to 0.0335 at $\kappa=2$ (and does not shrink with
$n$). So the fixed closed-form critical value over-rejects: measured size
4.3% / 8.8% / 15.8% at $\kappa$ = 0 / 1 / 2.

**Studentising largely fixes this.** Using a bootstrap standard error over the
PIT values instead of the fixed $1/\sqrt{48n}$: size 3.8% / 5.5% / 6.5% at the
same $\kappa$. Still slightly over-sized at large $\kappa$ — the naive
bootstrap ignores both the bias-adjustment step and the dependence induced by
sorting — so it needs refinement (re-apply the adjustment inside each
bootstrap replicate, or derive a plug-in asymptotic variance from the
empirical PIT distribution).

This is the practical recipe the significance test should probably take:
**closed-form $N(0,1/48n)$ as the reference null, studentised bootstrap for
the actual test**, with the closed form used to validate the bootstrap rather
than replace it.

All figures above are quick in-session simulations and must be reproduced in
a vignette before citation.

---

## Revised 2026-11-17: three-part, not two-part

The decomposition now has three stages, because the unadjusted metric has been
promoted from "the thing the adjustment fixes" to a first-class member of the
family with its own null hypothesis.

1. **`B_pit`** — $H_0$: the PIT values are i.i.d. $U(0,1)$. Omnibus. Rejects
   when anything at all is wrong and says nothing about what.
2. **`D_pit`** — $H_0$: dispersion is correct, location arbitrary. Signed, so
   a rejection names the direction: positive is overconfident, negative
   underconfident.
3. **`U_pit`** — $H_0$: shape is correct, location arbitrary. Rejects on skew,
   tail weight or mixed dispersion errors that survive the adjustment.

Each null is strictly weaker than the one before, so the sequence reads as a
diagnosis rather than three separate tests:

| `B_pit` | `D_pit` | `U_pit` | Reading |
|---|---|---|---|
| not rejected | — | — | calibrated |
| rejected | not rejected | not rejected | pure location error |
| rejected | rejected | not rejected | dispersion error, direction given by sign of `D_pit` |
| rejected | not rejected | rejected | shape error at the right width |
| rejected | rejected | rejected | both |

Note the multiplicity: the three statistics are computed from the same PIT
values and are not independent. The sequence should be presented as a
diagnostic read-down from a single rejection, not as three tests each at 5%.

## Update 2026-11-18

Kind changed to `paperFix`: code in `src:significance.R` implements the
B_pit → D_pit → U_pit diagnostic correctly. The paper (`vignettes/main/main.tex`)
still only describes two metrics (U_pit and D_pit) and does not present the
three-part diagnostic sequence. This task now covers documenting the three-part
decomposition in the paper.

## Update 2026-11-18

The three-part diagnostic is implemented in `src:significance.R` as the
`b_pit_significance() / d_pit_significance() / u_pit_significance()` family.
The paper (`vignettes/main/main.tex`) still describes only two metrics and
lacks the B_pit → D_pit → U_pit diagnostic sequence. This task covers writing
that section into the paper.

Completed in the standalone [rewrite](../../vignettes/main/main.tex). The manuscript gives the three limiting references and uses a median-adjusted simulation to show what different rejection patterns support. A pure width error can produce three rejections. The paper reports marginal tests without treating them as an error-controlled classification procedure.
