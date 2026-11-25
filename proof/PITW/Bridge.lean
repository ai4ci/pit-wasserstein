/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import Mathlib

/-! The directed bridge functional in Section 3 of the manuscript. We split the
integral at one half. Its value at the single midpoint does not affect an integral. -/

public section
noncomputable section
open MeasureTheory Set
namespace PITW

/-- Lower-half area minus upper-half area on the probability scale. -/
@[expose] def contrast (f : ℝ → ℝ) : ℝ :=
  (∫ t in 0..(1 / 2 : ℝ), f t) - ∫ t in (1 / 2 : ℝ)..1, f t

/-- Covariance of the standard Brownian bridge on the unit interval. -/
@[expose] def bridgeKernel (s t : ℝ) : ℝ := min s t - s * t

private theorem reflect_lower (f : ℝ → ℝ) :
    (∫ t in 0..(1 / 2 : ℝ), f (1 - t)) = ∫ t in (1 / 2 : ℝ)..1, f t := by
  rw [intervalIntegral.integral_comp_sub_left]
  norm_num

theorem contrast_symmetric {k : ℝ → ℝ}
    (hk : ∀ t ∈ Icc (0 : ℝ) (1 / 2), k (1 - t) = k t) : contrast k = 0 := by
  unfold contrast
  rw [← reflect_lower]
  apply sub_eq_zero.mpr
  apply intervalIntegral.integral_congr
  rw [uIcc_of_le (by norm_num)]
  exact fun t ht => (hk t ht).symm

/-- A symmetric fitted profile cancels for every path and every realised shift.
Only integrability on the two halves of the interval is needed. -/
theorem projected_contrast (f k : ℝ → ℝ) (m : ℝ)
    (hf : IntervalIntegrable f volume 0 1) (hk : IntervalIntegrable k volume 0 1)
    (hs : ∀ t ∈ Icc (0 : ℝ) (1 / 2), k (1 - t) = k t) :
    contrast (fun t => f t - m * k t) = contrast f := by
  have left (g : ℝ → ℝ) (hg : IntervalIntegrable g volume 0 1) :
      IntervalIntegrable g volume 0 (1 / 2) :=
    hg.mono_set (by norm_num [uIcc_of_le]; intro x hx; grind)
  have right (g : ℝ → ℝ) (hg : IntervalIntegrable g volume 0 1) :
      IntervalIntegrable g volume (1 / 2) 1 :=
    hg.mono_set (by norm_num [uIcc_of_le]; intro x hx; grind)
  have hzero := contrast_symmetric hs
  unfold contrast at *
  rw [intervalIntegral.integral_sub (left f hf) ((left k hk).const_mul m),
    intervalIntegral.integral_sub (right f hf) ((right k hk).const_mul m)]
  simp only [intervalIntegral.integral_const_mul]
  linear_combination -m * hzero

private theorem left_kernel (s : ℝ) (hs : s ∈ Icc (0 : ℝ) (1 / 2)) :
    contrast (bridgeKernel s) = s / 4 - s ^ 2 / 2 := by
  have hc : Continuous (bridgeKernel s) :=
    (continuous_const.min continuous_id).sub (continuous_const.mul continuous_id)
  have h₁ : (∫ t in 0..s, bridgeKernel s t) = ∫ t in 0..s, (1 - s) * t := by
    apply intervalIntegral.integral_congr
    rw [uIcc_of_le hs.1]
    intro t ht
    simp only [bridgeKernel, min_eq_right ht.2]
    ring
  have h₂ (a b : ℝ) (hab : a ≤ b) (hsa : s ≤ a) :
      (∫ t in a..b, bridgeKernel s t) = ∫ t in a..b, s - s * t := by
    apply intervalIntegral.integral_congr
    rw [uIcc_of_le hab]
    exact fun t ht => by simp [bridgeKernel, min_eq_left (hsa.trans ht.1)]
  unfold contrast
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (hc.intervalIntegrable 0 s) (hc.intervalIntegrable s (1 / 2)),
    h₁, h₂ s (1 / 2) hs.2 le_rfl, h₂ (1 / 2) 1 (by norm_num) hs.2]
  have hi (a b : ℝ) : IntervalIntegrable (fun t : ℝ => s * t) volume a b :=
    (continuous_const.mul continuous_id).intervalIntegrable ..
  simp only [intervalIntegral.integral_sub intervalIntegrable_const (hi _ _),
    intervalIntegral.integral_const, smul_eq_mul]
  rw [intervalIntegral.integral_const_mul _ (fun t : ℝ => t),
    intervalIntegral.integral_const_mul _ (fun t : ℝ => t),
    intervalIntegral.integral_const_mul _ (fun t : ℝ => t)]
  simp only [integral_id]
  ring

private theorem kernel_reflection {s t : ℝ} :
    bridgeKernel (1 - s) (1 - t) = bridgeKernel s t := by
  unfold bridgeKernel
  rcases le_total s t with h | h
  · rw [min_eq_left h, min_eq_right (by linarith)]; ring
  · rw [min_eq_right h, min_eq_left (by linarith)]; ring

/-- The signed double integral of the bridge covariance is 1 / 48. This is
the covariance calculation, prior to identifying it with a random variable's variance. -/
theorem directed_bridge_variance :
    contrast (fun s => contrast (bridgeKernel s)) = 1 / 48 := by
  have antisym (s : ℝ) : contrast (bridgeKernel (1 - s)) = -contrast (bridgeKernel s) := by
    unfold contrast
    rw [← reflect_lower (bridgeKernel s), ← reflect_lower (bridgeKernel (1 - s))]
    simp_rw [kernel_reflection]
    have h (t : ℝ) : bridgeKernel (1 - s) t = bridgeKernel s (1 - t) := by
      simpa using (kernel_reflection (s := s) (t := 1 - t))
    simp_rw [h]
    ring
  change (∫ s in 0..(1 / 2 : ℝ), contrast (bridgeKernel s)) -
    (∫ s in (1 / 2 : ℝ)..1, contrast (bridgeKernel s)) = _
  rw [← reflect_lower]
  simp_rw [antisym]
  rw [intervalIntegral.integral_neg]
  have e : (∫ s in 0..(1 / 2 : ℝ), contrast (bridgeKernel s)) =
      ∫ s in 0..(1 / 2 : ℝ), s / 4 - s ^ 2 / 2 := by
    apply intervalIntegral.integral_congr
    rw [uIcc_of_le (by norm_num)]
    exact left_kernel
  rw [e, intervalIntegral.integral_sub]
  · norm_num [intervalIntegral.integral_div, integral_id, integral_pow]
  all_goals apply Continuous.intervalIntegrable; fun_prop

end PITW
