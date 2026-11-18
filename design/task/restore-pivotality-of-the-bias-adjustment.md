---
class: task
id: restore-pivotality-of-the-bias-adjustment.md
title: 'Settle the bias adjustment: x-space kept, PIT-space ruled out'
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
produces:
- resource:fig3-metric-compare.pdf
---
The analytical results in
`task:derive-analytical-null-distribution-for-pit-w-metrics.md` hold for
**unadjusted** PIT values. The bias adjustment breaks them, and this needs
resolving before any closed-form test can be claimed for $D^*_{pit}$ as the
paper currently defines it.

## The problem

$u_{i,adj}$ is computed after subtracting a bias $\hat{\mathcal{E}}$ estimated
from the *same sample* (`src:scoring.R#pit_w`, `link_bias`). Expanding:

$$u_{i,adj} \approx u_i - \hat{\mathcal{E}}\,f_i(F_i^{-1}(u_i)), \qquad \sqrt{n}\hat{\mathcal{E}}=O_p(1)$$

so the limit process becomes $B^\circ(p) - W h(p)$ with $h(p)=f(F^{-1}(p))$;
for Gaussian predictions $h=\varphi\circ\Phi^{-1}$. This is Durbin's
estimated-parameter problem — the same reason **Lilliefors $\neq$ KS**.

Consequences: the null is no longer distribution-free (it depends on the
predictive family, the link, and via the varying $\sigma_i$ on
$\kappa_\mathcal{S}$), and estimating one parameter makes the adjusted
statistic stochastically *smaller*, so the unadjusted critical values would
be anti-conservative.

## Three options, increasing elegance

1. **Parametric bootstrap per family** — what
   `task:implement-bootstrap-test-for-dispersion-calibration.md` already
   assumes. Works, no closed form, needs a table per
   (dist, link, $\kappa_\mathcal{S}$).
2. **Analytic one-dof correction** — for the Gaussian case $h=\varphi\circ\Phi^{-1}$
   is explicit and $\int h^2$, $\int h\,s$ are elementary, giving a corrected
   closed-form variance for $D^*_{pit}$.
3. **Redefine the adjustment in PIT space** — centre the PIT values directly
   (subtract $\bar u - \tfrac12$) instead of shifting on the link scale. Then
   $h\equiv 1$ regardless of family and the limit
   $\int_0^1|B^\circ(p)-\int_0^1 B^\circ|\,dp$ is **distribution-free again**:
   one universal table, genuine closed-form null.

Option 3 is the interesting one — a small change to the metric's definition
that buys back an exact, family-independent null. Investigate whether it
behaves as well as the link-scale adjustment on the existing simulation
sweep (bias-invariance, symmetry on log-calibration, the properties claimed
in `main.tex:219`). If it does, it may be worth adopting as *the*
definition.

Note this interacts with
`task:add-non-normal-distribution-robustness-study.md`: the link-scale
median-based adjustment's robustness to skew is exactly what option 3 would
trade away (or improve on) — test both together.

## Refinement 2026-11-13: the adjustment should be a function of the $u_i$ alone

The user correctly objected that the additive form $u_i-\bar u+0.5$ sketched
above leaves $(0,1)$ and needs clipping, and proposed a logit-space
(odds-ratio style) adjustment instead. Working this through sharpened the
proposal considerably. **The general principle is not "logit" but: any
adjustment that is a function of the $u_i$ alone** — no $X_i$, no $F_i$, no
link, no $\sigma_i$ — leaves the null distribution-free, because the $u_i$
are iid $U(0,1)$ under $H_0$ whatever the predictive distributions were.

Candidate transforms, with $v_i = T^{-1}(T(u_i) - \overline{T(u)})$:

| $T$ | $h(p)=\frac{d}{dz}T^{-1}$ | Exact when predictive family is |
|---|---|---|
| logit | $p(1-p)$ | logistic |
| probit $\Phi^{-1}$ | $\varphi(\Phi^{-1}(p))$ | Gaussian |

Both keep $v_i \in (0,1)$ by construction (monotone bijections), so the
CDF interpretation is preserved — this is what the additive sketch got
wrong.

### Numerical findings (in-session, 4k-20k replicates, $n$=200 unless noted)

**Both transforms preserve the $D^*_{pit}$ null exactly.** $h$ is symmetric
about $\tfrac12$ in both cases while the sign weight is antisymmetric, so
$\int_0^1 \operatorname{sgn}(0.5-p)h(p)dp = 0$ and the perturbation is
orthogonal to the directed statistic at first order. Confirmed:
$n\cdot\mathrm{Var}(D^*_{pit})$ = 0.0206 / 0.0212 / 0.0208 at $n$ = 25 / 100 /
400 after logit adjustment, against $1/48=0.02083$ — i.e. **the closed-form
$N(0,1/(48n))$ test survives the bias adjustment**.

**Probit is clearly better than logit for bias-invariance.** Mean $U^*_{pit}$
against increasing true bias (0, 0.25, 0.5, 1) at $\kappa=0$:
- probit: 0.0151, 0.0151, 0.0151, 0.0152 — flat, i.e. exactly bias-invariant.
- logit: 0.0157, 0.0168, 0.0201, 0.0327 — drifts.
- unadjusted, for reference: 0.0222, 0.0704, 0.138, 0.260.

The logit version's drift also wrecks the directed test's size (4.9% at zero
bias rising to 36.5% at bias 1), so logit is not viable as-is. Probit matches
the Gaussian predictive family the paper uses and is the recommended choice.

**No link function is needed.** A PIT-space adjustment is automatically
invariant to any monotone reparametrisation of $x$, because $u_i$ has already
absorbed it. Verified: a lognormal/log-link estimator reproduces the
Gaussian/identity numbers to 3 s.f. (0.0152/0.0150/0.0150 vs
0.0151/0.0151/0.0152 across bias 0/0.5/1). This removes the \`link\` argument
from \`pit_w()\` entirely — it cannot be mis-specified if it does not exist.

**Residual limitation is heteroscedasticity, not skew.** With $\kappa=0.5$
*and* bias 1, probit drifts (0.0152 → 0.0241). A common shift in probit units
shifts $x$ by $\delta\sigma_i$ (heterogeneous in $x$), whereas the current
link-scale implementation shifts $x$ by a constant. Which is the correct
definition under varying $\sigma_i$ is genuinely open, and is the one place
the two candidate definitions meaningfully differ — worth settling
deliberately rather than by accident of implementation.

### Recommendation to evaluate

Adopt $v_i = \Phi(\Phi^{-1}(u_i) - \overline{\Phi^{-1}(u)})$ as the
definition. Gains: distribution-free null (so the closed-form $D^*$ test and
a single universal $U^*$ table both apply), no link argument, exact
bias-invariance for homoscedastic predictions, invariance to monotone
reparametrisation for free. Costs: exact invariance degrades under combined
heteroscedasticity and large bias; and it is a change to the published
definition of the metric, so the existing bias-invariance and
log-calibration-symmetry claims (\`main.tex:219\`) must be re-verified under
the new definition before adopting.

All numbers above are from quick in-session simulation and should be
reproduced in a vignette before being cited in the paper.

## Correction 2026-11-13: centre on the median, not the mean

The user reported two practical failures of the mean-centred probit
adjustment proposed above, both confirmed numerically in-session. **Both are
fixed by centring on the median instead of the mean, and the transform stays
probit.**

### Failure 1: infinities (fatal as originally specified)

$\Phi^{-1}(u_i)$ is $\pm\infty$ whenever $u_i$ underflows to exactly 0 or 1,
which is routine — `pnorm(-40)` is exactly 0 in double precision. One
infinity destroys a mean. Measured failure rate of the mean-centred shift
($n=200$, 2000 reps, Gaussian estimator):

| bias | $\sigma$ | % values at bound | mean centring fails | median centring fails |
|---|---|---|---|---|
| 1 | 0.15 | 1.25% | **91.6%** | 0% |
| 2 | 0.15 | 0.06% | **12.0%** | 0% |
| 4 | 0.15 | 3.80% | **99.8%** | 0% |
| 6 | 0.15 | 59.1% | 100% | 99.5% |
| 1-6 | 0.5, 1.0 | 0% | 0% | 0% |

Just 1.25% of values at a bound breaks the mean in 92% of runs — matching the
user's report that it "fails to calculate a bias in a significant number of
cases". The median only fails once >50% of values are pinned at one bound,
i.e. for an estimator that is catastrophically wrong anyway.

By monotone equivariance $\mathrm{median}(\Phi^{-1}(u)) = \Phi^{-1}(\tilde u)$,
so the shift depends only on the median PIT and the infinities never enter
it. Individual infinite $z_i$ map back to the boundary by limit
($u_i=1 \Rightarrow v_i=1$), which is correct and needs only explicit
handling of the `NaN` from $\infty-c$.

### Failure 2: outlier sensitivity

A mean in probit space has breakdown point 0 — the user's concern that
"outliers would have a very strong effect on the overall bias adjustment" is
exactly right, and is the same defect as failure 1 in continuous form. The
median has breakdown 50%. This is also consistent with existing practice:
`pit_w()` already uses prediction *medians* for the x-space bias.

### The median-centred probit adjustment

$$v_i = \Phi\!\left(\Phi^{-1}(u_i) - \Phi^{-1}(\tilde u)\right), \qquad \tilde u = \mathrm{median}(u_i)$$

equivalently **"shift so that the median PIT is $\tfrac12$"**. Measured at
$n=200$, 4000 reps, Gaussian estimator, true dispersion calibration 1:

| bias | 0 | 0.25 | 0.5 | 1 | 2 |
|---|---|---|---|---|---|
| $\mathbb{E}U^*$ median-probit | 0.0166 | 0.0167 | 0.0165 | 0.0166 | 0.0167 |
| $\mathbb{E}U^*$ median-logit | 0.0163 | 0.0168 | 0.0181 | 0.0247 | 0.0550 |

Probit is flat to 3 s.f. out to bias 2 (exactly bias-invariant); logit still
drifts 3-fold, confirming that the transform must match the predictive family
and that logit is not the right member of the family here.

The analytical results survive: $n\cdot\mathrm{Var}(D^*_{pit})$ = 0.0200,
0.0213, 0.0203, 0.0209, 0.0206 across those biases against $1/48=0.02083$,
and the closed-form test holds nominal size (4.5%, 5.3%, 5.0%, 5.2%, 4.7%).

Note $\mathbb{E}U^*$ at $H_0$ is 0.0166 for median centring vs 0.0151 for
mean centring — the median is a less efficient centring statistic, so slightly
less is absorbed. Harmless, but it means **the $U^*$ critical value table is
specific to the centring statistic** and must be generated for whichever is
adopted.

`qnorm(log.p = TRUE)` is then an optional precision refinement rather than a
necessary mitigation: extreme $u_i$ map to the boundary by limit, and $U^*$
depends only on their rank position, so precision loss there does not move
the statistic.

### Still open

The heteroscedasticity drift noted above ($\kappa=0.5$ with large bias) was
measured under mean centring and should be re-measured under median
centring before the definition is settled.

## Resolution 2026-11-13: drop the PIT-space adjustment; keep the x-space one

The user observed a small loss of symmetry in `resource:fig3-metric-compare.pdf`
under the probit adjustment. Investigated and explained; the conclusion
**reverses the recommendation above**.

### The symmetry is a theorem, so the asymmetry had to come from the adjustment

With no bias and constant $\sigma$, the probit-transformed PITs are exactly
$z_i \sim N(0,s)$ with $s=\sigma_E/\sigma_S = 1/c$, so the PIT CDF is
$F_s(p) = \Phi(\Phi^{-1}(p)/s)$ and

$$F_{1/s}(p) = \Phi(s\Phi^{-1}(p)) = F_s^{-1}(p)$$

Inverting a monotone function reflects its graph in the diagonal, preserving
the area between graph and diagonal, so $\int_0^1|F_s(p)-p|\,dp$ is **exactly**
symmetric under $c \leftrightarrow 1/c$. The log-calibration symmetry claimed
at `main.tex:219` is therefore a theorem for the unadjusted metric, not an
empirical accident — worth stating as such in the paper.

### Measured source: heteroscedasticity, not bias

Reproducing the fig. 3 configuration (bias $\sim U(-1,1)$, $\kappa \sim U(0,2)$,
comparing $c=2$ against $c=0.5$):

| adjustment | asymmetry gap | as % of level |
|---|---|---|
| x-space mean (current implementation) | 0.0013 | **1.5%** |
| probit, mean-centred | -0.0551 | **-46%** |
| probit, median-centred | -0.0127 | **-14%** |

At $\kappa=0$ the x-space and probit median adjustments are *identical*
(measured gap 0.000120 for both) — with constant $\sigma$ a common shift in
$x$ is a common shift in probit space. The divergence is entirely driven by
$\kappa$.

**Cause.** Bias is a location error in $x$-space. The x-space shift $\delta$
becomes a *heterogeneous* $\delta/\sigma_i$ in probit space, which is correct.
A single common shift in probit space over-corrects confident predictions
(small $\sigma_i$) and under-corrects uncertain ones.

### The resulting impossibility statement

An adjustment that is a function of the $u_i$ alone cannot know the
$\sigma_i$. Therefore **distribution-freeness of the null and exact
bias-invariance under heteroscedasticity cannot both hold.** Since
heteroscedasticity is central to this paper ($\kappa_\mathcal{S}$ is the
colour axis of fig. 3) and bias-invariance is the headline property, the
x-space (link-scale) adjustment should be **kept as the definition** and the
PIT-space proposal dropped.

This is worth stating explicitly in the paper — it justifies the design
choice rather than leaving it looking arbitrary.

### What this costs, and what it does not

Measured null behaviour of $D^*_{pit}$ under the *existing* x-space
adjustment ($H_0$: $c=1$; 6000 reps):

| $n$ | bias | $\kappa$ | $n\mathrm{Var}(D^*)$ | size |
|---|---|---|---|---|
| 100 | 0 | 0 | 0.0206 | 5.1% |
| 100 | 1 | 0 | 0.0210 | 5.1% |
| 400 | 1 | 0 | 0.0215 | 5.6% |
| 100 | 1 | 0.5 | 0.0242 | 7.2% |
| 400 | 0 | 2 | 0.0332 | 12.2% |

against $1/48 = 0.0208$. **The closed-form test survives bias exactly** — this
is the important result, since bias-invariance is what the metric is for. The
inflation under $\kappa$ does not shrink with $n$, so it is asymptotic, not
small-sample.

### That inflation is power, not size distortion

$\kappa>0$ with correct *median* dispersion is **not** a calibrated
estimator. A scale mixture of normals is heavy-tailed, so some predictions
are overconfident and others underconfident, and the PIT is non-uniform.
Measured at $c=1$, $n=5000$:

| $\kappa$ | 0 | 0.25 | 0.5 | 1 | 2 |
|---|---|---|---|---|---|
| $\mathbb{E}U^*$ (unadjusted) | 0.0043 | 0.0057 | 0.0115 | 0.0254 | 0.0412 |
| tail mass $u<0.05$ or $>0.95$ (uniform: 0.100) | 0.0998 | 0.116 | 0.147 | 0.200 | 0.253 |
| KS $p$ vs uniform | 0.09 | 0.08 | 2e-3 | 8e-16 | 8e-34 |

So the null hypothesis must be stated as **"the PIT values are iid uniform"**,
which in the simulation family means $c=1$ *and* $\kappa=0$. Under that
correctly-stated $H_0$ the $N(0,1/(48n))$ result holds, with or without bias.

This is arguably a positive result worth foregrounding: the metric treats
*inconsistent confidence* ($\kappa>0$) as miscalibration, which is the
behaviour you want — an estimator whose stated uncertainty is unreliable
prediction-to-prediction is not well calibrated however good its average
dispersion is.

### Actions

- Keep the current x-space bias adjustment; do not adopt PIT-space.
- State the log-calibration symmetry as a theorem with the $F_{1/s}=F_s^{-1}$
  proof.
- State $H_0$ as PIT uniformity, and note explicitly that $\kappa>0$ is an
  alternative, not a null case.
- The $U^*$ critical values and the $D^*$ closed form both apply under that
  $H_0$; the family-dependence concern that motivated the PIT-space detour
  applies to the *adjusted* statistic and still needs quantifying for
  non-Gaussian families — but bias alone does not break it.
  
## Update 2026/11/16

PIT space probit adjustment is a non default option in the code. Not deleted for future investigation

Left open as we need to decide where to document this.
