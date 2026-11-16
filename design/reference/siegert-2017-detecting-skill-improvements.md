---
class: reference
id: siegert-2017-detecting-skill-improvements.md
title: 'Detecting improvements in forecast correlation skill: Statistical testing and power analysis'
citeKey: Siegert_Bellprat_Ménégoz_Stephenson_Doblas-Reyes_2017
year: 2017
zoteroKey: 5XLBRWBN
citedIn:
- paper:refs.bib
---
Siegert, Bellprat, Ménégoz, Stephenson & Doblas-Reyes (2017), *Monthly Weather
Review* / Univ. of Exeter repository copy.

About comparing two forecasting systems, not about calibration. Their point is
that the widely used test for a difference in correlation skill is wrong
because it assumes the competing systems are independent, when in practice
"the competing forecasting systems are strongly correlated with one another"
(same model at different resolution, same initialisation, a nested benchmark).
They review tests valid under dependence and add a power analysis giving the
sample size needed to detect a given improvement — concluding that seasonal
hindcasts need about 40 years for adequate power.

Directly analogous to the open question for this paper: when $D^*_{pit}$ is
compared between two models fitted to the *same* data, the two statistics are
strongly dependent, so any test of "model A is better calibrated than model B"
must be paired, and the simulation study should report the sample size at which
a given difference in $D^*_{pit}$ becomes detectable.

**Why cite:** methodological precedent for the power/sample-size framing of
metric comparisons. Cite as an analogy — it concerns correlation skill, not
calibration — or use it to justify a power analysis in the simulation section.