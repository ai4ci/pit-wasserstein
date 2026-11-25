/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Limits

/-! Identification of the law of the directed bridge integral. All stochastic inputs
are stated explicitly, including the product integrability needed for Fubini. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Function
namespace PITW

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

/-- Fubini integrability on the two halves of the probability interval. -/
@[expose] def IntegrableHalves (P : Measure Ω) (F : ℝ → Ω → ℝ) : Prop :=
  Integrable (uncurry F) ((volume.restrict (Ioc 0 (1 / 2))).prod P) ∧
  Integrable (uncurry F) ((volume.restrict (Ioc (1 / 2) 1)).prod P)

private theorem mean_contrast {F : ℝ → Ω → ℝ} (h : IntegrableHalves P F) :
    (∫ ω, contrast (fun t => F t ω) ∂P) = contrast (fun t => ∫ ω, F t ω ∂P) := by
  simp only [contrast, intervalIntegral.integral_of_le (show (0 : ℝ) ≤ 1 / 2 by norm_num),
    intervalIntegral.integral_of_le (show (1 / 2 : ℝ) ≤ 1 by norm_num)]
  calc
    _ = _ := integral_sub h.1.integral_prod_right h.2.integral_prod_right
    _ = _ := congrArg₂ (· - ·) (integral_integral_swap h.1).symm
      (integral_integral_swap h.2).symm

private theorem contrast_congr {f g : ℝ → ℝ} (h : EqOn f g (Icc 0 1)) :
    contrast f = contrast g := by
  unfold contrast
  congr 1 <;> apply intervalIntegral.integral_congr
  all_goals rw [uIcc_of_le (by norm_num)]; intro x hx; apply h; grind

private theorem contrast_mul (a : ℝ) (f : ℝ → ℝ) :
    contrast (fun t => a * f t) = a * contrast f := by
  simp only [contrast, intervalIntegral.integral_const_mul a f, mul_sub]

/-- The exact Gaussian law of the *limiting* signed area. The Gaussian assumption is
on the path as an L¹-valued random variable. The variance is derived from its timewise
second moments. No scalar variance or scalar Gaussian law is assumed. -/
theorem directed_gaussian_reference (B : ℝ → Ω → ℝ)
    (hint : ∀ ω, Integrable (fun t => B t ω))
    (hG : HasGaussianLaw (fun ω => (hint ω).toL1 (fun t => B t ω)) P)
    (hmean : ∀ t ∈ Icc (0 : ℝ) 1, (∫ ω, B t ω ∂P) = 0)
    (hcov : ∀ s ∈ Icc (0 : ℝ) 1, ∀ t ∈ Icc (0 : ℝ) 1,
      (∫ ω, B s ω * B t ω ∂P) = bridgeKernel s t)
    (hB : IntegrableHalves P B)
    (hprod : ∀ s ∈ Icc (0 : ℝ) 1, IntegrableHalves P (fun t ω => B s ω * B t ω))
    (harea : IntegrableHalves P (fun t ω => contrast (fun s => B s ω) * B t ω)) :
    P.map (fun ω => contrast (fun t => B t ω)) = gaussianReal 0 (1 / 48) := by
  let D := fun ω => contrast (fun t => B t ω)
  have hD : HasGaussianLaw D P := (hG.map signedArea).congr <|
    ae_of_all P fun ω => signedArea_toL1 _ (hint ω)
  have eD : (∫ ω, D ω ∂P) = 0 := by
    rw [show (∫ ω, D ω ∂P) = _ from mean_contrast hB,
      contrast_congr (g := fun _ => 0) hmean]
    simp [contrast]
  have cross (s : ℝ) (hs : s ∈ Icc (0 : ℝ) 1) :
      (∫ ω, D ω * B s ω ∂P) = contrast (bridgeKernel s) := by
    calc
      _ = ∫ ω, contrast (fun t => B s ω * B t ω) ∂P := by
        simp only [contrast_mul, D, mul_comm]
      _ = _ := (mean_contrast (hprod s hs)).trans (contrast_congr (hcov s hs))
  have vD : Var[D; P] = 1 / 48 := by
    rw [variance_eq_integral hD.aemeasurable, eD]
    simp only [sub_zero, pow_two]
    calc
      _ = ∫ ω, contrast (fun t => D ω * B t ω) ∂P := by simp only [contrast_mul, D]
      _ = _ := (mean_contrast harea).trans ((contrast_congr cross).trans directed_bridge_variance)
  change P.map D = _
  rw [hD.map_eq_gaussianReal, eD, vD]
  congr 1
  apply NNReal.eq
  norm_num

end PITW
