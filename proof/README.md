# Lean proofs of the PIT significance tests

Under independent uniform probability integral transforms (PITs), the baseline midpoint score multiplied by the square root of the sample size converges in distribution to the absolute area of a standard Brownian bridge. For independent standard normal scores, Lean also proves the joint limiting law of the baseline, median-adjusted unsigned and median-adjusted directed statistics. The fitted scores use the sample median on the normal scale. These are the limits used in the [manuscript](../vignettes/main/main.tex).

| Observed statistic | Limit of the statistic multiplied by $\sqrt N$ | Rejection probability checked in Lean |
| --- | --- | --- |
| Baseline unsigned | $\int_0^1 \lvert B(t)\rvert\,dt$ | Upper tail at any cutoff with zero point mass under the limit |
| Fitted unsigned | $\int_0^1 \lvert B(t)-B(1/2)g(t)\rvert\,dt$ | Upper tail under the same continuity condition for the fitted reference |
| Fitted directed | $N(0,1/48)$ | Two-sided tail $2[1-\Phi(\sqrt{48}\,c)]$ for every $c\geq0$ |

Here $B$ is the same bridge in all three limits and $g(t)=\varphi(\Phi^{-1}(t))/\varphi(0)$ on the interior of the unit interval. Independence and uniformity of the raw PITs suffice for the baseline test. In the manuscript's common-scale Gaussian location model, standardisation gives the normal scores used in the fitted tests. Adding the same constant to all normal scores leaves both fitted statistics unchanged for every sample. The baseline null assumes the original PITs are uniform. [Baseline.lean](PITW/Baseline.lean) · [IidScores.lean](PITW/IidScores.lean) · [IidTestSizes.lean](PITW/IidTestSizes.lean)

## Building and inspecting the proofs

Run `lake build` from the repository root, or `lake -d .. build` from this directory. The root `lean-toolchain` and `lake-manifest.json` pin Lean and its dependencies.

To use the library from another Lake project, add the following to its `lakefile.toml`, using a Git revision that contains the root Lake configuration.

```toml
[[require]]
name = "pit-wasserstein"
git = "https://github.com/ai4ci/pit-wasserstein.git"
rev = "<commit>"
```

Run `lake update` in the consuming project. The following declarations expose the null assumptions, observed statistics and reference laws.

```lean
import PITW

#check PITW.iid_baseline_test_size
#check PITW.iid_rank_path_median_limit
#check PITW.iid_normalMedian_limit
#check PITW.iid_sampling_limits
#check PITW.iid_adjusted_test_size
#check PITW.iid_directed_test_size_cdf
#print axioms PITW.iid_sampling_limits
```

## From the observations to the tests

1. At any finite collection of PIT thresholds, the centred empirical counts converge jointly to bridge evaluations. The expected absolute increment between thresholds $s\leq t$ is bounded by $\sqrt{t-s}$ uniformly in sample size. This controls grid approximation in $L^1[0,1]$ and gives the joint limit of the empirical CDF path and the count at one half. [EmpiricalGrid.lean](PITW/EmpiricalGrid.lean) · [EmpiricalPath.lean](PITW/EmpiricalPath.lean)
2. Counting the observations below a moving threshold gives the fluctuation of each central order statistic. When $N$ is even the package averages the two central normal scores before applying the PIT. For either parity the scaled median has limit $-B(1/2)/\varphi(0)$, with distribution $N(0,\pi/2)$. Applying the same argument at interior ranks and integrating the error establishes the joint limit of the ordered midpoint discrepancy path and the median. [IidMedian.lean](PITW/IidMedian.lean) · [IidRankPath.lean](PITW/IidRankPath.lean)
3. Subtracting the fitted median shifts the threshold in the empirical CDF. Its first-order contribution is $-B(1/2)g(t)$. Lean controls the integrated remainder in probability although the shift is estimated from the same observations. For every sorted finite row, the scaled fitted scores differ from their respective fitted CDF integrals by at most $1/(2\sqrt N)$. [FittedApproximation.lean](PITW/FittedApproximation.lean) · [AdjustedScores.lean](PITW/AdjustedScores.lean)
4. The profile $g$ is symmetric around one half, so its contribution to the signed area cancels. Integrating the covariance of the pinned Brownian bridge gives variance $1/48$ for the remaining signed area. The three score limits follow from the same sample and the same bridge. [UnitScores.lean](PITW/UnitScores.lean) · [BrownianBridge.lean](PITW/BrownianBridge.lean) · [IidScores.lean](PITW/IidScores.lean)

## Scope of the verification

The rejection results concern the limit as the number of independent observations increases. Evaluation of the Johnson–Killeen and Takács formulas, simulation and tail extrapolation for the fitted unsigned reference, the package's tabulated critical values and their finite-sample accuracy remain outside the formal verification. The [alternative rank approximation proof](PITW/RankLimits.lean) is also available for samples supplied with a uniform bridge approximation.
