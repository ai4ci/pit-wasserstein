/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import Mathlib.MeasureTheory.Function.ConvergenceInMeasure
public import Mathlib.MeasureTheory.Integral.Layercake
public import Mathlib.MeasureTheory.Integral.Prod
public import Mathlib.MeasureTheory.Constructions.UnitInterval
import Mathlib.Analysis.SpecialFunctions.ImproperIntegrals

/-! Pointwise convergence in probability implies convergence of the integrated error when
the absolute errors have a uniform integrable tail bound. -/

public section
noncomputable section

open MeasureTheory Filter Set Function
open scoped Topology unitInterval

namespace PITW

private def envelope (C b : ℝ) : ℝ :=
  (Ioc 0 2).indicator (fun _ => 1) b + (Ioi 2).indicator (fun x => C / x ^ 2) b

private lemma integrable_envelope (C : ℝ) : Integrable (envelope C) := by
  have h : IntegrableOn (fun x : ℝ => x ^ (-2 : ℝ)) (Ioi 2) :=
    integrableOn_Ioi_rpow_of_lt (by norm_num) (by norm_num)
  have h' : IntegrableOn (fun x : ℝ => C / x ^ 2) (Ioi 2) := by
    simpa only [IntegrableOn, div_eq_mul_inv, Real.rpow_neg_ofNat, zpow_neg,
      zpow_ofNat] using h.const_mul C
  exact ((integrableOn_const (C := (1 : ℝ)) (by simp)).integrable_indicator measurableSet_Ioc).add
    (h'.integrable_indicator measurableSet_Ioi)

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

/-- A quadratic probability tail bound makes the layer-cake integrals uniformly bounded
and converts convergence in probability into convergence of the first absolute moments. -/
private lemma bounded_means (Y : ℕ → Ω → ℝ) (C : ℝ)
    (hint : ∀ n, Integrable (Y n) P)
    (hprob : TendstoInMeasure P Y atTop 0)
    (htail : ∀ n (b : ℝ), 2 ≤ b → P.real {ω | b ≤ |Y n ω|} ≤ C / b ^ 2) :
    (∀ n, (∫ ω, |Y n ω| ∂P) ≤ ∫ b in Ioi 0, envelope C b) ∧
    Tendsto (fun n => ∫ ω, |Y n ω| ∂P) atTop (𝓝 0) := by
  let tail (n : ℕ) (b : ℝ) := P.real {ω | b ≤ |Y n ω|}
  have hmeas n : Measurable (tail n) := by
    apply Antitone.measurable
    intro a b hab
    exact measureReal_mono (fun _ hw => hab.trans hw)
  have he : IntegrableOn (envelope C) (Ioi 0) := (integrable_envelope C).integrableOn
  have bound n : ∀ᵐ b ∂volume.restrict (Ioi (0 : ℝ)), ‖tail n b‖ ≤ envelope C b := by
    filter_upwards [ae_restrict_mem measurableSet_Ioi] with b hb
    rw [Real.norm_eq_abs, abs_of_nonneg (show 0 ≤ tail n b from measureReal_nonneg)]
    by_cases h : 2 < b
    · simpa [envelope, h, h.not_ge] using htail n b h.le
    · have hb' : b ∈ Ioc (0 : ℝ) 2 := ⟨hb, le_of_not_gt h⟩
      rw [envelope, indicator_of_mem hb', indicator_of_notMem (show b ∉ Ioi 2 from h), add_zero]
      exact measureReal_le_one
  have heq n : (∫ ω, |Y n ω| ∂P) = ∫ b in Ioi 0, tail n b :=
    (hint n).abs.integral_eq_integral_meas_le (ae_of_all _ fun _ => abs_nonneg _)
  simp_rw [heq]
  constructor
  · intro n
    exact integral_mono_ae (he.mono' (hmeas n).aestronglyMeasurable (bound n)) he
      ((bound n).mono fun b hb => (le_abs_self (tail n b)).trans hb)
  · have hp := tendstoInMeasure_iff_measureReal_norm.mp hprob
    have limit : Tendsto (fun n => ∫ b in Ioi 0, tail n b) atTop
        (𝓝 (∫ _ in Ioi (0 : ℝ), (0 : ℝ))) := by
      apply tendsto_integral_of_dominated_convergence (envelope C)
        (fun n => (hmeas n).aestronglyMeasurable) he bound
      filter_upwards [ae_restrict_mem measurableSet_Ioi] with b hb
      simpa [tail, Real.norm_eq_abs] using hp b hb
    simpa using limit

/-- A common quadratic tail bound and pointwise convergence in probability give convergence
in probability of the integrated absolute discrepancy. -/
theorem integrated_tendstoInMeasure (D : ℕ → Ω → I → ℝ) (C : ℝ)
    (hint : ∀ n, Integrable (uncurry (D n)) (P.prod volume))
    (hpt : ∀ᵐ t : I, TendstoInMeasure P (fun n ω => D n ω t) atTop 0)
    (htail : ∀ᵐ t : I, ∀ n (b : ℝ), 2 ≤ b → P.real {ω | b ≤ |D n ω t|} ≤ C / b ^ 2) :
    TendstoInMeasure P (fun n ω => ∫ t : I, |D n ω t|) atTop 0 := by
  let mean n (t : I) := ∫ ω, |D n ω t| ∂P
  let K := ∫ b in Ioi 0, envelope C b
  have sections : ∀ᵐ t : I, ∀ n, Integrable (fun ω => D n ω t) P :=
    ae_all_iff.mpr fun n => (hint n).prod_left_ae
  have h : ∀ᵐ t : I, (∀ n, mean n t ≤ K) ∧ Tendsto (fun n => mean n t) atTop (𝓝 0) := by
    filter_upwards [sections, hpt, htail] with t ht hp hb
    exact bounded_means (fun n ω => D n ω t) C ht hp hb
  have lim : Tendsto (fun n => ∫ t, mean n t) atTop (𝓝 (∫ _ : I, (0 : ℝ))) := by
    apply tendsto_integral_of_dominated_convergence (fun _ => K)
      (fun n => (hint n).abs.integral_prod_right.aestronglyMeasurable) (integrable_const _)
    · intro n
      filter_upwards [h] with t ht
      simpa [Real.norm_eq_abs, abs_of_nonneg (integral_nonneg fun ω => abs_nonneg (D n ω t)),
        mean] using ht.1 n
    · exact h.mono fun _ ht => ht.2
  have ex : Tendsto (fun n => ∫ ω, ∫ t : I, |D n ω t| ∂volume ∂P) atTop (𝓝 0) := by
    have swap n : (∫ ω, ∫ t : I, |D n ω t| ∂volume ∂P) = ∫ t : I, mean n t :=
      integral_integral_swap (f := fun ω t => |D n ω t|) (hint n).abs
    simpa only [swap, integral_zero] using lim
  apply tendstoInMeasure_iff_measureReal_norm.mpr
  intro ε hε
  have nn n ω : 0 ≤ ∫ t : I, |D n ω t| := integral_nonneg fun _ => abs_nonneg _
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs, abs_of_nonneg (nn ..)]
  apply squeeze_zero (fun _ => measureReal_nonneg)
  · intro n
    exact (le_div_iff₀ hε).mpr ((mul_comm ..).le.trans
      (mul_meas_ge_le_integral_of_nonneg (ae_of_all P (nn n)) (hint n).abs.integral_prod_left ε))
  · simpa using ex.div_const ε

end PITW
