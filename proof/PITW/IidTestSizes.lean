/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.IidScores

/-! Marginal rejection probabilities of the three scores in the joint null limit. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval

namespace PITW

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

/-- An upper-tail cutoff for a continuous scalar function of jointly converging
scores has its limiting rejection probability if the cutoff carries no mass. -/
private theorem upperTail_size {S : ℕ → Ω → ℝ × ℝ × ℝ} {B : Ξ → ℝ × ℝ × ℝ}
    (h : TendstoInDistribution S atTop B (fun _ => P) Q)
    (f : ℝ × ℝ × ℝ → ℝ) (hf : Continuous f) (c : ℝ)
    (hc : Q.map (f ∘ B) {c} = 0) :
    Tendsto (fun n => P {ω | c < f (S n ω)}) atTop (𝓝 (Q {ξ | c < f (B ξ)})) := by
  apply rejection_probability_limit (h.continuous_comp hf) (R := Ioi c) measurableSet_Ioi
  simpa only [frontier_Ioi] using hc

/-- The third component of the joint sampling limit has a centred Gaussian law
with variance 1/48. Its absolute value has a continuous law at every cutoff. -/
private theorem directedTail_size {S : ℕ → Ω → ℝ × ℝ × ℝ}
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q)
    (h : TendstoInDistribution S atTop (bridgeScores ∘ brownianBridge W) (fun _ => P) Q)
    (c : ℝ) :
    Tendsto (fun n => P {ω | c < |(S n ω).2.2|}) atTop
      (𝓝 (gaussianReal 0 (1 / 48) {x | c < |x|})) := by
  apply directed_rejection_probability (h.continuous_comp (continuous_snd.comp continuous_snd))
  exact (Measure.map_congr (brownianBridge_area_ae hW)).trans (brownian_directed_law hW)


/-- Gaussian upper-tail formula used by the two-sided directed test. -/
theorem directed_normal_tail (c : ℝ) (hc : 0 ≤ c) :
    (gaussianReal 0 (1 / 48)).real {x | c < |x|} =
      2 * (1 - Φ (Real.sqrt 48 * c)) := by
  let μ := gaussianReal 0 1
  have : NullSingletonClass μ := nullSingletonClass_gaussianReal one_ne_zero
  have scale : μ.map (fun x : ℝ => x / Real.sqrt 48) = gaussianReal 0 (1 / 48) := by
    rw [gaussianReal_map_div_const]
    congr 1 <;> norm_num [Real.sq_sqrt]
    exact NNReal.eq rfl
  have hm : MeasurableSet {x : ℝ | c < |x|} := measurableSet_lt measurable_const measurable_id.abs
  rw [← scale, map_measureReal_apply (by fun_prop) hm]
  let a := Real.sqrt 48 * c
  have h48 : 0 < Real.sqrt 48 := by positivity
  have ha : 0 ≤ a := mul_nonneg h48.le hc
  have region : (fun x : ℝ => x / Real.sqrt 48) ⁻¹' {x | c < |x|} = Iio (-a) ∪ Ioi a := by
    ext x
    change c < |x / Real.sqrt 48| ↔ x < -a ∨ a < x
    rw [abs_div, abs_of_pos h48, lt_div_iff₀ h48, mul_comm c]
    change a < |x| ↔ _
    rw [lt_abs]
    grind
  have hd : Disjoint (Iio (-a)) (Ioi a) := Set.disjoint_left.mpr fun x hx hy => by
    exact (not_lt_of_ge (by linarith : -a ≤ a)) ((mem_Ioi.mp hy).trans (mem_Iio.mp hx))
  rw [region, measureReal_union hd measurableSet_Ioi,
    measureReal_congr (Iio_ae_eq_Iic (μ := μ)), ← compl_Iic,
    probReal_compl_eq_one_sub measurableSet_Iic, ← cdf_eq_real, ← cdf_eq_real]
  change Φ (-a) + (1 - Φ a) = _
  rw [normalCDF_neg]
  ring


variable (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
  (hz : ∀ j, HasLaw (Z j) (gaussianReal 0 1) P) (hi : iIndepFun Z P)
  (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q)
include hm hz hi hW

/-- Upper-tail rejection probability of the observed baseline score under the iid
normal null at any continuity cutoff for the absolute bridge area. -/
theorem iid_normal_baseline_test_size (c : ℝ)
    (hc : Q.map (fun ξ => ‖unitToL1 (brownianBridge W ξ)‖) {c} = 0) :
    Tendsto (fun n => P {ω | c < rankScale n *
      unsignedScore (fun i => Φ (orderedPIT Z (n + 1) ω i))}) atTop
      (𝓝 (Q {ξ | c < ‖unitToL1 (brownianBridge W ξ)‖})) := by
  exact upperTail_size (iid_sampling_limits Z hm hz hi W hW) _ continuous_fst c hc

/-- Upper-tail rejection probability of the fitted unsigned score at any
continuity cutoff for the median-adjusted absolute bridge area. -/
theorem iid_adjusted_test_size (c : ℝ)
    (hc : Q.map (fun ξ => ‖project medianProfile
      (unitToL1 (brownianBridge W ξ), brownianBridge W ξ unitHalf)‖) {c} = 0) :
    Tendsto (fun n => P {ω | c < rankScale n *
      unsignedScore (adjustedPIT n (orderedPIT Z (n + 1) ω))}) atTop
      (𝓝 (Q {ξ | c < ‖project medianProfile
        (unitToL1 (brownianBridge W ξ), brownianBridge W ξ unitHalf)‖})) := by
  exact upperTail_size (iid_sampling_limits Z hm hz hi W hW) _
    (continuous_fst.comp continuous_snd) c hc

/-- Two-sided rejection probability for the observed fitted directed score.
The limiting Gaussian tail applies at every cutoff. -/
theorem iid_directed_test_size (c : ℝ) :
    Tendsto (fun n => P {ω | c < |rankScale n *
      directedScore (adjustedPIT n (orderedPIT Z (n + 1) ω))|}) atTop
      (𝓝 (gaussianReal 0 (1 / 48) {x | c < |x|})) := by
  exact directedTail_size W hW (iid_sampling_limits Z hm hz hi W hW) c

/-- At a nonnegative cutoff the asymptotic directed rejection probability is
twice the standard normal upper tail beyond the standardised cutoff. -/
theorem iid_directed_test_size_cdf (c : ℝ) (hc : 0 ≤ c) :
    Tendsto (fun n => P.real {ω | c < |rankScale n *
      directedScore (adjustedPIT n (orderedPIT Z (n + 1) ω))|}) atTop
      (𝓝 (2 * (1 - Φ (Real.sqrt 48 * c)))) := by
  rw [← directed_normal_tail c hc]
  exact (ENNReal.tendsto_toReal (measure_ne_top _ _)).comp
    (iid_directed_test_size Z hm hz hi W hW c)

end PITW
