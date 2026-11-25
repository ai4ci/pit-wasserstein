/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import Mathlib.Probability.Distributions.Exponential

/-! The two-spacing case of the exponential representation of uniform order statistics. -/

public section
noncomputable section
open MeasureTheory Measure ProbabilityTheory Set Real

namespace PITW

private abbrev exponential := expMeasure 1

local instance : IsProbabilityMeasure (expMeasure 1) := isProbabilityMeasure_expMeasure one_pos
local instance : NullSingletonClass (expMeasure 1) :=
  inferInstanceAs (NullSingletonClass (volume.withDensity (gammaPDF 1 1)))

private lemma exponential_pos : ∀ᵐ u ∂exponential, 0 < u := by
  have e : exponential (Iic 0) = 0 := by
    rw [← ofReal_cdf, cdf_expMeasure_eq one_pos]
    simp
  exact (measure_eq_zero_iff_ae_notMem.mp e).mono fun u h => lt_of_not_ge h

private lemma exponential_tail {u : ℝ} (hu : 0 ≤ u) :
    exponential (Ici u) = ENNReal.ofReal (exp (-u)) := by
  rw [← measure_congr Ioi_ae_eq_Ici, ← ofReal_measureReal, ← compl_Iic,
    measureReal_compl measurableSet_Iic, probReal_univ, ← cdf_eq_real,
    cdf_expMeasure_eq one_pos]
  simp [hu]

/-- Integrating the exponential survival function against the density of the
first coordinate gives a rescaled exponential density of rate 1/x. -/
private lemma exponential_slice_integral {x : ℝ} (hx : 0 < x) :
    (∫⁻ u, ENNReal.ofReal (exp (-((1-x)/x * u))) ∂exponential) = ENNReal.ofReal x := by
  change (∫⁻ u, _ ∂volume.withDensity (exponentialPDF 1)) = _
  have hm (r : ℝ) : Measurable (exponentialPDF r) :=
    ENNReal.continuous_ofReal.measurable.comp (measurable_exponentialPDFReal r)
  rw [lintegral_withDensity_eq_lintegral_mul volume (hm 1) (by fun_prop)]
  have product (u : ℝ) : exponentialPDF 1 u * ENNReal.ofReal (exp (-((1-x)/x*u))) =
      ENNReal.ofReal x * exponentialPDF (1/x) u := by
    by_cases hu : 0 ≤ u
    · simp only [exponentialPDF_of_nonneg hu, one_mul, ← ENNReal.ofReal_mul (exp_pos _).le,
        ← ENNReal.ofReal_mul hx.le, ← Real.exp_add]
      congr 1
      rw [← mul_assoc, mul_one_div_cancel hx.ne', one_mul]
      congr 1
      field_simp
      ring
    · simp [exponentialPDF_of_neg (lt_of_not_ge hu)]
  change (∫⁻ u, exponentialPDF 1 u * _) = _
  simp_rw [product]
  rw [lintegral_const_mul _ (hm _), lintegral_exponentialPDF_eq_one (by positivity), mul_one]

/-- For independent standard exponentials, the first coordinate divided by their
sum has uniform law on the unit interval. -/
theorem exponential_pair_ratio_uniform :
    ((expMeasure 1).prod (expMeasure 1)).map (fun p : ℝ × ℝ => p.1 / (p.1 + p.2)) =
      volume.restrict (Icc (0 : ℝ) 1) := by
  let R (p : ℝ × ℝ) := p.1 / (p.1 + p.2)
  have hR : Measurable R := measurable_fst.div (measurable_fst.add measurable_snd)
  have hpos : ∀ᵐ p ∂exponential.prod exponential, 0 < p.1 ∧ 0 < p.2 := by
    apply (ae_prod_iff_ae_ae (measurableSet_lt measurable_const measurable_fst |>.inter
      (measurableSet_lt measurable_const measurable_snd))).mpr
    filter_upwards [exponential_pos] with u hu
    exact exponential_pos.mono fun v hv => ⟨hu,hv⟩
  have hunit := hpos.mono fun p ⟨hu,hv⟩ => show 0 < R p ∧ R p < 1 from
    ⟨div_pos hu (add_pos hu hv), (div_lt_one (add_pos hu hv)).mpr (lt_add_of_pos_right _ hv)⟩
  apply ext_of_Iic
  intro x
  rw [Measure.map_apply hR measurableSet_Iic, Measure.restrict_apply measurableSet_Iic]
  have inter : Iic x ∩ Icc (0 : ℝ) 1 = Icc 0 (min x 1) := by ext y; simp; tauto
  rw [inter, Real.volume_Icc, sub_zero]
  by_cases hx : x ≤ 0
  · have hz : ENNReal.ofReal (min x 1) = 0 :=
      ENNReal.ofReal_eq_zero.mpr ((min_le_left _ _).trans hx)
    rw [hz]
    exact measure_eq_zero_iff_ae_notMem.mpr (hunit.mono fun p h => (hx.trans_lt h.1).not_ge)
  by_cases htop : 1 ≤ x
  · rw [min_eq_right htop, ENNReal.ofReal_one]
    rw [← measure_univ (μ := exponential.prod exponential)]
    apply measure_congr
    filter_upwards [hunit] with p hp
    simp only [mem_preimage, mem_Iic, mem_univ, iff_true]
    exact hp.2.le.trans htop
  have hx0 := lt_of_not_ge hx
  have hx1 := lt_of_not_ge htop
  rw [min_eq_left hx1.le, Measure.prod_apply (hR measurableSet_Iic)]
  apply (lintegral_congr_ae ?_).trans (exponential_slice_integral hx0)
  filter_upwards [exponential_pos] with u hu
  have e : (Prod.mk u ⁻¹' (R ⁻¹' Iic x)) =ᵐ[exponential] Ici ((1-x)/x*u) := by
    filter_upwards [exponential_pos] with v hv
    change u / (u+v) ≤ x ↔ (1-x)/x*u ≤ v
    rw [div_le_iff₀ (add_pos hu hv), div_mul_eq_mul_div, div_le_iff₀ hx0]
    constructor <;> intro h <;> nlinarith [mul_add x u v]
  exact (measure_congr e).trans (exponential_tail (mul_nonneg
    (div_nonneg (sub_nonneg.mpr hx1.le) hx0.le) hu.le))

end PITW
