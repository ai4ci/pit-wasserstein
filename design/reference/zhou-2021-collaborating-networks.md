---
class: reference
id: zhou-2021-collaborating-networks.md
title: Estimating Uncertainty Intervals from Collaborating Networks
citeKey: Zhou_Li_Wu_Carlson_2021
year: 2021
zoteroKey: AHYZZ27J
citedIn:
- paper:refs.bib
---
Zhou, Li, Wu & Carlson (2021), *JMLR* 22(257):1–47.

A method paper, not a metric paper. Collaborating Networks (CN) fit two
networks with distinct losses, one approximating the conditional CDF and one
its inverse, with a consistency proof and a fixed point at the true
conditional distribution. Evaluation is by log-likelihood, MAE, empirical
coverage and interval width across synthetic and six real datasets, including
forecasting HbA1c from electronic health records.

Relevance is contextual: it is a representative example of the ML regression-UQ
literature that needs a calibration diagnostic and falls back on coverage at a
handful of nominal levels (70/90/95%) rather than a single PIT-based statistic,
because, as they put it, "the number of events to calibrate is virtually
indefinite".

**Why cite:** optional. Use as one of the application-side citations for
"calibration assessment in regression is currently ad hoc", or drop if space is
tight — it adds no metric that $D^*_{pit}$ must be compared against.