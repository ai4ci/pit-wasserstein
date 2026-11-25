/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.EmpiricalGrid
public import PITW.SampleMedian

/-! The midpoint count supplies the Gaussian reference for the normal sample median. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

/-- The scaled midpoint count converges to the linearised median reference. -/
theorem iid_median_reference_limit (U : ℕ → Ω → ℝ) (hu : ∀ i, HasLaw (U i) uniformPIT P)
    (hi : iIndepFun U P) (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution
      (fun (n : ℕ) ω => -empiricalAt U (n+1) unitHalf ω / gaussianPDFReal 0 1 0) atTop
      (fun ξ => -brownianBridge W ξ unitHalf / gaussianPDFReal 0 1 0) (fun _ => P) Q := by
  let t : Fin 1 → I := fun _ => unitHalf
  let f := fun x : EuclideanSpace ℝ (Fin 1) => -x 0 / gaussianPDFReal 0 1 0
  have hf : Continuous f := by unfold f; fun_prop
  have h := (iid_empirical_grid_limit t U hu hi W hW).continuous_comp hf
  have h' : TendstoInDistribution (fun (n : ℕ) ω =>
      -empiricalAt U n unitHalf ω / gaussianPDFReal 0 1 0) atTop
      (fun ξ => -brownianBridge W ξ unitHalf / gaussianPDFReal 0 1 0) (fun _ => P) Q := by
    simpa only [Function.comp_def, f, empiricalGrid_apply, t] using h
  exact ⟨fun n => h'.forall_aemeasurable (n+1), h'.aemeasurable_limit,
    h'.tendsto.comp (tendsto_add_atTop_nat 1)⟩

/-- The bridge value at one half has variance 1/4; division by the normal
density at zero gives the normal median its limiting variance π/2. -/
theorem normalMedian_reference_law (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    HasLaw (fun ξ => -brownianBridge W ξ unitHalf / gaussianPDFReal 0 1 0)
      (gaussianReal 0 (Real.pi / 2).toNNReal) Q := by
  let B := fun ξ => brownianBridge W ξ unitHalf
  have hG : HasGaussianLaw B Q :=
    (brownianBridge_gaussian hW).map (ContinuousMap.evalCLM ℝ unitHalf)
  have eqn := (brownianBridge_ae hW).mono fun ξ h => h unitHalf
  have mean : (∫ ξ, B ξ ∂Q) = 0 := (integral_congr_ae eqn).trans
    (pinned_mean hW.toIsPreBrownianReal _ unitHalf.property)
  have var : Var[B; Q] = 1/4 := by
    rw [← covariance_self hG.aemeasurable, covariance_eq_sub hG.memLp_two hG.memLp_two,
      mean, mul_zero, sub_zero]
    have prod := (integral_congr_ae (eqn.mono fun ξ h => congrArg₂ (· * ·) h h)).trans
      (pinned_secondMoment hW.toIsPreBrownianReal _ _ unitHalf.property unitHalf.property)
    convert prod using 1; norm_num [bridgeKernel, unitHalf]
  have half : HasLaw B (gaussianReal 0 (1/4)) Q := ⟨hG.aemeasurable, by
    rw [hG.map_eq_gaussianReal, var, mean]
    congr 1; apply NNReal.eq; norm_num⟩
  have h := gaussianReal_div_const (gaussianReal_neg half) (gaussianPDFReal 0 1 0)
  have hv : (1/4 : NNReal) / NNReal.mk (gaussianPDFReal 0 1 0 ^ 2) (sq_nonneg _) =
      (Real.pi / 2).toNNReal := by
    apply NNReal.eq
    have hpdf : gaussianPDFReal 0 1 0 = (Real.sqrt (2 * Real.pi))⁻¹ := by
      simp only [gaussianPDFReal_def, NNReal.coe_one, mul_one, sub_self,
        zero_pow (by decide : 2 ≠ 0), neg_zero, zero_div, Real.exp_zero]
    change (1 / 4 : ℝ) / gaussianPDFReal 0 1 0 ^ 2 = _
    rw [hpdf, inv_pow, Real.sq_sqrt (by positivity), div_inv_eq_mul,
      Real.coe_toNNReal _ (by positivity)]
    ring
  simpa only [Pi.neg_apply, neg_zero, zero_div, hv, B] using h

omit [IsProbabilityMeasure P] in
/-- Applying the standard normal CDF to a standard normal observation gives
the uniform PIT law, including the endpoint convention in `uniformPIT`. -/
theorem stdNormal_pit_law {Z : Ω → ℝ} (hZ : HasLaw Z (gaussianReal 0 1) P) :
    HasLaw (Φ ∘ Z) uniformPIT P := by
  apply HasLaw.comp _ hZ
  have hΦ : Measurable Φ := normalCDF_strictMono.monotone.measurable
  refine ⟨hΦ.aemeasurable, Measure.ext_of_Iic _ _ fun t => ?_⟩
  rw [Measure.map_apply hΦ measurableSet_Iic, Measure.restrict_apply measurableSet_Iic]
  have eqn : Iic t ∩ Icc (0 : ℝ) 1 = Icc 0 (min t 1) := by
    ext x; simp only [mem_inter_iff, mem_Iic, mem_Icc, le_min_iff]; tauto
  rw [eqn, Real.volume_Icc, sub_zero]
  by_cases ht : t ≤ 0
  · have empty : Φ ⁻¹' Iic t = ∅ := by
      apply eq_empty_iff_forall_notMem.mpr
      intro x hx
      have pos := (cdf_nonneg (gaussianReal 0 1) (x-1)).trans_lt
        (normalCDF_strictMono (show x-1 < x by linarith))
      exact (ht.trans_lt pos).not_ge hx
    rw [empty, measure_empty, ENNReal.ofReal_of_nonpos ((min_le_left _ _).trans ht)]
  · by_cases h1 : 1 ≤ t
    · have all : Φ ⁻¹' Iic t = univ :=
        eq_univ_of_forall (fun x => (cdf_le_one _ x).trans h1)
      simp [all, min_eq_right h1]
    · obtain ⟨z, hz⟩ := normalCDF_range
        (show t ∈ Ioo (0 : ℝ) 1 from ⟨lt_of_not_ge ht, lt_of_not_ge h1⟩)
      have pre : Φ ⁻¹' Iic t = Iic z := by
        ext x; rw [← hz]; exact normalCDF_strictMono.le_iff_le
      rw [pre, min_eq_left (le_of_not_ge h1), ← hz, ofReal_cdf]

/-- The same midpoint reference converges to the canonical real Gaussian law
without requiring a Brownian motion on an auxiliary space. -/
theorem iid_median_reference_gaussian_limit (U : ℕ → Ω → ℝ)
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P) :
    TendstoInDistribution (fun (n : ℕ) ω => -empiricalAt U (n+1) unitHalf ω /
      gaussianPDFReal 0 1 0) atTop id (fun _ => P) (gaussianReal 0 (Real.pi / 2).toNNReal) := by
  let H := (Iic (1 / 2 : ℝ)).indicator (fun _ => (1 : ℝ))
  let c := -(gaussianPDFReal 0 1 0)⁻¹
  let X i := (fun u => c * H u) ∘ U i
  have hm : Measurable H := measurable_const.indicator measurableSet_Iic
  have hm2 : MemLp (H ∘ U 0) 2 P := by
    apply MemLp.of_bound (hm.comp_aemeasurable (hu 0).aemeasurable).aestronglyMeasurable 1
    exact ae_of_all _ fun ω => by
      simp only [H, Function.comp_apply, Set.indicator_apply, mem_Iic]
      split <;> norm_num
  have mean : P[H ∘ U 0] = 1/2 := by
    rw [(hu 0).integral_comp hm.aestronglyMeasurable]
    have setEq : Iic (1/2 : ℝ) ∩ Icc 0 1 = Icc 0 (1/2) := by
      ext x; simp only [mem_inter_iff, mem_Iic, mem_Icc]; constructor <;> rintro ⟨_, _⟩
      · grind
      · grind
    simp only [H, integral_indicator_const _ measurableSet_Iic, Measure.real_def,
      Measure.restrict_apply measurableSet_Iic, setEq, Real.volume_Icc]
    norm_num
  have hvar : Var[H ∘ U 0; P] = 1/4 := by
    rw [variance_eq_sub hm2, mean]
    have square : (H ∘ U 0) ^ 2 = H ∘ U 0 := by
      funext ω
      simp only [H, Pi.pow_apply, Function.comp_apply, Set.indicator_apply]
      split <;> norm_num
    rw [square, mean]; norm_num
  have vX : Var[X 0; P] = Real.pi / 2 := by
    rw [show X 0 = (fun ω => c * (H ∘ U 0) ω) from rfl, variance_const_mul, hvar]
    simp only [c, even_two.neg_pow, gaussianPDFReal_def, NNReal.coe_one, mul_one,
      sub_self, zero_pow (by decide : 2 ≠ 0), neg_zero, zero_div, Real.exp_zero, inv_inv]
    rw [Real.sq_sqrt (by positivity)]
    ring
  have hY : HasLaw id (gaussianReal 0 Var[X 0; P].toNNReal)
      (gaussianReal 0 (Real.pi / 2).toNNReal) := vX ▸ HasLaw.id
  have mg : Measurable (fun u => c * H u) := hm.const_mul _
  have h := tendstoInDistribution_inv_sqrt_mul_sum_sub hY (hm2.const_smul c)
    (hi.comp (fun _ => fun u => c * H u) (fun _ => mg))
    (fun i => ((hu i).identDistrib (hu 0)).comp mg)
  have mX : P[X 0] = c * (1/2) := (integral_const_mul c (H ∘ U 0)).trans (by rw [mean])
  have eqn (n : ℕ) (ω : Ω) :
      (Real.sqrt n)⁻¹ * (∑ j ∈ Finset.range n, X j ω - n * P[X 0]) =
        -empiricalAt U n unitHalf ω / gaussianPDFReal 0 1 0 := by
    rw [empiricalAt_eq_count, Fin.sum_univ_eq_sum_range
      (fun j => if U j ω ≤ unitHalf then (1 : ℝ) else 0), mX]
    change _ * (∑ j ∈ Finset.range n, c * H (U j ω) - _) = _
    rw [← Finset.mul_sum]
    simp only [H, Set.indicator_apply, mem_Iic, c, div_eq_mul_inv]
    ring
  have h' : TendstoInDistribution (fun (n : ℕ) ω => -empiricalAt U n unitHalf ω /
      gaussianPDFReal 0 1 0) atTop id (fun _ => P) (gaussianReal 0 (Real.pi / 2).toNNReal) :=
    h.congr (fun n => ae_of_all _ (eqn n)) .rfl
  exact ⟨fun n => h'.forall_aemeasurable (n+1), h'.aemeasurable_limit,
    h'.tendsto.comp (tendsto_add_atTop_nat 1)⟩

end PITW
