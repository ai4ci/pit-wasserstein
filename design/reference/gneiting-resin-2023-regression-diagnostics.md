---
class: reference
id: gneiting-resin-2023-regression-diagnostics.md
title: 'Regression Diagnostics meets Forecast Evaluation: Conditional Calibration, Reliability Diagrams, and Coefficient of Determination'
citeKey: gneiting2023
year: 2023
doi: 10.1214/23-EJS2180
zoteroKey: F7673UKG
citedIn:
- paper:refs.bib
---
Gneiting & Resin (2023), *Electronic Journal of Statistics* 17(2):3226–3286.

The modern reference treatment of calibration hierarchies. Defines the PIT with
the randomised correction for non-continuous CDFs,

$$Z_F = F(Y-) + U\,(F(Y) - F(Y-)),$$

distinguishes auto-calibration from the weaker, unconditional
*probabilistic calibration* ($Z_F \sim U(0,1)$) that $D^*_{pit}$ measures, and
introduces $T$-calibration and CORP reliability diagrams estimated by isotonic
regression / the pool-adjacent-violators algorithm. It revisits the score
decomposition

$$\bar{S} = \mathrm{MCB} - \mathrm{DSC} + \mathrm{UNC}$$

into miscalibration, discrimination and uncertainty, and proposes the universal
coefficient of determination $R^* = (\mathrm{DSC} - \mathrm{MCB})/\mathrm{UNC}$.

Two things matter for this paper:

1. **The dominant "miscalibration measure" in the literature is a score
   decomposition component, not a distance between the PIT distribution and the
   uniform.** MCB here is the score lost to miscalibration under isotonic
   recalibration — a different object from $D^*_{pit}$, which needs no
   recalibration fit and has an interpretable unit (mean probability
   displacement).
2. **The name MCB is overloaded.** Wessel et al. (2025) use MCB for the mean
   absolute PIT–uniform deviation, which *is* $D^*_{pit}$ without the bias
   adjustment. The paper should not use "MCB" unqualified.

**Why cite:** places $D^*_{pit}$ in the calibration hierarchy (probabilistic,
not auto-calibration), and is the comparator for "why not just use the score
decomposition".