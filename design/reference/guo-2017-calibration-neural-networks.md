---
class: reference
id: guo-2017-calibration-neural-networks.md
title: On Calibration of Modern Neural Networks
citeKey: guo2017
year: 2017
zoteroKey: 94XTKHM9
citedIn:
- paper:refs.bib
---
Guo, Pleiss, Sun & Weinberger (2017), *ICML* 34:1321–1330.

The paper that popularised the **Expected Calibration Error (ECE)** and
temperature scaling. ECE approximates
$\mathbb{E}_{\hat{P}}\left[\,\left|\,\mathbb{P}(\hat{Y}=Y \mid \hat{P}=p) - p\,\right|\,\right]$
by partitioning predictions into $M$ equally spaced confidence bins and
averaging $|\mathrm{acc}(B_m) - \mathrm{conf}(B_m)|$ weighted by bin size.

Strictly a **classification** result: confidence calibration of a predicted
class probability, not PIT uniformity of a predictive distribution over a
continuous outcome. Its relevance is as the metric the ML literature reaches
for by default, and as the cautionary example: ECE depends on an arbitrary
binning, is biased for small bins, and is unsigned — exactly the three
properties $D^*_{pit}$ avoids (no binning, bias-adjusted, signed).

**Why cite:** the standard ML calibration metric and the standard criticism of
it; also the paper Zhao et al. (2020) and Dheur & Ben Taieb (2023) both
position against.