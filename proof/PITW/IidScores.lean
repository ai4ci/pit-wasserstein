/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.FittedApproximation
public import PITW.ScoreApproximation

/-! Joint null law of the three observed scores under independent sampling. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

private lemma score_difference_vanishes {S T : ℕ → Ω → ℝ × ℝ × ℝ} {e : ℕ → Ω → ℝ}
    (bound : ∀ n ω, ‖S n ω - T n ω‖ ≤ (1 / 2) / rankScale n + e n ω)
    (he : TendstoInMeasure P e atTop 0) : TendstoInMeasure P (S - T) atTop 0 := by
  rw [tendstoInMeasure_iff_measureReal_norm] at he ⊢
  intro ε hε
  have he' := he (ε / 2) (half_pos hε)
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] at he'
  simp only [Pi.zero_apply, sub_zero, Pi.sub_apply]
  apply squeeze_zero' (Eventually.of_forall fun n => measureReal_nonneg) _ he'
  filter_upwards [(rankScale_atTop.const_div_atTop (1 / 2 : ℝ)).eventually_lt_const (half_pos hε)]
    with n hn
  apply measureReal_mono _ (measure_ne_top _ _)
  intro ω hω
  change ε ≤ ‖S n ω - T n ω‖ at hω
  change ε / 2 ≤ |e n ω|
  have h := bound n ω
  have hab := le_abs_self (e n ω)
  change (1 / 2) / rankScale n < ε / 2 at hn
  linarith

private lemma ideal_score_limit (U : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (U j))
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution (fun n ω => unitScores
      (empiricalPath U (n + 1) ω, empiricalAt U (n + 1) unitHalf ω)) atTop
      (fun ξ => bridgeScores (brownianBridge W ξ)) (fun _ => P) Q := by
  have h := (iid_empirical_path_eval_limit U hm hu hi W hW unitHalf).continuous_comp
    unitScores_continuous
  have eqLimit : (unitScores ∘ (fun ξ => (ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ),
      brownianBridge W ξ unitHalf))) = (fun ξ => bridgeScores (brownianBridge W ξ)) :=
    funext fun ξ => unitScores_bridge _
  rw [eqLimit] at h
  exact ⟨fun n => h.forall_aemeasurable (n + 1), h.aemeasurable_limit,
    h.tendsto.comp (tendsto_add_atTop_nat 1)⟩

/-- The observed baseline, fitted unsigned and fitted directed scores converge jointly
under the iid standard normal null. The fitted shift is the sample median on the
normal scale, including the average of the two central observations for even samples. -/
theorem iid_sampling_limits (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hz : ∀ j, HasLaw (Z j) (gaussianReal 0 1) P) (hi : iIndepFun Z P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution (fun n ω => sampleScores n (orderedPIT Z (n + 1) ω)) atTop
      (fun ξ => bridgeScores (brownianBridge W ξ)) (fun _ => P) Q := by
  let U := fun j => Φ ∘ Z j
  have hU j : Measurable (U j) := normalCDF_strictMono.monotone.measurable.comp (hm j)
  have hu j := stdNormal_pit_law (hz j)
  have hind : iIndepFun U P := hi.comp _ (fun _ => normalCDF_strictMono.monotone.measurable)
  apply tendstoInDistribution_of_tendstoInMeasure_sub _ _ (ideal_score_limit U hU hu hind W hW)
    (score_difference_vanishes (iid_score_error_bound Z) (iid_fitted_path_error Z hm hu hind))
  intro n
  exact ((sampleScores_measurable n).comp
    (Measurable.of_eval fun i => measurable_orderedPIT hm _ i)).aemeasurable

omit [MeasurableSpace Ω] in
/-- Adding a common location shift to every observation leaves every fitted PIT
unchanged, for both parities and including ties. -/
theorem adjustedPIT_ordered_add (Z : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (a : ℝ) :
    adjustedPIT n (orderedPIT (fun j o => Z j o + a) (n + 1) ω) =
      adjustedPIT n (orderedPIT Z (n + 1) ω) := by
  let z := fun i : Fin (n + 1) => Z i ω
  let u := fun i : Fin (n + 1) => z i + a
  have h : u ∘ Tuple.sort z = u ∘ Tuple.sort u :=
    Tuple.comp_sort_eq_comp_iff_monotone.mpr ((Tuple.monotone_sort z).add_const a)
  have eqRow : orderedPIT (fun j o => Z j o + a) (n + 1) ω =
      fun i => orderedPIT Z (n + 1) ω i + a := h.symm
  rw [eqRow]
  funext i
  apply congrArg Φ
  dsimp [normalMedian]
  ring

end PITW
