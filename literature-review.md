# Literature Review: PIT-Based Calibration Metrics

## Collected in Zotero collection: `pit-wasserstein`

### How the adjusted PIT-Wasserstein ($D^*_{pit}$) relates to existing work

```
                  PIT uniformity assessment
                              |
            ┌─────────────────┼─────────────────┐
            |                 |                 |
       Visual PIT      Formal testing      Quantified metrics
       (histogram)     (KS test, AD test)        |
            |                 |              ┌───┴───┐
      Hamill 2001      scoringutils      PCE / sup-norm   Wasserstein / L1
      Gneiting 2007    (Bosse 2024)     (Kuleshov 2018)        |
                                                             ┌──┴──┐
                                                         Raw PIT   Bias-adjusted PIT
                                                             |          |
                                                     Wessel 2025    $D^*_{pit}$ ← THIS
                                                     Wilks 2018  (Challen & Danon)
```

### 1. Wessel, Schillinger, Kwasniok & Allen (2025)
**"Enforcing tail calibration when training probabilistic forecast models"**
arXiv:2506.13687

**Their MCB (Miscalibration Component):**
$$MCB = \frac{1}{n}\sum_{i=1}^n |\hat{u}_{(i)} - \frac{i-0.5}{n}|$$

This is **exactly** the same formula as $D^*_{pit}$ **without** the bias-adjustment step. They use it as a regularisation term in the loss function during model training (to nudge forecasts toward calibration), not as an evaluative metric. They don't discuss bias adjustment, direction (signed version), or its properties as a standalone metric.

### 2. Wilks (2018)
**"Enforcing calibration in ensemble postprocessing"**
QJRMS, 144:76–88

First to propose penalising PIT deviation from uniform as part of a loss function. Uses a binned chi-squared style measure rather than Wasserstein distance. Conceptual precursor to both Wessel's MCB and your $D^*_{pit}$.

### 3. Kuleshov, Fenner & Ermon (2018)
**"Accurate Uncertainties for Deep Learning Using Calibrated Regression"**
ICML 2018

Introduces **Probabilistic Calibration Error (PCE)**:
$$PCE = \sum_{j=1}^m w_j |\hat{p}_j - p_j|$$
where bins $p_j$ partition [0,1] and $\hat{p}_j$ is the empirical proportion of observations falling below quantile $p_j$.
- **Sup-norm style** (Kolmogorov-Smirnov), not L1/Wasserstein
- Binned, not exact
- No bias adjustment
- Widely adopted in ML calibration literature

### 4. Dheur & Ben Taieb (2023)
**"A Large-Scale Study of Probabilistic Calibration in Neural Network Regression"**
ICML 2023

Large empirical study using PCE. Standardises how calibration is evaluated in NN regression. References Kuleshov's PCE definition.

### 5. Gneiting, Balabdaoui & Raftery (2007)
**"Probabilistic Forecasts, Calibration and Sharpness"**
JRSS-B, 69:243–268

The canonical paper establishing the PIT histogram as the primary diagnostic for checking calibration. Also defines probabilistic, exceedance, and marginal calibration. Introduces the **maximise sharpness subject to calibration** paradigm.

### 6. Hamill (2001)
**"Interpretation of Rank Histograms for Verifying Ensemble Forecasts"**
MWR, 129:550–560

Origin of rank histograms (discrete version of PIT histograms) for ensemble weather forecasts. Shows that flat histograms are necessary but not sufficient for reliability.

### 7. Brockwell (2007)
**"Universal residuals: A multivariate transformation"**
Statistics & Probability Letters

Formalises PIT as a generalised residual for arbitrary probability models. Useful for goodness-of-fit testing.

### 8. Arrieta-Ibarra et al. (2022)
**"Metrics of Calibration for Probabilistic Predictions"**
JMLR, 23:1–54

Comprehensive survey of calibration metrics, focusing on reliability diagrams and bin-based measures. Does not use Wasserstein distance.

### 9. Podsztavek et al. (2024)
**"Automatic Miscalibration Diagnosis: Interpreting PIT Histograms"**
ESANN 2024

Uses ML to classify PIT histogram shapes into categories (U-shaped, dome, skewed) — automatic pattern recognition rather than a unified quantitative metric.

### 10. Bosse et al. (2024)
**"Evaluating Forecasts with scoringutils in R"**
arXiv:2205.07090

The scoringutils package implements PIT diagnostics including the Anderson-Darling test for uniformity. No Wasserstein-based calibration metric is provided.

### 11. Panaretos & Zemel (2019)
**"Statistical Aspects of Wasserstein Distances"**
Annual Review of Statistics and Its Application, 6:405–431

Comprehensive technical review of Wasserstein distances, their properties, and statistical applications. Provides the theoretical foundation for using W1 distance on PIT values.

---

## Key references for the standalone paper

| What to cite | Why |
|--------------|-----|
| Gneiting et al. (2007) | Canonical PIT/calibration framework |
| Hamill (2001) | PIT histogram origins |
| Panaretos & Zemel (2019) | Wasserstein distance theory |
| Wessel et al. (2025) | Closest existing metric (MCB = $D^*_{pit}$ without bias adj.) |
| Wilks (2018) | First PIT-uniformity penalty |
| Kuleshov et al. (2018) | PCE — the main competing calibration metric |
| Dheur & Taieb (2023) | Large-scale PCE study |
| Bosse et al. (2024) | scoringutils — current standard R tooling |
