/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Bridge

/-! Continuous mapping and Slutsky steps for the PIT tests. Paths on the probability
interval are extended by zero outside it. The coordinate for the median is kept
separate because point evaluation does not descend to an L¹ equivalence class. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Filter
open scoped ENNReal
namespace PITW

/-- Integrable discrepancy (zero outside the probability interval). -/
abbrev Path := Lp ℝ 1 (volume : Measure ℝ)

scoped instance : MeasurableSpace Path := borel _
scoped instance : BorelSpace Path := ⟨rfl⟩

local instance : Fact ((1 : ℝ≥0∞) ≠ ∞) := ⟨by simp⟩

private def areaOn (s : Set ℝ) : Path →L[ℝ] ℝ :=
  L1.integralCLM.comp (LpToLpRestrictCLM ℝ ℝ ℝ volume 1 s)

/-- Continuous linear version of the signed area. -/
def signedArea : Path →L[ℝ] ℝ :=
  areaOn (Ioc 0 (1 / 2)) - areaOn (Ioc (1 / 2) 1)

private theorem areaOn_apply (s : Set ℝ) (f : Path) :
    areaOn s f = ∫ t in s, f t := by
  let a := LpToLpRestrictCLM ℝ ℝ ℝ volume 1 s f
  change L1.integralCLM a = _
  rw [← L1.integral_eq, ← Integrable.toL1_coeFn a (L1.integrable_coeFn a), ← integral_eq]
  exact integral_congr_ae (LpToLpRestrictCLM_coeFn ℝ s f)

/-- Interprets the linear map on any chosen integrable representative. -/
theorem signedArea_toL1 (f : ℝ → ℝ) (hf : Integrable f) :
    signedArea (hf.toL1 f) = contrast f := by
  simp only [signedArea, sub_apply, areaOn_apply, contrast,
    intervalIntegral.integral_of_le (show (0 : ℝ) ≤ 1 / 2 by norm_num),
    intervalIntegral.integral_of_le (show (1 / 2 : ℝ) ≤ 1 by norm_num)]
  congr 1 <;> exact integral_congr_ae (ae_restrict_of_ae hf.coeFn_toL1)

/-- Path and midpoint fluctuation after standardisation. -/
@[expose] def project (k : Path) (x : Path × ℝ) : Path := x.1 - x.2 • k

theorem continuous_project (k : Path) : Continuous (project k) :=
  continuous_fst.sub (continuous_snd.smul continuous_const)

theorem signed_project {k : Path} (hk : signedArea k = 0) (x : Path × ℝ) :
    signedArea (project k x) = signedArea x.1 := by simp [project, hk]

variable {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
  {P : Measure Ω} [IsProbabilityMeasure P] {P' : Measure Ω'} [IsProbabilityMeasure P']
  {X : ℕ → Ω → Path × ℝ} {G : Ω' → Path × ℝ}

/-- Baseline limit from joint weak convergence of the unadjusted discrepancy and its
midpoint. The L¹ norm on the right is the integrated absolute bridge. -/
theorem baseline_limit (h : TendstoInDistribution X atTop G (fun _ => P) P') :
    TendstoInDistribution (fun n ω => ‖(X n ω).1‖) atTop
      (fun ω => ‖(G ω).1‖) (fun _ => P) P' :=
  h.continuous_comp (g := fun x : Path × ℝ => ‖x.1‖) (continuous_norm.comp continuous_fst)

variable {A : ℕ → Ω → Path} {k : Path}

/-- Joint process convergence and a vanishing median-linearisation remainder imply
weak convergence of the actual adjusted discrepancy to the projected bridge. -/
theorem adjusted_path_limit (h : TendstoInDistribution X atTop G (fun _ => P) P')
    (hrem : TendstoInMeasure P (A - fun n => project k ∘ X n) atTop 0)
    (hmeas : ∀ n, AEMeasurable (A n) P) :
    TendstoInDistribution A atTop (project k ∘ G) (fun _ => P) P' :=
  tendstoInDistribution_of_tendstoInMeasure_sub A _
    (h.continuous_comp (continuous_project k)) hrem hmeas

/-- Adjusted unsigned test, with the estimation term inside the absolute value. -/
theorem adjusted_limit (h : TendstoInDistribution X atTop G (fun _ => P) P')
    (hrem : TendstoInMeasure P (A - fun n => project k ∘ X n) atTop 0)
    (hmeas : ∀ n, AEMeasurable (A n) P) :
    TendstoInDistribution (fun n ω => ‖A n ω‖) atTop
      (fun ω => ‖project k (G ω)‖) (fun _ => P) P' :=
  (adjusted_path_limit h hrem hmeas).continuous_comp continuous_norm

/-- Directed test, with the same limiting random variable as the unadjusted signed area. -/
theorem directed_limit (h : TendstoInDistribution X atTop G (fun _ => P) P')
    (hrem : TendstoInMeasure P (A - fun n => project k ∘ X n) atTop 0)
    (hmeas : ∀ n, AEMeasurable (A n) P) (hk : signedArea k = 0) :
    TendstoInDistribution (fun n ω => signedArea (A n ω)) atTop
      (fun ω => signedArea (G ω).1) (fun _ => P) P' := by
  simpa only [Function.comp_def, signed_project hk] using
    (adjusted_path_limit h hrem hmeas).continuous_comp signedArea.continuous

end PITW
