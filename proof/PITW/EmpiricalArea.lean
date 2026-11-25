/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.EmpiricalPath

/-! Integrated empirical CDF discrepancies from iid uniform PITs. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Filter
open scoped Topology unitInterval
namespace PITW

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

/-- Area of the absolute difference between the empirical and uniform CDFs,
scaled by the square root of sample size. -/
@[expose] def empiricalArea (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) := ∫ t : I, |empiricalAt U n t ω|

/-- The baseline empirical-CDF area converges to the absolute bridge area,
directly from measurable iid uniform observations. -/
theorem iid_empirical_area_limit (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution (empiricalArea U) atTop
      (fun ξ => ∫ t : I, |brownianBridge W ξ t|) (fun _ => P) Q := by
  let F : UnitL1 × ℝ → ℝ := fun p => ‖p.1‖
  have ht := (iid_empirical_path_eval_limit U hm hu hi W hW 0).continuous_comp
    (g := F) (continuous_norm.comp continuous_fst)
  have emp n ω : ‖empiricalPath U n ω‖ = empiricalArea U n ω :=
    unitL1_norm (empiricalPath_ae U n ω)
  have bridge ξ : ‖ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ)‖ =
      ∫ t : I, |brownianBridge W ξ t| :=
    unitL1_norm (ContinuousMap.coeFn_toLp (𝕜 := ℝ) volume _)
  simpa only [F, Function.comp_apply, Function.comp_def, emp, bridge] using ht

end PITW
