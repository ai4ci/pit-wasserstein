---
class: task
id: prove-joint-pit-quantile-and-median-limit.md
title: Derive the joint PIT quantile and median limit from iid sampling
kind: feature
status: done
priority: high
touches:
- paper:main.tex
- proof:PITW/Baseline.lean
- proof:PITW/EmpiricalGrid.lean
- proof:PITW/SampleMedian.lean
- proof:PITW/RankLimits.lean
- proof:PITW/OrderRanks.lean
- proof:PITW/Spacings.lean
- proof:PITW/IidMedian.lean
- proof:PITW/MedianReference.lean
- proof:PITW/EmpiricalPath.lean
- proof:PITW/QuantileInversion.lean
- proof:PITW/FittedCDF.lean
- proof:PITW/FittedApproximation.lean
- proof:PITW/AdjustedScores.lean
- proof:PITW/UnitScores.lean
- proof:PITW/ScoreApproximation.lean
- proof:PITW/IidScores.lean
- proof:PITW/IidTestSizes.lean
- proof:PITW/QuantilePath.lean
- proof:PITW/IidQuantilePoint.lean
- proof:PITW/IntegratedConvergence.lean
- proof:PITW/IidRankPath.lean
- proof:PITW/ExponentialSpacings.lean
---

<!-- loom:links start -->
- touches: [main.tex](../../vignettes/main/main.tex)
- touches: [PITW/AdjustedScores.lean](../../proof/PITW/AdjustedScores.lean)
- touches: [PITW/Baseline.lean](../../proof/PITW/Baseline.lean)
- touches: [PITW/EmpiricalGrid.lean](../../proof/PITW/EmpiricalGrid.lean)
- touches: [PITW/EmpiricalPath.lean](../../proof/PITW/EmpiricalPath.lean)
- touches: [PITW/ExponentialSpacings.lean](../../proof/PITW/ExponentialSpacings.lean)
- touches: [PITW/FittedApproximation.lean](../../proof/PITW/FittedApproximation.lean)
- touches: [PITW/FittedCDF.lean](../../proof/PITW/FittedCDF.lean)
- touches: [PITW/IidMedian.lean](../../proof/PITW/IidMedian.lean)
- touches: [PITW/IidQuantilePoint.lean](../../proof/PITW/IidQuantilePoint.lean)
- touches: [PITW/IidRankPath.lean](../../proof/PITW/IidRankPath.lean)
- touches: [PITW/IidScores.lean](../../proof/PITW/IidScores.lean)
- touches: [PITW/IidTestSizes.lean](../../proof/PITW/IidTestSizes.lean)
- touches: [PITW/IntegratedConvergence.lean](../../proof/PITW/IntegratedConvergence.lean)
- touches: [PITW/MedianReference.lean](../../proof/PITW/MedianReference.lean)
- touches: [PITW/OrderRanks.lean](../../proof/PITW/OrderRanks.lean)
- touches: [PITW/QuantileInversion.lean](../../proof/PITW/QuantileInversion.lean)
- touches: [PITW/QuantilePath.lean](../../proof/PITW/QuantilePath.lean)
- touches: [PITW/RankLimits.lean](../../proof/PITW/RankLimits.lean)
- touches: [PITW/SampleMedian.lean](../../proof/PITW/SampleMedian.lean)
- touches: [PITW/ScoreApproximation.lean](../../proof/PITW/ScoreApproximation.lean)
- touches: [PITW/Spacings.lean](../../proof/PITW/Spacings.lean)
- touches: [PITW/UnitScores.lean](../../proof/PITW/UnitScores.lean)

### Backlinks
- spawns: [Formalise the PIT significance test derivations in Lean](../plan/formalise-significance-tests.md)
<!-- loom:links end -->

For independent uniform PITs, construct the ordered sample and prove joint convergence of its scaled midpoint discrepancy in L¹ and its median coordinate. In the common-scale Gaussian location model use the actual normal-scale sample median (including the even-sample convention), establish the vanishing remainder in probability, and apply the score limits to those samples.

Lean proves that the ordered midpoint discrepancy path and the empirical CDF fluctuation differ by a vanishing L¹ error under independent uniform sampling (iid_rank_path_error). The scaled normal-scale median and the ordered PIT path converge jointly to −B(1/2)/φ(0) and the same Brownian bridge, respectively (iid_rank_path_median_limit). The median marginal is N(0, π/2). Both central order statistics enter the proof for even samples.

For the three statistics, the proof translates the median adjustment into a shift of the empirical CDF threshold and controls its integrated remainder. The three observed scores then converge jointly under independent standard normal sampling (iid_sampling_limits). The baseline and fitted unsigned upper-tail statements require a continuity cutoff. For the two-sided directed score the limiting rejection probability is 2[1 − Φ(√48 c)] at any nonnegative cutoff (iid_directed_test_size_cdf). Adding a common constant to the normal scores leaves the fitted PITs unchanged for every finite row (adjustedPIT_ordered_add).

The Brownian motion in the theorem supplies the reference law on a separate probability space. The results require no coupling between it and the sample. Numerical evaluation of the unsigned reference distributions and finite-sample accuracy are outside these results.
