/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Limits

/-! Symmetry of the actual median projection profile, using Mathlib's standard
Gaussian CDF. Extending from its range by zero handles both endpoints. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Function
namespace PITW

/-- Standard Gaussian CDF. -/
abbrev Φ : ℝ → ℝ := cdf (gaussianReal 0 1)

private theorem cdf_integral (a : ℝ) : Φ a = ∫ x in Iic a, gaussianPDFReal 0 1 x := by
  rw [Φ, cdf_eq_real, Measure.real, gaussianReal_apply_eq_integral _ one_ne_zero,
    ENNReal.toReal_ofReal (integral_nonneg (fun x => gaussianPDFReal_nonneg _ _ x))]

theorem normalPDF_continuous : Continuous (gaussianPDFReal 0 1) := by
  rw [gaussianPDFReal_def]; fun_prop

theorem normalCDF_deriv (x : ℝ) : HasDerivAt Φ (gaussianPDFReal 0 1 x) x := by
  have eq : Φ = fun u => Φ 0 + ∫ t in 0..u, gaussianPDFReal 0 1 t := by
    funext u
    rw [cdf_integral, cdf_integral,
      ← intervalIntegral.integral_Iic_sub_Iic (integrable_gaussianPDFReal 0 1).integrableOn
        (integrable_gaussianPDFReal 0 1).integrableOn]
    ring
  rw [eq]
  exact (intervalIntegral.integral_hasDerivAt_right (normalPDF_continuous.intervalIntegrable ..)
    normalPDF_continuous.stronglyMeasurable.stronglyMeasurableAtFilter
    normalPDF_continuous.continuousAt).const_add _

theorem normalCDF_strictMono : StrictMono Φ :=
  strictMono_of_deriv_pos fun t => (normalCDF_deriv t).deriv ▸ gaussianPDFReal_pos _ _ _ one_ne_zero

theorem normalCDF_neg (z : ℝ) : Φ (-z) = 1 - Φ z := by
  let μ := gaussianReal 0 1
  have : NullSingletonClass μ := nullSingletonClass_gaussianReal one_ne_zero
  have neg : μ.map (fun x : ℝ => -x) = μ := by simp [μ, gaussianReal_map_neg]
  change cdf μ (-z) = 1 - cdf μ z
  simp only [cdf_eq_real]
  calc
    μ.real (Iic (-z)) = (μ.map (fun x : ℝ => -x)).real (Iic (-z)) := by rw [neg]
    _ = μ.real (Ici z) := by rw [map_measureReal_apply (by fun_prop) measurableSet_Iic]; simp
    _ = 1 - μ.real (Iio z) := by rw [← compl_Iio, probReal_compl_eq_one_sub measurableSet_Iio]
    _ = _ := by rw [measureReal_congr (Iio_ae_eq_Iic (μ := μ))]

/-- On t = Φ(z), the normalised density φ(z)/φ(0) simplifies to exp(-z²/2). -/
def normalProfile : ℝ → ℝ := extend Φ (fun z => Real.exp (-(z ^ 2) / 2)) (fun _ => 0)

theorem normalProfile_cdf (z : ℝ) :
    normalProfile (Φ z) = gaussianPDFReal 0 1 z / gaussianPDFReal 0 1 0 := by
  rw [normalProfile, normalCDF_strictMono.injective.extend_apply, gaussianPDFReal_def]
  simp only [sub_zero, NNReal.coe_one, mul_one, zero_pow (by decide : 2 ≠ 0), neg_zero, zero_div,
    Real.exp_zero, mul_one]
  field_simp

/-- With the displacement measured in median-PIT units, the first-order change
in each Gaussian PIT has precisely the coefficient used in the projection. -/
theorem centeredPIT_deriv (z : ℝ) :
    HasDerivAt (fun m => Φ (z - m / gaussianPDFReal 0 1 0))
      (-normalProfile (Φ z)) 0 := by
  rw [normalProfile_cdf]
  have h := (normalCDF_deriv (z - 0 / gaussianPDFReal 0 1 0)).comp 0
    (((hasDerivAt_id (0 : ℝ)).div_const (gaussianPDFReal 0 1 0)).const_sub z)
  simpa [Function.comp_def, div_eq_mul_inv] using h

private abbrev φ := gaussianPDFReal 0 1

private theorem density_factor (z : ℝ) : φ z = φ 0 * Real.exp (-(z ^ 2) / 2) := by
  simp [gaussianPDFReal_def]

private theorem density_deriv (z : ℝ) : HasDerivAt φ (-z * φ z) z := by
  have h := (((((hasDerivAt_id z).pow 2).neg).div_const 2).exp).const_mul (φ 0)
  rw [density_factor z]
  convert h using 1
  · funext x; exact density_factor x
  · simp; ring

private theorem density_lipschitz (x y : ℝ) : |φ y - φ x| ≤ φ 0 * |y - x| := by
  apply Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
    (fun z _ => (density_deriv z).hasDerivWithinAt) _ convex_univ (mem_univ x) (mem_univ y)
  intro z _
  have h : |z| ≤ Real.exp (z ^ 2 / 2) := by
    apply le_trans _ (Real.add_one_le_exp _)
    nlinarith [sq_nonneg (|z| - 1), sq_abs z]
  have hh := mul_le_mul_of_nonneg_right h (Real.exp_pos (-(z ^ 2) / 2)).le
  rw [← Real.exp_add] at hh
  have hz : z ^ 2 / 2 + -(z ^ 2) / 2 = 0 := by ring
  rw [hz, Real.exp_zero] at hh
  rw [Real.norm_eq_abs, abs_mul, abs_neg, abs_of_pos (gaussianPDFReal_pos _ _ _ one_ne_zero)]
  change |z| * φ z ≤ φ 0
  rw [density_factor z]
  nlinarith [mul_le_mul_of_nonneg_left hh (gaussianPDFReal_nonneg 0 1 0)]

/-- Uniform quadratic remainder for a common displacement on the Gaussian scale.
This bound can be applied to every order statistic, including extreme ranks. -/
theorem normal_shift_remainder (z δ : ℝ) :
    |Φ (z - δ) - Φ z + δ * gaussianPDFReal 0 1 z| ≤ gaussianPDFReal 0 1 0 * δ ^ 2 := by
  let g := fun y => Φ y - y * φ z
  let I := Icc (z - |δ|) (z + |δ|)
  have hd (y : ℝ) : HasDerivAt g (φ y - φ z) y := by
    simpa only [g, φ, id_eq, one_mul] using
      (normalCDF_deriv y).fun_sub ((hasDerivAt_id y).mul_const (φ z))
  have bound (y : ℝ) (hy : y ∈ I) : ‖φ y - φ z‖ ≤ φ 0 * |δ| := by
    apply (density_lipschitz z y).trans
    apply mul_le_mul_of_nonneg_left _ (gaussianPDFReal_nonneg ..)
    apply abs_le.mpr; constructor <;> linarith [hy.1, hy.2]
  have hz : z ∈ I := ⟨by linarith [abs_nonneg δ], by linarith [abs_nonneg δ]⟩
  have hzδ : z - δ ∈ I := ⟨by linarith [le_abs_self δ], by linarith [neg_le_abs δ]⟩
  have h := Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
    (fun y _ => (hd y).hasDerivWithinAt) bound (convex_Icc ..) hz hzδ
  have he : g (z - δ) - g z = Φ (z - δ) - Φ z + δ * φ z := by dsimp [g]; ring
  rw [he, Real.norm_eq_abs, Real.norm_eq_abs, sub_sub_cancel_left, abs_neg] at h
  calc
    _ ≤ _ := h
    _ = _ := by rw [mul_assoc, ← sq, sq_abs]

theorem normalCDF_lipschitz (x y : ℝ) : |Φ y - Φ x| ≤ gaussianPDFReal 0 1 0 * |y - x| := by
  apply Convex.norm_image_sub_le_of_norm_hasDerivWithin_le
    (fun z _ => (normalCDF_deriv z).hasDerivWithinAt) _ convex_univ (mem_univ x) (mem_univ y)
  intro z _
  rw [Real.norm_eq_abs, abs_of_nonneg (gaussianPDFReal_nonneg ..)]
  change φ z ≤ φ 0
  rw [density_factor z]
  exact mul_le_of_le_one_right (gaussianPDFReal_nonneg ..)
    (Real.exp_le_one_iff.mpr (by nlinarith [sq_nonneg z]))

theorem normalCDF_range {t : ℝ} (ht : t ∈ Ioo (0 : ℝ) 1) : ∃ z, Φ z = t := by
  obtain ⟨a, ha⟩ := ((tendsto_order.mp (tendsto_cdf_atBot (gaussianReal 0 1))).2 t ht.1).exists
  obtain ⟨b, hb⟩ := ((tendsto_order.mp (tendsto_cdf_atTop (gaussianReal 0 1))).1 t ht.2).exists
  exact intermediate_value_univ a b
    (continuous_iff_continuousAt.mpr fun x => (normalCDF_deriv x).continuousAt) ⟨ha.le, hb.le⟩

theorem normalProfile_outside {t : ℝ} (ht : t ∉ Icc (0 : ℝ) 1) : normalProfile t = 0 := by
  apply extend_apply'
  exact fun ⟨x, hx⟩ => ht (hx ▸ ⟨cdf_nonneg _ x, cdf_le_one _ x⟩)

theorem normalProfile_symmetric (t : ℝ) : normalProfile (1 - t) = normalProfile t := by
  by_cases h : ∃ z, Φ z = t
  · obtain ⟨z, rfl⟩ := h
    rw [← normalCDF_neg]
    simp [normalProfile, normalCDF_strictMono.injective.extend_apply]
  · have hn : ¬ ∃ z, Φ z = 1 - t := by
      rintro ⟨z, hz⟩
      exact h ⟨-z, by rw [normalCDF_neg, hz]; ring⟩
    simp [normalProfile, extend_apply' _ _ _ hn, extend_apply' _ _ _ h]

theorem normalCDF_zero : Φ 0 = 1 / 2 := by
  have h := normalCDF_neg 0
  rw [neg_zero] at h
  linarith

theorem normalProfile_half : normalProfile (1 / 2) = 1 := by
  rw [← normalCDF_zero, normalProfile, normalCDF_strictMono.injective.extend_apply]; norm_num

theorem normalProfile_integrable : Integrable normalProfile := by
  have hc : Continuous Φ := continuous_iff_continuousAt.mpr
    fun z => (normalCDF_deriv z).continuousAt
  have hm : Measurable normalProfile :=
    (hc.measurableEmbedding normalCDF_strictMono.injective).measurable_extend
      (by fun_prop) measurable_const
  apply ((integrableOn_const (s := Ioc (0 : ℝ) 1) measure_Ioc_lt_top.ne
    (C := (1 : ℝ))).integrable_indicator measurableSet_Ioc).mono' hm.aestronglyMeasurable
  filter_upwards with t
  by_cases h : ∃ z, Φ z = t
  · obtain ⟨z, rfl⟩ := h
    have hpos : 0 < Φ z :=
      (cdf_nonneg _ _).trans_lt (normalCDF_strictMono (show z - 1 < z by linarith))
    rw [indicator_of_mem (show Φ z ∈ Ioc 0 1 from ⟨hpos, cdf_le_one _ _⟩),
      normalProfile, normalCDF_strictMono.injective.extend_apply, Real.norm_eq_abs,
      abs_of_pos (Real.exp_pos _)]
    exact Real.exp_le_one_iff.mpr (by nlinarith [sq_nonneg z])
  · simp only [normalProfile, extend_apply' _ _ _ h, norm_zero]
    by_cases ht : t ∈ Ioc (0 : ℝ) 1 <;> simp [ht]

/-- The median correction term as an L¹ path. -/
@[expose] def medianProfile : Path := normalProfile_integrable.toL1 normalProfile

theorem signed_medianProfile : signedArea medianProfile = 0 :=
  (signedArea_toL1 _ normalProfile_integrable).trans
    (contrast_symmetric fun t _ => normalProfile_symmetric t)

end PITW
