/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.ContinuousGaussian

/-! The continuous Brownian bridge as a Gaussian random path, with the moment
bounds required for integrating its covariance over time. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Function Set
open scoped Topology unitInterval
namespace PITW

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

private def unitTime (t : I) : NNReal := ⟨t, t.property.1⟩

private def brownianUnit (W : NNReal → Ω → ℝ) (ω : Ω) : C(I, ℝ) :=
  ContinuousMap.mkD (fun t => W (unitTime t) ω) 0

omit [IsProbabilityMeasure P] in
private lemma brownianUnit_ae {W : NNReal → Ω → ℝ} (hW : IsBrownianReal W P) :
    ∀ᵐ ω ∂P, ∀ t : I, brownianUnit W ω t = W (unitTime t) ω := by
  filter_upwards [hW.cont] with ω hω t
  apply ContinuousMap.mkD_apply_of_continuous
  exact hω.comp (continuous_subtypeVal.subtype_mk _)

private def pinMap : C(I, ℝ) →L[ℝ] C(I, ℝ) :=
  ContinuousLinearMap.id ℝ _ -
    (ContinuousMap.evalCLM ℝ (1 : I)).smulRight ⟨Subtype.val, continuous_subtypeVal⟩

/-- A version of the pinned process taking values in continuous functions on [0,1]. -/
def brownianBridge (W : NNReal → Ω → ℝ) (ω : Ω) : C(I, ℝ) := pinMap (brownianUnit W ω)

omit [IsProbabilityMeasure P] in
theorem brownianBridge_ae {W : NNReal → Ω → ℝ} (hW : IsBrownianReal W P) :
    ∀ᵐ ω ∂P, ∀ t : I, brownianBridge W ω t = pinned W t ω := by
  filter_upwards [brownianUnit_ae hW] with ω hω t
  change brownianUnit W ω t - brownianUnit W ω 1 * (t : ℝ) = _
  simp [hω, pinned, t.property, unitTime, Real.toNNReal_of_nonneg t.property.1, mul_comm]
  rfl

theorem brownianBridge_gaussian {W : NNReal → Ω → ℝ} (hW : IsBrownianReal W P) :
    HasGaussianLaw (brownianBridge W) P := by
  have hg := hW.isGaussianProcess.comp_right unitTime
  have heq (t : I) : (fun ω => W (unitTime t) ω) =ᵐ[P] (fun ω => brownianUnit W ω t) :=
    (brownianUnit_ae hW).mono fun ω h => (h t).symm
  have h := continuous_gaussian_law (brownianUnit W) (hg.congr heq) fun t =>
    (integral_congr_ae (heq t).symm).trans (hW.integral_eval _)
  exact h.map pinMap

/-- Extend a continuous path by zero on the complement of the unit interval. -/
def extendUnit (f : C(I, ℝ)) : ℝ → ℝ :=
  (Icc (0 : ℝ) 1).indicator (fun t => f (projIcc 0 1 zero_le_one t))

theorem extendUnit_at (f : C(I, ℝ)) {t : ℝ} (h : t ∈ Icc (0 : ℝ) 1) :
    extendUnit f t = f ⟨t, h⟩ := by simp [extendUnit, h, projIcc_of_mem]

theorem extendUnit_outside (f : C(I, ℝ)) {t : ℝ} (h : t ∉ Icc (0 : ℝ) 1) :
    extendUnit f t = 0 := by simp [extendUnit, h]

private lemma extendUnit_measurable (f : C(I, ℝ)) : Measurable (extendUnit f) :=
  (f.continuous.comp continuous_projIcc).measurable.indicator measurableSet_Icc

private lemma extendUnit_bound (f : C(I, ℝ)) (t : ℝ) :
    ‖extendUnit f t‖ ≤ (Icc (0 : ℝ) 1).indicator (fun _ => ‖f‖) t := by
  by_cases ht : t ∈ Icc (0 : ℝ) 1
  · simp only [extendUnit, indicator_of_mem ht]; exact f.norm_coe_le_norm _
  · simp [extendUnit, ht]

private lemma unitBound_int (c : ℝ) :
    Integrable ((Icc (0 : ℝ) 1).indicator (fun _ => c)) :=
  (integrableOn_const (s := Icc (0 : ℝ) 1) measure_Icc_lt_top.ne).integrable_indicator
    measurableSet_Icc

theorem extendUnit_integrable (f : C(I, ℝ)) : Integrable (extendUnit f) :=
  (unitBound_int _).mono' (extendUnit_measurable f).aestronglyMeasurable
    (ae_of_all _ (extendUnit_bound f))

private def embedLinear : C(I, ℝ) →ₗ[ℝ] Path where
  toFun f := (extendUnit_integrable f).toL1 (extendUnit f)
  map_add' f g := by
    rw [← Integrable.toL1_add]
    apply (Integrable.toL1_eq_toL1_iff ..).2
    filter_upwards with t
    by_cases ht : t ∈ Icc (0 : ℝ) 1 <;> simp [extendUnit, ht]
  map_smul' c f := by
    simp only [RingHom.id_apply]
    rw [← Integrable.toL1_smul]
    apply (Integrable.toL1_eq_toL1_iff ..).2
    filter_upwards with t
    by_cases ht : t ∈ Icc (0 : ℝ) 1 <;> simp [extendUnit, ht]

/-- The zero extension is a contraction from the supremum norm to L¹. -/
def unitToL1 : C(I, ℝ) →L[ℝ] Path :=
  embedLinear.mkContinuous 1 fun f => by
    rw [one_mul]
    change ‖(extendUnit_integrable f).toL1 _‖ ≤ _
    rw [L1.norm_eq_integral_norm]
    calc
      _ = ∫ t, ‖extendUnit f t‖ := integral_congr_ae <|
        (extendUnit_integrable f).coeFn_toL1.mono fun _ h => congrArg norm h
      _ ≤ _ := integral_mono (extendUnit_integrable f).norm (unitBound_int _) (extendUnit_bound f)
      _ = _ := by simp [integral_indicator measurableSet_Icc]

theorem unitToL1_apply (f : C(I, ℝ)) :
    unitToL1 f = (extendUnit_integrable f).toL1 (extendUnit f) := by
  change embedLinear f = _
  rfl

theorem brownianBridge_L1_gaussian {W : NNReal → Ω → ℝ} (hW : IsBrownianReal W P) :
    HasGaussianLaw (unitToL1 ∘ brownianBridge W) P :=
  (brownianBridge_gaussian hW).map unitToL1

theorem unit_eval_bound (f : C(I, ℝ)) (t : ℝ) : ‖extendUnit f t‖ ≤ ‖f‖ := by
  apply (extendUnit_bound f t).trans
  by_cases ht : t ∈ Icc (0 : ℝ) 1 <;> simp [ht]

private lemma unit_eval_measurable :
    Measurable (fun p : ℝ × C(I, ℝ) => extendUnit p.2 p.1) := by
  let f := fun p : ℝ × C(I, ℝ) => p.2 (projIcc 0 1 zero_le_one p.1)
  have hc : Continuous f := continuous_eval.comp
    (continuous_snd.prodMk ((continuous_projIcc (h := (zero_le_one : (0 : ℝ) ≤ 1))).comp
      continuous_fst))
  have hs : MeasurableSet (Prod.fst ⁻¹' Icc (0 : ℝ) 1 : Set (ℝ × C(I, ℝ))) :=
    measurable_fst measurableSet_Icc
  convert hc.measurable.indicator hs using 1
  funext p
  by_cases ht : p.1 ∈ Icc (0 : ℝ) 1 <;> simp [extendUnit, ht, f, Set.indicator, Set.mem_preimage]

/-- Both Fubini exchanges are controlled by second moments in the supremum norm.
The multiplier can be a point evaluation or the entire signed integral. -/
private lemma halves_mul {B : Ω → C(I, ℝ)} (hB : HasGaussianLaw B P)
    {V : Ω → ℝ} (hV : MemLp V 2 P) :
    IntegrableHalves P (fun t ω => V ω * extendUnit (B ω) t) := by
  have onMeasure (μ : Measure ℝ) [IsFiniteMeasure μ] :
      Integrable (fun p : ℝ × Ω => V p.2 * extendUnit (B p.2) p.1) (μ.prod P) := by
    have hm : AEMeasurable (fun p : ℝ × Ω => (p.1, B p.2)) (μ.prod P) :=
      measurable_fst.aemeasurable.prodMk hB.aemeasurable.comp_snd
    have he := unit_eval_measurable.comp_aemeasurable hm
    apply ((hV.norm.integrable_mul hB.memLp_two.norm).comp_snd μ).mono'
      (hV.aestronglyMeasurable.aemeasurable.comp_snd.mul he).aestronglyMeasurable
    filter_upwards with p
    change ‖V p.2 * extendUnit (B p.2) p.1‖ ≤ ‖V p.2‖ * ‖B p.2‖
    rw [norm_mul]
    apply mul_le_mul_of_nonneg_left (unit_eval_bound ..) (norm_nonneg _)
  exact ⟨onMeasure _, onMeasure _⟩

/-- The two-sided directed reference law follows from Mathlib's Brownian motion
predicate alone. This also covers versions with exceptional discontinuous paths. -/
theorem brownian_directed_law {W : NNReal → Ω → ℝ} (hW : IsBrownianReal W P) :
    P.map (fun ω => contrast (fun t => pinned W t ω)) = gaussianReal 0 (1 / 48) := by
  let B := brownianBridge W
  let F := fun t ω => extendUnit (B ω) t
  have hg := brownianBridge_gaussian hW
  have heq : ∀ᵐ ω ∂P, ∀ t : ℝ, F t ω = pinned W t ω := by
    filter_upwards [brownianBridge_ae hW] with ω hω t
    by_cases ht : t ∈ Icc (0 : ℝ) 1
    · simpa only [F, extendUnit, indicator_of_mem ht, projIcc_of_mem _ ht] using hω ⟨t, ht⟩
    · simp [F, extendUnit, pinned, ht]
  have hfun : (fun ω => contrast (fun t => F t ω)) =ᵐ[P]
      (fun ω => contrast (fun t => pinned W t ω)) :=
    heq.mono fun ω h => congrArg contrast (funext h)
  rw [← Measure.map_congr hfun]
  apply directed_gaussian_reference F (fun ω => extendUnit_integrable (B ω))
    (brownianBridge_L1_gaussian hW)
  · intro t ht
    exact (integral_congr_ae (heq.mono fun _ h => h t)).trans
      (pinned_mean hW.toIsPreBrownianReal t ht)
  · intro s hs t ht
    exact (integral_congr_ae (heq.mono fun _ h => congrArg₂ (· * ·) (h s) (h t))).trans
      (pinned_secondMoment hW.toIsPreBrownianReal s t hs ht)
  · simpa only [one_mul] using (halves_mul hg (V := fun _ => (1 : ℝ)) (memLp_const 1))
  · intro s hs
    have eval : F s = fun ω => B ω ⟨s, hs⟩ := by
      funext ω; simp [F, extendUnit, hs, projIcc_of_mem]
    apply halves_mul hg
    rw [eval]
    exact (hg.map (ContinuousMap.evalCLM ℝ ⟨s, hs⟩)).memLp_two
  · apply halves_mul hg
    have hD := (brownianBridge_L1_gaussian hW).map signedArea
    exact hD.memLp_two.ae_eq (ae_of_all P fun ω => signedArea_toL1 _ (extendUnit_integrable (B ω)))

omit [IsProbabilityMeasure P] in
/-- Signed area of the L¹ version agrees almost surely with the original bridge integral. -/
theorem brownianBridge_area_ae {W : NNReal → Ω → ℝ} (hW : IsBrownianReal W P) :
    (fun ω => signedArea (unitToL1 (brownianBridge W ω))) =ᵐ[P]
      fun ω => contrast (fun t => pinned W t ω) := by
  filter_upwards [brownianBridge_ae hW] with ω h
  rw [show signedArea (unitToL1 (brownianBridge W ω)) = _ from
    signedArea_toL1 _ (extendUnit_integrable (brownianBridge W ω))]
  apply congrArg contrast
  funext t
  by_cases ht : t ∈ Icc (0 : ℝ) 1
  · simpa only [extendUnit, indicator_of_mem ht, projIcc_of_mem _ ht] using h ⟨t, ht⟩
  · simp [pinned, extendUnit, ht]

end PITW
