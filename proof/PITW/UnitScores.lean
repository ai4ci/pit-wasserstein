/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.EmpiricalPath
public import PITW.RankLimits

/-! Score functionals on the unit interval and their bridge reference values. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

private lemma sign_bound (x : ℝ) : |Real.sign x| ≤ 1 := by
  rcases lt_trichotomy x 0 with h | rfl | h <;> simp [Real.sign_of_neg, Real.sign_of_pos, *]

private lemma sign_meas : Measurable Real.sign := by
  have e : Real.sign = fun x : ℝ => if 0 < x then (1 : ℝ) else if x < 0 then -1 else 0 := by
    funext x
    rcases lt_trichotomy x 0 with h | rfl | h
    · simp [h, h.not_gt, Real.sign_of_neg h]
    · simp
    · simp [h, Real.sign_of_pos h]
  rw [e]
  exact measurable_const.ite (measurableSet_lt measurable_const measurable_id)
    (measurable_const.ite (measurableSet_lt measurable_id measurable_const) measurable_const)

theorem integrable_signed_unit {f : I → ℝ} (h : Integrable f) :
    Integrable (fun t : I => Real.sign (1 / 2 - (t : ℝ)) * f t) := by
  apply h.norm.mono' ((sign_meas.comp (measurable_const.sub measurable_subtypeVal)).aemeasurable.mul
    h.aestronglyMeasurable.aemeasurable |>.aestronglyMeasurable)
  apply ae_of_all; intro t
  change |Real.sign (1 / 2 - (t : ℝ)) * f t| ≤ |f t|
  rw [abs_mul]
  exact mul_le_of_le_one_left (abs_nonneg _) (sign_bound _)

/-- The signed integral puts positive weight on the lower half of the PIT range. -/
def unitSigned (X : UnitL1) : ℝ := ∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * X t

/-- Evaluate the signed integral with any almost-everywhere representative of the path. -/
theorem unitSigned_eq {X : UnitL1} {f : I → ℝ} (h : ⇑X =ᵐ[volume] f) :
    unitSigned X = ∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * f t :=
  integral_congr_ae (h.mono fun _ ht => congrArg (_ * ·) ht)

/-- Bound the change in both area functionals by the integrated pointwise error. -/
theorem unit_area_errors {f g : I → ℝ} (hf : Integrable f) (hg : Integrable g) :
    |(∫ t, |f t|) - (∫ t, |g t|)| ≤ (∫ t, |f t - g t|) ∧
    |(∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * f t) - (∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * g t)| ≤
      ∫ t, |f t - g t| := by
  constructor
  · rw [← integral_sub hf.abs hg.abs]
    exact abs_integral_le_integral_abs.trans (integral_mono (hf.abs.sub hg.abs).abs
      (hf.sub hg).abs (fun t => abs_abs_sub_abs_le_abs_sub ..))
  · rw [← integral_sub (integrable_signed_unit hf) (integrable_signed_unit hg)]
    apply abs_integral_le_integral_abs.trans
    apply integral_mono ((integrable_signed_unit hf).sub (integrable_signed_unit hg)).abs
      (hf.sub hg).abs
    intro t
    change |Real.sign _ * f t - Real.sign _ * g t| ≤ |f t - g t|
    rw [← mul_sub, abs_mul]
    exact mul_le_of_le_one_left (abs_nonneg _) (sign_bound _)

theorem unitSigned_continuous : Continuous unitSigned := by
  apply LipschitzWith.continuous (K := 1)
  intro X Y
  rw [edist_dist, edist_dist, ENNReal.coe_one, one_mul]
  apply ENNReal.ofReal_le_ofReal
  rw [Real.dist_eq, dist_eq_norm, unitL1_norm (Lp.coeFn_sub X Y)]
  exact (unit_area_errors (L1.integrable_coeFn X) (L1.integrable_coeFn Y)).2

theorem unitProfile_integrable : Integrable (fun t : I => normalProfile t) :=
  (integrableOn_iff_comap_subtypeVal measurableSet_Icc).mp normalProfile_integrable.integrableOn

/-- The median-adjustment profile restricted to the integration interval. -/
def unitProfile : UnitL1 := unitProfile_integrable.toL1 _

/-- The three limiting functionals evaluated on a CDF fluctuation and its midpoint. -/
@[expose] def unitScores (x : UnitL1 × ℝ) : ℝ × ℝ × ℝ :=
  (‖x.1‖, ‖x.1 - x.2 • unitProfile‖, unitSigned (x.1 - x.2 • unitProfile))

theorem unitScores_continuous : Continuous unitScores := by
  have h : Continuous (fun x : UnitL1 × ℝ => x.1 - x.2 • unitProfile) :=
    continuous_fst.sub (continuous_snd.smul continuous_const)
  exact (continuous_norm.comp continuous_fst).prodMk
    ((continuous_norm.comp h).prodMk (unitSigned_continuous.comp h))

theorem projected_unit_ae {X : UnitL1} {f : I → ℝ} (h : ⇑X =ᵐ[volume] f) (a : ℝ) :
    ⇑(X - a • unitProfile) =ᵐ[volume] fun t : I => f t - a * normalProfile t := by
  filter_upwards [Lp.coeFn_sub X (a • unitProfile), Lp.coeFn_smul a unitProfile,
    unitProfile_integrable.coeFn_toL1, h] with t hs hm hp hf
  change (unitProfile t) = normalProfile t at hp
  simpa only [Pi.sub_apply, Pi.smul_apply, smul_eq_mul, hm, hf, hp] using hs

private lemma norm_supported {f : ℝ → ℝ} (hf : Integrable f)
    (hs : ∀ t ∉ Icc (0 : ℝ) 1, f t = 0) :
    ‖hf.toL1 f‖ = ∫ t : I, |f (t : ℝ)| := by
  rw [L1.norm_eq_integral_norm, integral_subtype measurableSet_Icc (fun t => |f t|),
    setIntegral_eq_integral_of_forall_compl_eq_zero (fun t ht => by simp [hs t ht])]
  exact integral_congr_ae (hf.coeFn_toL1.mono fun _ h =>
    (Real.norm_eq_abs _).trans (congrArg abs h))

private lemma signed_integral_eq (f : ℝ → ℝ) (hf : Integrable f) :
    (∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * f t) = contrast f := by
  let g := fun t : ℝ => Real.sign (1 / 2 - t) * f t
  have hg : Integrable g := by
    apply hf.norm.mono' ((sign_meas.comp (measurable_const.sub measurable_id)).aemeasurable.mul
      hf.aestronglyMeasurable.aemeasurable |>.aestronglyMeasurable)
    exact ae_of_all _ fun t => by
      simpa [g, abs_mul] using mul_le_of_le_one_left (abs_nonneg (f t)) (sign_bound (1 / 2 - t))
  change (∫ t : I, g t) = _
  rw [integral_subtype measurableSet_Icc, ← setIntegral_congr_set
    (Ioc_ae_eq_Icc (μ := (volume : Measure ℝ))), ← intervalIntegral.integral_of_le zero_le_one,
    ← intervalIntegral.integral_add_adjacent_intervals (b := (1 / 2:ℝ))
      hg.intervalIntegrable hg.intervalIntegrable]
  have h₁ : (∫ t in (0 : ℝ)..1 / 2, g t) = ∫ t in (0 : ℝ)..1 / 2, f t := by
    apply intervalIntegral.integral_congr_Ioo_of_le (by norm_num)
    intro t ht; exact (congrArg (· * f t) (Real.sign_of_pos (sub_pos.mpr ht.2))).trans (one_mul _)
  have h₂ : (∫ t in (1 / 2:ℝ)..1, g t) = ∫ t in (1 / 2:ℝ)..1, -f t := by
    apply intervalIntegral.integral_congr_Ioo_of_le (by norm_num)
    intro t ht
    exact (congrArg (· * f t) (Real.sign_of_neg (sub_neg.mpr ht.1))).trans (neg_one_mul _)
  rw [h₁, h₂, intervalIntegral.integral_neg]
  rfl

/-- The unit-interval functionals agree with the zero-extended bridge functionals
used by the manuscript. The symmetric fitted-median term has zero signed area. -/
theorem unitScores_bridge (G : C(I, ℝ)) :
    unitScores (ContinuousMap.toLp 1 volume ℝ G, G unitHalf) = bridgeScores G := by
  let a := G unitHalf
  let f t := extendUnit G t - a * normalProfile t
  have hf : Integrable f := (extendUnit_integrable G).sub (normalProfile_integrable.const_mul a)
  have hr : project medianProfile (unitToL1 G, a) = hf.toL1 f := by
    rw [project, unitToL1_apply, medianProfile, ← Integrable.toL1_smul, ← Integrable.toL1_sub]
    rfl
  have he (t : I) : f t = G t - a * normalProfile t := by
    dsimp [f]; rw [extendUnit_at G t.property]
  have out t (ht : t ∉ Icc (0 : ℝ) 1) : f t = 0 := by
    simp [f, extendUnit_outside G ht, normalProfile_outside ht]
  have hG := ContinuousMap.coeFn_toLp (p := 1) (𝕜 := ℝ) volume G
  have hfit := projected_unit_ae hG a
  change (‖ContinuousMap.toLp 1 volume ℝ G‖, ‖ContinuousMap.toLp 1 volume ℝ G - a • unitProfile‖,
    unitSigned (ContinuousMap.toLp 1 volume ℝ G - a • unitProfile)) =
    (‖unitToL1 G‖, ‖project medianProfile (unitToL1 G, a)‖, signedArea (unitToL1 G))
  congr 1
  · rw [unitL1_norm hG, unitToL1_apply, norm_supported _ (fun _ ht => extendUnit_outside G ht)]
    exact integral_congr_ae (ae_of_all _ fun t => congrArg abs (extendUnit_at G t.property).symm)
  · congr 1
    · rw [unitL1_norm hfit, hr, norm_supported _ out]
      exact integral_congr_ae (ae_of_all _ fun t => congrArg abs (he t).symm)
    · rw [← signed_project signed_medianProfile (unitToL1 G, a), hr, signedArea_toL1,
        ← signed_integral_eq f hf]
      exact integral_congr_ae (hfit.mono fun t ht => congrArg (_ * ·) (ht.trans (he t).symm))

end PITW
