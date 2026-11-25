/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.GaussianReference

/-! The mean and covariance inputs of the reference theorem follow from pinning
a Mathlib pre-Brownian motion at time one. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set
namespace PITW

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]
  {W : NNReal → Ω → ℝ}

/-- The path W(t) - t W(1) on the unit interval, extended by zero for the L¹ model. -/
@[expose] def pinned (W : NNReal → Ω → ℝ) (t : ℝ) (ω : Ω) : ℝ :=
  (Icc (0 : ℝ) 1).indicator (fun u => W u.toNNReal ω - u * W 1 ω) t

omit [IsProbabilityMeasure P] in
theorem pinned_mean (hW : IsPreBrownianReal W P) (t : ℝ) (ht : t ∈ Icc (0 : ℝ) 1) :
    (∫ ω, pinned W t ω ∂P) = 0 := by
  simp only [pinned, indicator_of_mem ht]
  rw [integral_sub (hW.integrable_eval _) ((hW.integrable_eval 1).const_mul t),
    integral_const_mul, hW.integral_eval, hW.integral_eval]
  ring

theorem pinned_secondMoment (hW : IsPreBrownianReal W P) (s t : ℝ)
    (hs : s ∈ Icc (0 : ℝ) 1) (ht : t ∈ Icc (0 : ℝ) 1) :
    (∫ ω, pinned W s ω * pinned W t ω ∂P) = bridgeKernel s t := by
  have hL (u : NNReal) := (hW.isGaussianProcess.hasGaussianLaw_eval u).memLp_two
  have hpin (u : ℝ) (hu : u ∈ Icc (0 : ℝ) 1) : MemLp (pinned W u) 2 P := by
    have eq : pinned W u = W u.toNNReal - u • W 1 := by
      funext ω; simp [pinned, hu]
    rw [eq]
    exact (hL u.toNNReal).sub ((hL 1).const_smul u)
  have cov := covariance_eq_sub (hpin s hs) (hpin t ht)
  rw [pinned_mean hW s hs, pinned_mean hW t ht, mul_zero, sub_zero] at cov
  simp only [Pi.mul_apply] at cov
  rw [← cov]
  change cov[fun ω => pinned W s ω, fun ω => pinned W t ω; P] = _
  simp only [pinned, indicator_of_mem hs, indicator_of_mem ht]
  change cov[W s.toNNReal - s • W 1, W t.toNNReal - t • W 1; P] = _
  rw [covariance_sub_sub (hL _) ((hL 1).const_smul s) (hL _) ((hL 1).const_smul t)]
  simp only [covariance_smul_left, covariance_smul_right, hW.covariance_eval]
  have hs' : s.toNNReal ≤ 1 := Real.toNNReal_le_one.mpr hs.2
  have ht' : t.toNNReal ≤ 1 := Real.toNNReal_le_one.mpr ht.2
  simp [bridgeKernel, min_eq_left hs', min_eq_right ht', Real.coe_toNNReal _ hs.1,
    Real.coe_toNNReal _ ht.1]
  ring

/-- Directed reference law for a pinned pre-Brownian motion with an integrable,
Gaussian path version. The mean and covariance premises are now discharged. -/
theorem pinned_directed_law (hW : IsPreBrownianReal W P)
    (hint : ∀ ω, Integrable (fun t => pinned W t ω))
    (hG : HasGaussianLaw (fun ω => (hint ω).toL1 (fun t => pinned W t ω)) P)
    (hB : IntegrableHalves P (pinned W))
    (hprod : ∀ s ∈ Icc (0 : ℝ) 1,
      IntegrableHalves P (fun t ω => pinned W s ω * pinned W t ω))
    (harea : IntegrableHalves P (fun t ω => contrast (fun s => pinned W s ω) * pinned W t ω)) :
    P.map (fun ω => contrast (fun t => pinned W t ω)) = gaussianReal 0 (1 / 48) :=
  directed_gaussian_reference _ hint hG (pinned_mean hW)
    (fun s hs t ht => pinned_secondMoment hW s t hs ht) hB hprod harea

end PITW
