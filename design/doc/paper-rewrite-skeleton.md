---
class: doc
id: paper-rewrite-skeleton.md
title: Paper rewrite skeleton — narrative structure, arguments, gaps
---
This is the original planning outline. The [reviewed manuscript](../../vignettes/main/main.tex) is the current account of the methods and results. Section 7 below records the revised EpiEstim design. The earlier section targets and drafting questions elsewhere in this outline are historical. For outstanding decisions use the [task index](INDEX.md).

---

## 0. Title (working)

**Options under discussion:**

1. _"Bias-adjusted PIT-Wasserstein metrics for dispersion calibration"_
   — precise, but long.
2. _"Signed Wasserstein distances on PIT values for diagnosing dispersion miscalibration"_
   — emphasises the signed direction and PIT space.
3. _"PIT-Wasserstein: a bias-adjusted, directional metric for dispersion calibration"_
   — compact, introduces the name.

Detection and diagnosis of miscalibrated probabilistic estimators with PIT-Wasserstein.
Detection and diagnosis of miscalibration with PIT-Wasserstein metrics.

   
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
| 4 | Wasserstein-1 distance from the PIT distribution to uniform ($W_1$) is a **quantified**, constructive scalar measure, but existing work (Zhao et al. 2020; Wessel et al. 2025) reports it **without a null distribution** — so it can rank forecasters but cannot say whether any of them is calibrated. | Zhao et al. (2020); Wessel et al. (2025) |
| 5 | That statistic also conflates a location error with a dispersion error. Adjusting for a location shift separates them — but the adjustment estimates a parameter, so it changes the null. Both halves need stating together. | — |
| 6 | **Contributions:** (a) the exact null distribution of the PIT-Wasserstein statistic, making the *existing* metric testable; (b) a bias-adjusted variant isolating dispersion calibration, with its own (different) null; (c) a signed variant giving the direction of a dispersion error, whose null is unaffected by the adjustment; (d) the observation that these are three nested hypotheses about one forecaster, giving a diagnostic sequence; (e) validation on simulation and on an external estimator where a proper score ranks the forecaster the opposite way. | — |

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

## 3. The Metrics: a family of three (target: ~2 pages)

### Goal
Define the three metrics as **one statistic applied to two different inputs**,
and establish that they correspond to three nested hypotheses about the same
forecaster. This is the reframing agreed 2026-11-17 and it replaces the earlier
"the unadjusted metric is hard to interpret, here is a better one" framing,
which was both weak and, next to CRPS, indefensible.

### Content

#### 3.1. One statistic

For PIT values $u_i$ with order statistics $u_{(i)}$ and $r_i = (2i-1)/2n$,

$$
W(u) = \frac{1}{n}\sum_{i=1}^n \left| r_i - u_{(i)} \right|
$$

is the $W_1$ distance between the empirical PIT distribution and $U(0,1)$.
This is Zhao et al.'s statistic and we claim no novelty for it.

#### 3.2. Two inputs

The bias adjustment estimates a single link-scale location shift
$\hat{\delta} = \mathrm{median}_i\left(g(m_i) - g(x_i)\right)$ and applies it to
the observations before the PIT transform. It is monotone, so it preserves
ranks (see caveat in §3.5).

- $B_{pit} = W(u)$ on the raw PIT values — the **baseline** metric.
- $U_{pit} = W(u^{adj})$ on the adjusted PIT values.

#### 3.3. And a signed variant

$$
D_{pit} = \frac{1}{n}\sum_{i=1}^n \left(r_i - u^{adj}_{(i)}\right)\mathrm{sgn}(0.5 - r_i)
$$

Range $[-0.25, 0.25]$. Positive = overconfident, negative = overconservative,
zero = median width correct. $B_{pit}, U_{pit} \in [0, 0.5]$.

#### 3.4. Original proposal for nested hypotheses (superseded)

The reviewed manuscript uses marginal tests based on shared observations. Their rejection patterns do not uniquely identify causes. The following was the initial proposal.

**This is the contribution.** The metrics are not competitors; they test
progressively weaker nulls about the same forecaster.

| Metric | $H_0$ | Rejects when |
|---|---|---|
| $B_{pit}$ | PIT values are i.i.d. $U(0,1)$ | anything is wrong |
| $D_{pit}$ | dispersion correct, **location arbitrary** | the predictive width is wrong, with a direction |
| $U_{pit}$ | shape correct, **location arbitrary** | skew, tails, or mixed dispersion errors survive the adjustment |

Read as a sequence this is a diagnosis, not three tests:

| $B_{pit}$ | $D_{pit}$ | $U_{pit}$ | Reading |
|---|---|---|---|
| not rej. | — | — | calibrated |
| rejected | not rej. | not rej. | pure location error |
| rejected | rejected | not rej. | dispersion error, direction from $\mathrm{sgn}(D_{pit})$ |
| rejected | not rej. | rejected | shape error at the right width |
| rejected | rejected | rejected | both |

Nobody else can form this sequence, because nobody else has nulls for the
statistic — Zhao et al. and Wessel et al. report the distance and stop.

#### 3.5. Properties

- **Theorem 1 (Location invariance of $D_{pit}$):** $D_{pit}$ is orthogonal to
  a common link-scale shift; its null is unchanged by the adjustment. See §4.4
  — this is what makes the adjustment *free* for $D_{pit}$.
- **Theorem 2 (Symmetry under inversion):** for homoscedastic normal
  predictive families $U_{pit}(c) = U_{pit}(1/c)$ exactly, via
  $F_{1/c}(p) = F_c^{-1}(p)$.
- **Theorem 3 (Signed decomposition):** $D_{pit}$ is the difference and
  $U_{pit}$ the sum of the overconfident and overconservative masses — an
  algebraic identity, no proof needed.

### Gaps / decisions

- **Q6:** Proof level. Ponytail: formal for Theorem 1 (it carries §4.4),
  simulation-supported for Theorem 2, identity for Theorem 3.
- **Q7:** ~~Mean vs median bias estimator~~ — **resolved**: median, in the
  link scale. Both code and paper.
- **Q15:** The adjustment is rank-preserving per prediction, but under
  heteroscedasticity an $x$-space shift moves $u_i$ by $\approx b\varphi/\sigma_i$,
  which differs across $i$, so the *ordering* can change. This matters for
  which rank vector $B_{pit}$ is computed against — see
  `task:b-pit-computed-against-adjusted-ranks.md`. State the definition of
  $B_{pit}$ as being on its own order statistics and make sure the code agrees.

---

## 4. The null distributions

The [independent-prediction plan](../plan/dispersion-calibration-significance-test.md) records the scope adopted in the manuscript. The baseline limit requires independent uniform PITs. The fitted limits below assume a common-scale Gaussian location model. Earlier conjectures of pivotality under arbitrary families or heterogeneous scales were superseded.

### Content

#### 4.1. Reduction to the Brownian bridge

All three are functionals of the empirical quantile process
$q_n(p) = \sqrt{n}(F_n^{-1}(p) - p) \Rightarrow -B^\circ(p)$. Everything below
is a continuous-mapping-theorem step from there.

#### 4.2. $B_{pit}$ — the integrated absolute bridge

$$
\sqrt{n}\,B_{pit} \Rightarrow \int_0^1 |B^\circ(t)|\,dt
$$

Mean $\sqrt{2\pi}/8 \approx 0.3133$. **The c.d.f. is explicit**, from
Johnson & Killeen (1983):

$$
P(L \le \ell) = \sqrt{\pi/2}\sum_{j\ge1}\delta_j^{-3/2}\,\psi(\ell/\delta_j^{3/2}),
\quad \psi(t) = 3^{2/3}t^{-1/3}e^{-2/(27t^2)}Ai\!\left((3t)^{-4/3}\right)
$$

with $\delta_j = |a'_j|/2^{1/3}$ and $a'_j$ the $j$th zero of $Ai'$. Giving
$q_{0.95} = 0.5821/\sqrt{n}$ and $q_{0.99} = 0.7519/\sqrt{n}$. Note this is a
*bridge* result; Takács (1993) is Brownian motion and does not apply.

#### 4.3. $D_{pit}$ — closed-form Gaussian

A **linear** functional, hence exactly Gaussian:

$$
\sqrt{n}\,D_{pit} \Rightarrow \int_0^1 \mathrm{sgn}(0.5-t)B^\circ(t)\,dt \sim N(0, 1/48)
$$

$$
\sigma^2 = \iint \mathrm{sgn}(0.5-s)\mathrm{sgn}(0.5-t)(s\wedge t - st)\,ds\,dt = \frac{1}{48}
$$

Practical 5% test: $|D_{pit}| > 0.2829/\sqrt{n}$. Empirical size 8.1% at
$n=10$, 5.3% at $n=100$, 5.1% at $n=400$; mildly anti-conservative below
$n \approx 50$.

#### 4.4. $U_{pit}$ — the bridge with one direction removed

The adjustment estimates a parameter from the same data, so the null is **not**
§4.2's. With $\kappa(t) = \varphi(\Phi^{-1}(t))/\varphi(0)$ the sensitivity of
the PIT values to the shift, and the median centring pinning the bridge at
$t = 1/2$,

$$
\sqrt{n}\,U_{pit} \Rightarrow \int_0^1 \left| B^\circ(t) - \kappa(t)B^\circ(\tfrac12)\right| dt
$$

Verified against the finite-sample statistic at $n = 400$: limit process mean
0.2345 and $q_{0.95}$ 0.3791, finite sample 0.236 and 0.382. Still
distribution-free — the ratio of the adjusted to the baseline 5% critical
value is a stable **0.65–0.67** across $n \in \{25, 76, 400\}$ and across
$\kappa_\mathcal{S} \in \{0, 0.5\}$.

**This is the Kolmogorov–Smirnov to Lilliefors step** and it should be named
as such: same statistic, one estimated parameter, a different and strictly
smaller null. Using §4.2's critical value for $U_{pit}$ is badly conservative
(at $n=76$, $U_{pit} = 0.05$ gives $p = 0.165$ against the wrong null and
$p = 0.022$ against the right one).

No published c.d.f.; currently evaluated by simulating the limit process —
`task:derive-cdf-of-the-adjusted-u-pit-null.md`.

#### 4.5. The asymmetry: the adjustment is free for $D_{pit}$, costly for $U_{pit}$

$n\mathrm{Var}(D_{pit}) = 1/48$ with **or without** the adjustment, because
$D_{pit}$ is already orthogonal to a location shift. $U_{pit}$ pays the full
estimated-parameter price. Worth stating as a result in its own right: it
explains why $D_{pit}$ is the sharper instrument of the two and why the
adjustment is not a free lunch in general.

#### 4.6. What the nulls assume

The references assume independent predictions. Section 7 supplies one independent estimate per series within each window setting. The three tests use the same observations and provide marginal significance levels only. Their fitted references assume the common-scale Gaussian location model described in the manuscript.

### Gaps / decisions

- **Q8:** Show the $1/48$ double integral in full, or state it? Recommendation:
  show the setup, give the three lines of algebra.
- **Q9:** ~~Critical values for the undirected metric~~ — **resolved**:
  Johnson & Killeen (1983) for $B_{pit}$; $U_{pit}$ pending Q16.
- **Q10:** Edgeworth correction for $D_{pit}$ at small $n$? Ponytail: no, note
  as a caveat.
- **Q16:** Does $U_{pit}$'s limit get a formula, a citation, or a shipped
  high-precision table? A table with a stated accuracy is honest and must not
  block the paper.

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

#### 5.5. Small-sample behaviour and test size

- Convergence of $\sqrt{n}\,B_{pit}$, $\sqrt{n}\,U_{pit}$ and $\sqrt{n}\,D_{pit}$
  across $n = 25, 50, 100, 400$ against the three limits of §4.
- **Empirical size of all three tests** at nominal 5%, under calibrated but
  heteroscedastic predictions. At $n = 76$, 3000 replicates: $B_{pit}$ 5.8%,
  $U_{pit}$ 4.7%, $D_{pit}$ 6.3%. (The $B_{pit}$ figure should come back to
  5.0% once `task:b-pit-computed-against-adjusted-ranks.md` is fixed; the
  $D_{pit}$ figure is the documented small-$n$ normal approximation.)
- The 0.66 ratio between the $U_{pit}$ and $B_{pit}$ critical values, shown to
  be stable in $n$ and in $\kappa_\mathcal{S}$ — the evidence that the adjusted
  null is still distribution-free.

### Gaps / decisions

- **Q11:** Should this section include the skewed-family example (gamma) showing the mean-
  bias defect?
  Recommendation: yes, but as a **caveat box** or footnote, not a main result. File as a
  pre-existing bug.
- **Q12:** What is the real-world example?
  **Status: DONE.** Built as `vignette:sir-epiestim-example.Rmd`, producing
  `resource:fig4-epiestim-by-epi-size.pdf`. It is now its own Section 7 below. The
  SEIR framing was simplified to a deterministic SIR ODE, and the low-vs-high
  prevalence contrast was replaced by a continuous sweep over epidemic size,
  which is strictly stronger: it shows a sign change rather than two points.

---

## 6. Original proposal for a three-part diagnostic (superseded)

The current interpretation treats the scores as complementary summaries and reports marginal rejection rates under specified alternatives. This historical section records the earlier proposed sequence.

### Goal
Show the three tests working as one diagnostic procedure. §3.4 states the
nesting; this section shows what each combination of outcomes looks like in
practice and how to read a PIT histogram off it.

### Content

| Scenario | $B_{pit}$ | $D_{pit}$ | $U_{pit}$ | PIT shape |
|---|---|---|---|---|
| Calibrated | not rej. | not rej. | not rej. | flat |
| Pure location error | **rejected** | not rej. | not rej. | skewed |
| Overconfident | rejected | **positive** | **rejected** | U-shaped |
| Overconservative | rejected | **negative** | **rejected** | dome |
| Shape mismatch (skew, tails, $\kappa > 0$) | often misses | not rej. | **rejected** | W-shaped |
| Location + dispersion error | rejected | rejected | rejected | skewed + shaped |

Rejection rates at $n = 200$, nominal 5%, confirm this (see the
significance-testing vignette). Two rows are easy to get wrong and should be
stated explicitly in the paper:

- A genuine **dispersion error moves $U_{pit}$ as well as $D_{pit}$** —
  $U_{pit}$ is undirected and accumulates any departure. What distinguishes a
  width error from a shape error is not whether $U_{pit}$ fires but whether
  $D_{pit}$ fires alongside it.
- For spread–error decoupling the **adjusted test is the more powerful one**:
  $U_{pit}$ rejects 69% of the time where $B_{pit}$ manages 19%. Paying for a
  tighter null buys power. This is a good argument for the family framing and
  should not be buried.

Practical recommendation: **report all three with their p values**. $B_{pit}$
answers "is this forecaster calibrated", which is the question most readers
actually have; $D_{pit}$ and $U_{pit}$ answer "and if not, what is wrong with
it". The pair $(D_{pit}, U_{pit})$ alone cannot distinguish a calibrated
forecaster from one with a pure location error, because the adjustment removes
exactly that.

Note the critical values differ: at the same $n$, $B_{pit}$'s 5% threshold is
$0.5821/\sqrt{n}$ and $U_{pit}$'s is $\approx 0.66$ of that. Do not compare the
two statistics' magnitudes directly; compare their p values.

### Gaps / decisions

- **Q13:** ~~Does the paper include a bootstrap procedure?~~ — **resolved**:
  no. All three tests are analytical (§4); the bootstrap is superseded, see
  `task:implement-bootstrap-test-for-dispersion-calibration.md`.
- **Q17:** Multiplicity. The three statistics share the same PIT values and
  are dependent. Present as a read-down from a single rejection, or offer a
  corrected procedure? Ponytail: read-down, stated plainly, no correction —
  a correction would imply an independence the section explicitly denies.

---

## 7. EpiEstim across epidemic sizes and estimation windows

The fourth manuscript figure comes from the [EpiEstim vignette](../../vignettes/sir-epiestim-example.Rmd). The experiment uses a deterministic SIR trajectory with $R_t=2 S_t$, where $S_t$ is the susceptible proportion. At each of 100 population sizes (316–100,000), binomial ascertainment at probability 0.5 generates 100 independent series of counts. A series contributes exactly one endpoint, shared across the five window settings. This gives 10,000 series, 50,000 estimates and 500 score groups. Each score uses 100 independent estimates.

The endpoint index is drawn uniformly from 40 to 75. Window labels 2, 4, 7, 10 and 14 give the difference between the end and start indices. EpiEstim includes both endpoints. The current join evaluates the truth on the simulation day numbered with the endpoint index, one day after the last observation. The [window and reference-day issue](../task/confirm-epiestim-window-and-reference-day.md) records the manuscript decision.

The serial interval and prior both have standard deviation 5, with means 5 days and 2 respectively. Each fitted posterior mean and standard deviation specify a gamma distribution. For each population and window we fit a common median shift on the log scale. All five settings share the maximum observed daily count over the 100 series as their horizontal coordinate.

Figure 4 shows mean predictive-median bias, baseline PIT distance, directed score and adjusted unsigned distance. The directed score tends to move from negative to positive as counts rise, with a different crossing for each window. The baseline threshold uses independent uniform PITs. The two fitted thresholds give common-scale Gaussian benchmarks for the gamma estimates. The vignette also gives mean CRPS and central 50% coverage before and after adjustment. The earlier rolling-window counts, correlations and coverage estimates have been superseded. Serial-dependence inference belongs to a [future plan](../plan/serially-dependent-forecasts.md).

---

## 8. Related Work (target: ~1 page)

### Goal
A concise positioning paragraph (not a full literature review — that stays in the
design doc). Compare directly against the closest existing metrics.

### Content

| Method | Null distribution? | Bias-adjusted? | Signed? | Reference |
|--------|---------------|---------|------------|-----------|
| PIT histogram (visual) | No | No | Directional | Hamill (2001); Gneiting et al. (2007) |
| $W_1$(PIT, U) (Zhao et al.) | No | No | No | Zhao et al. (2020) |
| MCB (Wessel et al.) | No | No | No | Wessel et al. (2025) |
| PCE (Kuleshov et al.) | No | No | No | Kuleshov et al. (2018) |
| ECE (Guo et al.) | No | No | No | Guo et al. (2017) |
| CRPS (proper score) | N/A | N/A | No | Gneiting & Raftery (2007) |
| $B_{pit}$ (this paper) | **Exact** | No, by design | No | **Challen, Palmer, Danon** |
| $D_{pit}$ (this paper) | **Exact** | **Yes** | **Yes** | **Challen, Palmer, Danon** |
| $U_{pit}$ (this paper) | **Yes** | **Yes** | No | **Challen, Palmer, Danon** |

Two claims, and note that the first is the bigger one:

1. **Nobody has a null distribution for the PIT-Wasserstein statistic.** Zhao
   et al. and Wessel et al. report the distance and leave the reader to judge
   whether it is large. $B_{pit}$ is their statistic with a p value attached;
   that alone is a contribution, and it is the reason the family can be nested.
2. $D_{pit}$/$U_{pit}$ are the only PIT-Wasserstein metrics that adjust for a
   location error, and $D_{pit}$ is the only one that reports a direction.

Say explicitly that the unadjusted metric is **not** a flawed predecessor. It
is the omnibus test, and as a bounded distance with a known null and a p value
it is *more* interpretable than a proper score, which is unbounded, in the
units of the outcome, and meaningful only relative to another forecaster. The
adjustment partitions total miscalibration into location and the rest; it does
not repair anything.

### Gaps / decisions

- **Q14:** Is Gneiting & Resin (2023) MCB worth a table row? It's an alternative framework
  (score decomposition vs. distance), not directly comparable.
  Recommendation: mention in prose, not table.

---

## 9. Limitations and future work

The paper uses one fitted median shift on the chosen link scale and assumes independent predictions for inference. A common shift can obscure subgroup differences, and the fitted reference distributions were derived for common-scale Gaussian errors. The simulation intervals are credible intervals for a continuous univariate target.

- [Serially dependent forecasts](../plan/serially-dependent-forecasts.md) concerns repeated predictions from the same time series. The current paper uses independent series.
- [Multivariate copula calibration](../plan/multivariate-copula-calibration.md) concerns dependence among outcomes in one joint forecast.
- [Prediction distribution inputs](../plan/prediction-distribution-inputs.md) covers posterior draws, supplied quantiles and separation of PIT construction from scoring.
- The [supporting-materials task](../task/online-supporting-materials.md) brings the article, package and formal proof links together.

---

## 10. Conclusion (target: ~0.5 page)

### Content

- Restate the contribution: bias-adjusted, signed PIT-Wasserstein metrics.
- Summarise the two main results: (a) analytical null of $D^*_{pit}$ is $N(0, 1/(48n))$;
  (b) $U^*_{pit}$ converges to the integrated absolute bridge.
- The two-part diagnostic is a practical tool for forecast evaluation.
- The code is in the `pitw` R package; the significance-testing vignette contains
  implementation details.

---

## Subsequent decisions

The manuscript uses the JMLR preprint style and the median link-scale adjustment. Figures 1–3 cover metric behaviour and sampling variability. Figure 4 applies the scores to EpiEstim. The [paper plan](../plan/paper-rewrite.md) links completed work and the decisions outstanding after author review. The [formalisation plan](../plan/formalise-significance-tests.md) records the scope of the Lean verification. The analytic distribution or higher-precision tabulation for the fitted unsigned reference remains a separate [open task](../task/derive-cdf-of-the-adjusted-u-pit-null.md).