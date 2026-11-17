---
class: doc
id: paper-rewrite-skeleton.md
title: Paper rewrite skeleton — narrative structure, arguments, gaps
---
This document lays out the planned structure of the standalone methods paper,
mapping each section to the narrative goal, key arguments, existing material,
and open questions. It is a planning artefact — **not yet written prose**.

---

## 0. Title (working)

**Options under discussion:**

1. _"Bias-adjusted PIT-Wasserstein metrics for dispersion calibration"_
   — precise, but long.
2. _"Signed Wasserstein distances on PIT values for diagnosing dispersion miscalibration"_
   — emphasises the signed direction and PIT space.
3. _"PIT-Wasserstein: a bias-adjusted, directional metric for dispersion calibration"_
   — compact, introduces the name.

**To decide:** title, one-line abstract (30-50 words).

---

## 1. Introduction (target: ~2 pages)

### Goal
Position the paper as a **methods paper** in the probabilistic forecast evaluation
literature. Make the gap, the contribution, and the structure of the paper explicit
in the first page.

### Key arguments (with citation anchors)

| # | Argument | Citations |
|---|----------|-----------|
| 1 | A probabilistic forecast is evaluated by three jointly determined qualities: **calibration** (PIT uniformity), **sharpness** (uncertainty width), and their interaction (dispersion calibration). | Gneiting et al. (2007); DeGroot & Fienberg (1983) |
| 2 | The gold-standard criterion is probabilistic calibration: PIT values should be i.i.d. $U(0,1)$. | Dawid (1984); Diebold et al. (1998) |
| 3 | Standard diagnostics (PIT histogram, KS test, AD test) detect *miscalibration but not its direction or cause*. Diebold et al. (1998) call this "tests are not constructive." | Diebold et al. (1998); Bosse et al. (2024) |
| 4 | Wasserstein-1 distance from the PIT distribution to uniform ($W_1$) is a **quantified**, constructive scalar measure, but existing work (Zhao et al. 2020; Wessel et al. 2025) does **not adjust for bias** — their metric conflates bias with dispersion error. | Zhao et al. (2020); Wessel et al. (2025) |
| 5 | **Contributions:** (a) a bias-adjusted PIT-Wasserstein metric $U^*_{pit}$ that isolates **dispersion calibration**; (b) a signed directed variant $D^*_{pit}$ giving direction; (c) a bias-invariant adjustment in $x$-space with a proof of pivotality under homoscedasticity; (d) the analytical null distribution of both metrics; (e) empirical validation showing invariance to bias, symmetry under inversion, and two-part diagnostic use. | — |

### Structure of the intro

1. **1–2 paragraphs:** Probabilistic forecasting and the calibration/sharpness trade-off.
   Define "dispersion calibration" formally as the ratio $\sigma_{\mathcal{S}}/\sigma_{\mathcal{E}}$.
2. **1 paragraph:** PIT values and the uniformity criterion. Cite Dawid, Diebold et al.
   State the "tests are not constructive" complaint verbatim.
3. **1 paragraph:** The gap — existing $W_1$ PIT metrics (Zhao, Wessel) are biased by the
   global location error. Introduce the idea of debiasing.
4. **Contributions bullet list** (3-4 bullets).
5. **Roadmap:** "Section 2 introduces notation and the metrics. Section 3 proves the null
   distributions. Section 4 presents simulation validation. Section 5 discusses the two-part
   diagnostic. Section 6 concludes."

### Gaps / decisions

- **Q1:** Should the intro include a small schematic figure showing the PIT histogram → bias
  skew → $U^*$/$D^*$ decomposition? Or leave visuals for the methods section?
- **Q2:** Abstract length and journal target (affects intro density).
- **Q3:** The "dispersion calibration" definition is still not fully formalised (what is the
  population parameter? is it a ratio, or a function?).
  Currently: $\kappa = \sigma_{\mathcal{S}}/\sigma_{\mathcal{E}}$. This is clear in simulation
  context but needs a general definition.

---

## 2. Notation and Problem Setup (target: ~1 page)

### Goal
Define all notation, the estimation framework, and the simulation model that will be used
throughout the paper. This section replaces the informal prose in the current main.tex
lines 63-76 with precise mathematical definitions.

### Content

- **Notation:** $n$ predictions, $(X_i, F_i)$ pairs, PIT values $u_i = F_i(X_i)$,
  sorted PIT $u_{(i)}$, uniform plotting positions $r_i = (i-0.5)/n$.
- **Bias adjustment:** $g(\cdot)$ link function, $\hat{\delta} = \text{med}(g(X_i) - g(x_{i,0.5}))$,
  adjusted values $X_{i,adj} = g^{-1}(g(X_i) - \hat{\delta})$, adjusted PIT $u_{i,adj} = F_i(X_{i,adj})$.
- **Simulation model (the "error function" framework):**

  $$
  \begin{aligned}
  X &\sim \text{some fixed value or distribution} \\
  \mathcal{E}_i &\sim \text{error distribution (location)} \\
  \sigma_i &\sim \text{sharpness distribution (scale)} \\
  F_i(\cdot) &= G\left(\frac{\cdot - X - \mathcal{E}_i}{\sigma_i}\right)
  \end{aligned}
  $$

  Parameters: $\mu_{\mathcal{E}}$ (bias), $\sigma_{\mathcal{E}}$ (true error spread),
  $\sigma_{\mathcal{S}}$ (median sharpness), $\kappa_{\mathcal{S}}$ (CV of sharpness).
  Calibration ratio $c = \sigma_{\mathcal{S}}/\sigma_{\mathcal{E}}$.

- **The null:** $c=1$ and $\kappa_{\mathcal{S}}=0$ ⇒ $u_i \sim \text{i.i.d. } U(0,1)$.

### Gaps / decisions

- **Q4:** Should the simulation model include skewed families (gamma) from the start,
  or defer to Section 8 (caveats)?
  Currently only normal/lognormal are used. Skewed families expose a defect in the
  mean-based bias estimator — this is a **pre-existing bug** that should be noted
  but not solved in this paper.
- **Q5:** The link function is always $\log$ in practice. Should we generalise to arbitrary
  $g$ or fix $g=\log$? The proof of null preservation works for any link where the bias
  estimator is consistent.

---

## 3. The Metrics (target: ~1.5 pages)

### Goal
Define $U^*_{pit}$ and $D^*_{pit}$ formally, explain their range and interpretation,
and prove the key properties: bias invariance, symmetry, and the signed direction.

### Content

#### 3.1. The adjusted PIT-Wasserstein metric $U^*_{pit}$

$$
U^*_{pit} = \frac{1}{n}\sum_{i=1}^n |r_i - u_{(i),adj}|
$$

Range: $[0, 0.5]$. Zero iff perfectly dispersion-calibrated. Interpretation: $W_1$ distance
between the adjusted PIT distribution and $U(0,1)$.

#### 3.2. The directed metric $D^*_{pit}$

$$
D^*_{pit} = \frac{1}{n}\sum_{i=1}^n (r_i - u_{(i),adj})\,\text{sgn}(0.5 - r_i)
$$

Range: $[-0.25, 0.25]$. Positive = overconfident, negative = overconservative, zero =
median-width correct.

#### 3.3. Properties

- **Theorem 1 (Bias invariance):** If $\hat{\delta}$ estimates the true link-scale shift
  consistently, the null distribution of $D^*_{pit}$ under homoscedasticity is unchanged.
  Proof sketch: the bias adjustment subtracts a constant in $x$-space; under the null the
  PIT values are uniform, and the adjustment is a rank-preserving shift.
- **Theorem 2 (Symmetry under inversion):** For homoscedastic normal predictive families,
  $U^*_{pit}(c) = U^*_{pit}(1/c)$ exactly. Proof uses $F_{1/c}(p) = F_c^{-1}(p)$.
- **Theorem 3 (Signed decomposition):** $D^*_{pit} = (\text{overconfidence mass}) -
  (\text{overconservative mass})$, while $U^*_{pit} = (\text{overconfidence mass}) +
  (\text{overconservative mass})$.

### Gaps / decisions

- **Q6:** The proofs are currently informal sketches. Do we want formal proofs, or just
  the simulation evidence + "sketch" prose?
  Ponytail: a formal proof for Theorem 1 under homoscedasticity, a simulation-supported
  statement for Theorem 2, and an algebraic identity for Theorem 3 (no proof needed).
- **Q7:** The bias-adjustment uses a **median** in practice but the code/looms say **mean**.
  The "mean-based estimator fails for skewed distributions" task is still open.
  Which should the paper use? Recommendation: **median** (robust, consistent under null).

---

## 4. The Null Distributions (target: ~2 pages) ⭐

### Goal
This is the **star section** of the paper — the analytical results that make the metrics
publishable. State both limits clearly and give practical critical values.

### Content

#### 4.1. Reduction to the Brownian bridge

Both metrics are functionals of the empirical quantile process
$q_n(p) = \sqrt{n}(F_n^{-1}(p) - p) \Rightarrow -B^\circ(p)$.

#### 4.2. $D^*_{pit}$ — closed form Gaussian

A **linear** functional of the bridge:

$$
\sqrt{n}\,D^*_{pit} \Rightarrow \int_0^1 \text{sgn}(0.5-t)\,B^\circ(t)\,dt
\;\sim\; N(0, \sigma^2)
$$

$$
\sigma^2 = \iint \text{sgn}(0.5-s)\text{sgn}(0.5-t)(s\wedge t - st)\,ds\,dt = \frac{1}{48}
$$

**Result:** $D^*_{pit} \dot{\sim} N(0, 1/(48n))$ under $H_0$.

Practical 5% test: $|D^*_{pit}| > 0.2829/\sqrt{n}$.

Empirical size: 8.1% at $n=10$, 5.3% at $n=100$, 5.1% at $n=400$.
Caveat: slight over-rejection at $n < 50$ due to heavy tails.

#### 4.3. $U^*_{pit}$ — integrated absolute bridge

$$
\sqrt{n}\,U^*_{pit} \Rightarrow \int_0^1 |B^\circ(t)|\,dt
$$

Mean: $\mathbb{E}\int|B^\circ| = \sqrt{2\pi}/8 \approx 0.3133$.
95% critical value: $\approx 0.580/\sqrt{n}$ (from simulation / known distribution).

No closed-form CDF for the limit (Takács 1993 is for Brownian *motion*, not bridge).
Tabulated critical values from simulation.

#### 4.4. Bias adjustment preserves the null (homoscedastic case)

Simulation evidence: $\kappa = 0 \Rightarrow$ null survives exactly, with or without bias.
Theoretical argument: under homoscedasticity the adjustment is a constant shift in probit
space, which preserves uniformity.

#### 4.5. What is the null hypothesis?

$H_0$: the PIT values are i.i.d. $U(0,1)$, which requires $c=1$ **and** $\kappa=0$.
Spread-error decoupling ($\kappa > 0$) is an **alternative**, not a null.

### Gaps / decisions

- **Q8:** The variance computation for $D^*_{pit}$ ($1/48$) — is the double integral
  computation shown in full detail, or just stated?
  Recommendation: show the integral setup, state the result, cite a reference for the
  evaluation (or give the 3-line algebra).
- **Q9:** Critical values for $U^*_{pit}$ — can we cite a reference for the distribution of
  $\int|B^\circ|$? Takács (1993) is wrong. Is there a bridge-specific source?
  If not, tabulate from high-quality simulation and cite it as a table in the paper.
- **Q10:** Do we include the Edgeworth correction for $D^*_{pit}$ at small $n$?
  Ponytail: not for this paper. Note as a caveat, implement as future work.

---

## 5. Simulation Validation (target: ~2 pages)

### Goal
Empirical confirmation of the theory and demonstration of the metrics' diagnostic
properties. This section mirrors the current Fig. 3 and Fig. 2 but reorganised around
the narrative of the paper.

### Content

#### 5.1. Simulation design

The error-function model (eq:valid). Parameter space: bias $\mu_{\mathcal{E}} \in [-1,1]$,
calibration ratio $c \in [0.25, 4]$, sharpness CV $\kappa_{\mathcal{S}} \in [0, 2]$, $n =
10000$ predictions per simulation, 1000 replications.

#### 5.2. Bias invariance (reproducing current Fig. 3C/D)

- Plot $U^*_{pit}$ and $D^*_{pit}$ vs. true calibration ratio $c$, with bias on the x-axis.
  Show that the curves are flat across bias (invariance) and monotonic in $c$.
- Color-code by $\kappa_{\mathcal{S}}$ to show the spread-error decoupling effect.

#### 5.3. Symmetry under inversion (new, replacing the old Fig. 3)

- Plot $U^*_{pit}(c)$ and $U^*_{pit}(1/c)$ on the same axes. Show exact overlap (or near-
  overlap due to Monte Carlo).
- Contrast with the probit-space adjustment, which does **not** exhibit this symmetry.

#### 5.4. PIT histogram shapes

- Show U-shaped (overconfident), dome-shaped (overconservative), skewed (biased), and
  W-shaped (non-zero $\kappa$) PIT histograms with associated metric values.
- This illustrates the two-part diagnostic (Section 6).

#### 5.5. Small-sample behaviour

- Show convergence of $\sqrt{n}\,U^*_{pit}$ and $\sqrt{n}\,D^*_{pit}$ across $n = 25, 50,
  100, 400$.
- Compare empirical distribution to the theoretical $N(0, 1/48)$ for $D^*_{pit}$.
- Tabulate empirical 5% critical values for both metrics.

### Gaps / decisions

- **Q11:** Should this section include the skewed-family example (gamma) showing the mean-
  bias defect?
  Recommendation: yes, but as a **caveat box** or footnote, not a main result. File as a
  pre-existing bug.
- **Q12:** What is the real-world example? The SEIR + EpiEstim example was discussed but not
  yet implemented. Do we have one?
  **Status:** NOT YET DONE. A real-data example would significantly strengthen the paper.
  If available, add as Section 7.

---

## 6. The Two-Part Diagnostic (target: ~1 page)

### Goal
Show how $D^*_{pit}$ and $U^*_{pit}$ complement each other as a diagnostic system,
not just two related metrics.

### Content

| Scenario | $D^*_{pit}$ | $U^*_{pit}$ | Interpretation |
|----------|-------------|-------------|----------------|
| Calibrated, homoscedastic | $\approx 0$ | $\approx 0$ | Good |
| Overconfident, correct median width | positive | small | W-shaped PIT |
| Overconservative, correct median width | negative | small | W-shaped PIT |
| Wrong median width | large magnitude | small | biased dispersion |
| Any shape mismatch (skew, heavy tails, $\kappa>0$) | $\approx 0$ | large | non-uniform PIT shape |
| Biased + mis-calibrated | depends | large | both issues present |

Practical recommendation: report **the pair**, not either alone. Use $D^*_{pit}$ for a
quick check of median-width correctness (immune to bias), then $U^*_{pit}$ for residual
shape diagnosis.

### Gaps / decisions

- **Q13:** Should the two-part diagnostic include a formal statistical test? The bootstrap
  studentisation work is documented in the significance-testing vignette but the paper
  says to use bootstrap. Does the paper include a bootstrap procedure?
  Ponytail: describe the bootstrap in words, point to the R implementation. Don't
  derive the bootstrap distribution analytically.

---

## 7. Related Work (target: ~1 page)

### Goal
A concise positioning paragraph (not a full literature review — that stays in the
design doc). Compare directly against the closest existing metrics.

### Content

| Method | Bias-adjusted? | Signed? | PIT-space? | Reference |
|--------|---------------|---------|------------|-----------|
| PIT histogram (visual) | No | Directional | Yes | Hamill (2001); Gneiting et al. (2007) |
| $W_1$(PIT, U) (Zhao et al.) | No | No | Yes | Zhao et al. (2020) |
| MCB / $D^*$ (Wessel et al.) | No | No | Yes | Wessel et al. (2025) |
| PIT-W (this paper) | **Yes** | **Yes** | Yes | **Challen, Palmer, Danon** |
| PCE (Kuleshov et al.) | No | No | Yes (binned) | Kuleshov et al. (2018) |
| ECE (Guo et al.) | No | No | Yes (binned) | Guo et al. (2017) |
| CRPS (proper score) | N/A | No | No (integral) | Gneiting & Raftery (2007) |

Key claim: $D^*_{pit}$/$U^*_{pit}$ are the **only** PIT-Wasserstein metrics that adjust
for bias **and** report direction.

### Gaps / decisions

- **Q14:** Is Gneiting & Resin (2023) MCB worth a table row? It's an alternative framework
  (score decomposition vs. distance), not directly comparable.
  Recommendation: mention in prose, not table.

---

## 8. Caveats and Future Work (target: ~0.5 page)

### Content

1. **Skewed predictive families:** Mean-based bias estimator fails for skewed families.
   Future: median-based estimator. (Pre-existing bug.)
2. **Heteroscedastic null:** With $\kappa_{\mathcal{S}} > 0$, the null variance of
   $D^*_{pit}$ depends on the PIT shape. Studentised bootstrap recommended.
3. **Small-sample correction:** $D^*_{pit}$ normal approximation over-rejects at $n < 50$.
   Edgeworth correction or exact tail needed.
4. **Non-parametric PIT:** The current metric assumes parametric predictive distributions
   (continuous CDF available). Discrete or mixed families need the functional PIT.
5. **Multivariate extension:** PIT is inherently univariate. Multivariate PIT or
   rank-based approaches are open.

---

## 9. Conclusion (target: ~0.5 page)

### Content

- Restate the contribution: bias-adjusted, signed PIT-Wasserstein metrics.
- Summarise the two main results: (a) analytical null of $D^*_{pit}$ is $N(0, 1/(48n))$;
  (b) $U^*_{pit}$ converges to the integrated absolute bridge.
- The two-part diagnostic is a practical tool for forecast evaluation.
- The code is in the `pitw` R package; the significance-testing vignette contains
  implementation details.

---

## Summary of Gaps and To-Dos

| # | Issue | Priority | Notes |
|---|-------|----------|-------|
| Q1 | Title + abstract | High | Blocker for drafting |
| Q2 | Journal target | High | Determines length/format |
| Q3 | Formal "dispersion calibration" definition | High | Needed in intro and methods |
| Q4 | Skewed families in Section 5 | Low | Caveat only |
| Q5 | Link function generality | Medium | Fix to $g=\log$ unless user decides otherwise |
| Q6 | Proof rigour for metrics section | Medium | Formal proof for Thm 1, sketch for others |
| Q7 | Mean vs median bias estimator | **High** | Paper currently uses mean; median is correct |
| Q8 | Double integral evaluation for $1/48$ | Medium | Show algebra or cite |
| Q9 | Reference for $\int|B^\circ|$ distribution | Medium | Takács is wrong; need bridge-specific source or table |
| Q10 | Edgeworth correction at small $n$ | Low | Caveat only |
| Q11 | Real-data example | **High** | SEIR+EpiEstim was discussed but not done |
| Q12 | Bootstrap procedure detail | Medium | Describe, don't derive |
| Q13 | Two-part diagnostic formal test | Medium | Refer to vignette |
| Q14 | Gneiting & Resin (2023) MCB in table | Low | Prose only |

---

## Mapping to Existing Tasks

The rewrite skeleton maps to these loom tasks:

| Task | Section(s) | Status |
|------|-----------|--------|
| `clarify-bias-adjusted-pit-diagnostic` | 2, 3 (terminology fix) | todo, blocks intro |
| `reframe-introduction-as-mathematical-methods-paper` | 1 | todo, blocked by above |
| `derive-analytical-null-distribution-for-pit-w-metrics` | 4 | todo |
| `update-figure-3-compare-unadjusted-vs-adjusted-pit-w` | 5 | todo |
| `characterise-d-pit-sampling-distribution-by-simulation` | 5 | todo, blocked by null derivation |
| `implement-bootstrap-test-for-dispersion-calibration` | 6, 8 | todo |
| `two-part-test-decomposition-d-then-u` | 6 | todo, blocked by null |
| `restore-pivotality-of-the-bias-adjustment` | 3 | todo, blocked by null |
| `add-real-worked-example` | 5/7 | todo |
| `mean-based-bias-estimator-fails-for-skewed-distributions` | 8 (caveat) | todo |
| `add-non-normal-distribution-robustness-study` | 5 | todo |
| `reframe-vignettes-as-supplementary-materials` | all | todo |

## What Needs User Decisions Before Drafting

1. **Journal target** — determines format (article length, structure, reference style).
2. **Title preference** — which of the three options, or a new one?
3. **Mean vs median bias estimator** — the paper currently uses mean; the correct fix
   is median. Should we switch the whole paper?
4. **Real-data example** — do we have one ready, or do we need to build the SEIR+EpiEstim
   example?
5. **Proof level** — formal proofs or simulation-supported sketches?
6. **$U^*_{pit}$ critical values** — find a reference for $\int|B^\circ|$ or tabulate from
   high-quality simulation?
