---
class: reference
id: wessel-2025-tail-calibration.md
title: Enforcing tail calibration when training probabilistic forecast models
citeKey: wessel2025
year: 2025
doi: 10.48550/arXiv.2506.13687
citedIn:
- paper:refs.bib
---
Wessel, Schillinger, Kwasniok & Allen (2025), arXiv:2506.13687.

Defines the **miscalibration component (MCB)**:

$$MCB = \frac{1}{n}\sum_{i=1}^n |\hat{u}_{(i)} - \frac{i-0.5}{n}|$$

This is **exactly** the formula for $D^*_{pit}$ **without** the bias-adjustment
step. They use it as a regularisation term in the loss function during model
training, to nudge forecasts toward calibration, not as an evaluative metric.
They do not discuss bias adjustment, a signed/directional version, or its
properties as a standalone metric.

**Why cite:** the closest existing metric. MCB is $D^*_{pit}$ without the bias
adjustment, so this is where the novelty claim has to be argued.


**Cross-reference (added during the Zotero review):** two things qualify this
record. (1) Zhao, Ma & Ermon (2020) already define the same Wasserstein-1
distance from the PIT distribution to the uniform, as a per-input training
objective, so this is not the only prior construction of the unadjusted
quantity. (2) The name MCB collides with Gneiting & Resin (2023), where MCB is
the miscalibration component of a score decomposition — a different object. The
paper should not write "MCB" without saying whose.