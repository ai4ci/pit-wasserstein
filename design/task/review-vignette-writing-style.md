---
class: task
id: review-vignette-writing-style.md
title: Review the six vignettes for an applied scientific audience
status: done
kind: chore
priority: medium
---

<!-- loom:links start -->
### Backlinks
- spawns: [Add a getting-started vignette and review the vignette series](../plan/vignette-guide-and-editorial-review.md)
<!-- loom:links end -->

## Audience and editing priorities

Assume readers can interpret intervals, regression and simulation results. Define PIT, the forecast scale and the comparison group where they enter. Give each vignette a practical question and make the first paragraph answer why that question arises. In results prose, give the measured comparison with its units or scenario, then explain what it supports. Retain the equations and simulation settings as reference material. Use one term throughout for predictive uncertainty that varies independently of the error, and explain it before using “spread–error decoupling”.

The suggested wording below is editorial. The content notes identify claims that need technical review before their surrounding paragraphs are rewritten.

## PIT histograms and calibration

Source lines 27–47, 104–120, 170–182 and 215–233. [Introduction to PIT](../../vignettes/introduction-to-pit.Rmd)

- **Major.** Replace the opener “This vignette is an informal introduction” with the data and the reader’s task. For example, write “We compare 100 predictive distributions with the same reference value. Their medians show how far the forecasts are centred from that value, and their intervals show how much uncertainty the forecaster reports.” Give each panel its role after that statement.
- **Minor.** Replace “All three failures above can be seen at once, with a trick” with “For each observation, evaluate the predictive cumulative distribution at its observed value. The result is the probability integral transform (PIT).” Keep the histogram table, and name its rows as patterns illustrated by the simulations. Replace the descriptions of the forecaster as “honest” or “needlessly vague” with statements about its median and interval width.

Content note. The descriptions “the shape of the departure says which failure you have” and “flat | calibrated” overstate what the figure and a finite-sample histogram establish. Check those against the [diagnostic interpretation issue](qualify-vignette-diagnostic-interpretation.md).

## The three PIT-Wasserstein scores

Source lines 28–43, 45–105, 139–175 and 385–435. [PIT-Wasserstein metrics](../../vignettes/pit-w-metrics.Rmd)

- **Major.** Replace “real forecasters do not come with their miscalibration written on the label” with “We simulated sets of forecasts with known location bias and predictive spread. We then compared the three PIT-Wasserstein scores with CRPS and interval coverage.” Keep the parameter table, distinguish values drawn per estimator from values drawn per prediction, and lead with the scale ratio readers need to interpret the plots.
- **Minor.** Replace “This is the central claim of the paper made as a picture” with the panel finding. For example, write “After the location adjustment, the association with bias seen for the baseline score is absent in this simulation. The adjusted score is lowest near a spread ratio of one.” Follow with the remaining variation and the factor associated with it.

Content note. Reconcile the CRPS panel letter, the finite-sample distance definition and the explanation of the signed score before editing the score definitions. [Metrics exposition issue](correct-metrics-vignette-interpretation.md)

## EpiEstim on simulated epidemics

Source lines 27–48, 104–123, 145–160, 280–303 and 323–354. [EpiEstim example](../../vignettes/sir-epiestim-example.Rmd)

- **Major.** Replace the opener about a method “somebody else wrote” with “We used EpiEstim to estimate the instantaneous reproduction number from simulated case counts. The model gives us a reference value of $R_t$ for each day, which allows us to assess the reported uncertainty.” Then describe what was varied, what was held fixed and why peak observed case counts are on the x-axis.
- **Minor.** Replace “independently locating the same sweet spot” with “The directed score crossed zero at a peak of about 56 observed cases (panel C). The undirected score reached its minimum at about 47 cases (panel D).” Keep the interpretation of negative and positive scores. Present the prior and lag as possible explanations for bias.

Content note. Put the dependence of the seven-day rolling estimates beside the comparison that uses reference distributions. The current numerical interpretation also uses the baseline reference mean for the adjusted score. [EpiEstim inference issue](check-epiestim-vignette-inference.md)

## Significance testing

Source lines 26–44, 155–189, 331–360, 585–609 and 611–656. [Significance testing](../../vignettes/significance-testing.Rmd)

- **Major.** Move a short version of “In practice” and the assumptions ahead of the derivation. Replace “these are Kolmogorov–Smirnov tests with a different norm” with “Each test compares a PIT-Wasserstein score with the values expected under its reference model. These comparisons use large-sample approximations and assume independent forecasts.” Put the empirical CDF comparison, Brownian bridge and Airy-function series after the example so readers can see when they need each result.
- **Minor.** Replace “What happens geometrically is that the adjustment removes one direction from the limiting bridge” as the first explanation of the adjusted reference with “We estimate the location shift from the same forecasts that we score. In the common-scale Gaussian model, the resulting reference distribution for the adjusted score accounts for this estimate.” The mathematical description can then follow.

Content notes. The statement that the baseline test returns an “exact” p-value conflicts with its use of a large-sample reference. Extend the existing [reference approximations issue](clarify-pit-test-reference-approximations.md) to cover this passage. The interpretation table also needs a check against pure spread misspecification. [Diagnostic interpretation issue](qualify-vignette-diagnostic-interpretation.md)

## Sample size and power

Source lines 28–47, 166–192 and 217–234, 332–364. [Sample size and power](../../vignettes/sample-sizes-and-power.Rmd)

- **Major.** Replace “how many predictions do you need before a test can see anything?” with “We compared the scores at 10, 100 and 1,000 predictions per estimator, then varied sample size across four prespecified scenarios.” Retain the design table. Lead each results paragraph with the scenario and comparison that the panel supports.
- **Major.** Replace “Ten predictions is not enough to diagnose anything but a gross failure” with “At 10 predictions, the simulated groups overlapped and most of the boxes lay below the rejection thresholds. The groups were more clearly separated at 100 predictions in this design.” State any planning guidance in terms of the departure the reader cares about and the number of independent predictions.

Content note. Fix the description of Figure 2’s layout, and distinguish a median crossing the threshold from the proportion of replicates that reject. [Power exposition issue](correct-power-vignette-interpretation.md)

## Predictive distribution shape

Source lines 25–49, 149–169, 208–240 and 269–300. [Model misspecification](../../vignettes/model-misspecification.Rmd)

- **Major.** Replace “what happens when it is the right size but the wrong shape?” with “We matched the median and coefficient of variation of the predictive distributions and varied the distributional family. This lets us examine how the scores respond to the resulting differences in shape.” This gives readers a definition of what was held fixed before introducing “misspecification” or the parameter notation.
- **Minor.** Replace “This is an honest negative result and worth stating plainly” and the surrounding verdict with “In these simulations, tail-weight differences produced a pattern of scores similar to that from changing the reported width.” Keep the observed comparison close to the plotted quantities. Replace “Does the bias adjustment survive asymmetry?” with “Bias adjustment with skewed errors”.

Content notes. The results paragraph gives a positive directed score and then explains the same comparison as conservative. Check the sign and the direction of the comparison against the simulation output. The diagnostic table also needs claims scoped to the scenarios shown. [Metrics exposition issue](correct-metrics-vignette-interpretation.md) · [Diagnostic interpretation issue](qualify-vignette-diagnostic-interpretation.md)
