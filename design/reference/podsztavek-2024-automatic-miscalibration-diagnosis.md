---
class: reference
id: podsztavek-2024-automatic-miscalibration-diagnosis.md
title: 'Automatic Miscalibration Diagnosis: Interpreting Probability Integral Transform (PIT) Histograms'
citeKey: podsztavek2024
year: 2024
zoteroKey: 4JYD3Y9W
citedIn:
- paper:refs.bib
---
Podsztavek, Jordan, Tvrdík & Polsterer (2024), *ESANN 2024*:137–142.

Proposes an automatic interpreter for PIT histograms using a mixture density
network (MDN). The approach:

- **Synthetic training set**: generates PIT histograms from pairs of predictive
  CDFs $F_i^{(j)}$ and data-generating CDFs $G_i^{(j)}$ by sampling
  $y_i^{(j)} \sim G_i^{(j)}$ and computing $p_i^{(j)} = F_i^{(j)}(y_i^{(j)})$.
- **MDN interpreter**: given a PIT histogram, the network outputs the estimated
  data-generating distribution (as a mixture of normals). The loss combines a
  Monte Carlo approximation to the 1-Wasserstein distance between true and
  estimated $G$.
- **Experiments**: trained on normal-family synthetic data, tested on UCI
  regression datasets (Year Prediction MSD, Protein Tertiary Structure, Combined
  Cycle Power Plant). The interpreter correctly identified causes: unimodal
  predictive used for bimodal data (synthetic inverse problem), skewness
  mis-specification (Year dataset).
- **Scoring rules**: NLL and CRPS used to confirm improvement after diagnosing
  miscalibration (Table 1: MDN vs DN improvements on NLL and CRPS).

The PIT is translation- and scale-invariant, so the MDN trained on synthetic data
generalises across different distributions.

**Why cite:** ML-based PIT interpretation contrasts with our scalar, theory-based
approach ($D^*_{pit}$, $U^*_{pit}$). The paper shows that visual PIT
interpretation is non-trivial even for experienced users — a scalar metric with
signed direction would complement this.
