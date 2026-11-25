/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Scores
public import PITW.BrownianBridge
public import PITW.NormalProfile

/-! Transfer the weak limits to the ranked sample statistics and their rejection regions. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology ENNReal
namespace PITW

/-- Standardised rank discrepancy process on an equally spaced grid. -/
@[expose] def scaledRanks {n : ℕ} (u : Fin n → ℝ) : Path := Real.sqrt n • rankPath u

private theorem norm_scaled {n : ℕ} (u : Fin n → ℝ) :
    ‖scaledRanks u‖ = Real.sqrt n * unsignedScore u := by
  simp [scaledRanks, norm_smul, Real.norm_eq_abs, abs_of_nonneg (Real.sqrt_nonneg _), norm_rankPath]

private theorem signed_scaled {n : ℕ} (v : Fin n → ℝ) :
    signedArea (scaledRanks v) = Real.sqrt n * directedScore v := by
  simp [scaledRanks, signed_rankPath]

variable {Ω Ω' : Type*} [MeasurableSpace Ω] [MeasurableSpace Ω']
  {P : Measure Ω} [IsProbabilityMeasure P] {P' : Measure Ω'} [IsProbabilityMeasure P']

/-- B for the raw ordered PITs, given their rank-process CLT. -/
theorem baseline_score_limit (u : (n : ℕ) → Ω → Fin n → ℝ) (B : Ω' → Path)
    (h : TendstoInDistribution (fun n ω => scaledRanks (u n ω)) atTop B (fun _ => P) P') :
    TendstoInDistribution (fun (n : ℕ) ω => Real.sqrt n * unsignedScore (u n ω)) atTop
      (fun ω => ‖B ω‖) (fun _ => P) P' := by
  simpa only [Function.comp_def, norm_scaled] using h.continuous_comp continuous_norm

/-- Joint conclusions for U and D, each using its own scalar functional. In a shifted
Gaussian model the first component of X refers to ideal PITs with the true shift
removed. The actual adjusted sample uses the estimated shift. -/
theorem adjusted_score_limits (v : (n : ℕ) → Ω → Fin n → ℝ)
    (X : ℕ → Ω → Path × ℝ) (G : Ω' → Path × ℝ)
    (h : TendstoInDistribution X atTop G (fun _ => P) P')
    (hrem : TendstoInMeasure P
      ((fun n ω => scaledRanks (v n ω)) - fun n => project medianProfile ∘ X n)
      atTop 0)
    (hmeas : ∀ n, AEMeasurable (fun ω => scaledRanks (v n ω)) P) :
    TendstoInDistribution (fun (n : ℕ) ω => Real.sqrt n * unsignedScore (v n ω)) atTop
      (fun ω => ‖project medianProfile (G ω)‖) (fun _ => P) P' ∧
    TendstoInDistribution (fun (n : ℕ) ω => Real.sqrt n * directedScore (v n ω)) atTop
      (fun ω => signedArea (G ω).1) (fun _ => P) P' := by
  constructor
  · simpa only [norm_scaled] using adjusted_limit h hrem hmeas
  · simpa only [signed_scaled] using directed_limit h hrem hmeas signed_medianProfile

/-- A null limit determines asymptotic rejection probability wherever its law has
no mass at the boundary of the rejection region. This applies to both one-sided
unsigned tests and to the two-sided directed test. -/
theorem rejection_probability_limit {S : ℕ → Ω → ℝ} {Z : Ω' → ℝ}
    (h : TendstoInDistribution S atTop Z (fun _ => P) P') {R : Set ℝ}
    (hR : MeasurableSet R) (hb : P'.map Z (frontier R) = 0) :
    Tendsto (fun n => P ((S n) ⁻¹' R)) atTop (𝓝 (P' (Z ⁻¹' R))) := by
  have hh := ProbabilityMeasure.tendsto_measure_of_null_frontier_of_tendsto' h.tendsto hb
  change Tendsto (fun n => (P.map (S n)) R) atTop (𝓝 (P'.map Z R)) at hh
  simpa only [Measure.map_apply_of_aemeasurable (h.forall_aemeasurable _) hR,
    Measure.map_apply_of_aemeasurable h.aemeasurable_limit hR] using hh

/-- Rejection probabilities for the two-sided directed test, expressed in terms of the
Gaussian tail at the chosen cutoff. This law has no atoms, so every cutoff is valid. -/
theorem directed_rejection_probability {S : ℕ → Ω → ℝ} {Z : Ω' → ℝ}
    (h : TendstoInDistribution S atTop Z (fun _ => P) P')
    (hlaw : P'.map Z = gaussianReal 0 (1 / 48)) (c : ℝ) :
    Tendsto (fun n => P {ω | c < |S n ω|}) atTop
      (𝓝 (gaussianReal 0 (1 / 48) {x | c < |x|})) := by
  let R := Iio (-c) ∪ Ioi c
  have hR : MeasurableSet R := measurableSet_Iio.union measurableSet_Ioi
  have region : {x : ℝ | c < |x|} = R := by
    ext x; simp only [mem_ofPred_eq, R, mem_union, mem_Iio, mem_Ioi, lt_abs]; grind
  have atom : NullSingletonClass (gaussianReal 0 (1 / 48)) :=
    nullSingletonClass_gaussianReal (by norm_num)
  have hb : P'.map Z (frontier R) = 0 := by
    rw [hlaw]
    apply measure_mono_null (t := ({-c} ∪ {c} : Set ℝ))
    · intro x hx
      rcases frontier_union_subset _ _ hx with hx | hx
      · exact Or.inl (by simpa only [frontier_Iio] using hx.1)
      · exact Or.inr (by simpa only [frontier_Ioi] using hx.2)
    · exact measure_union_null (measure_singleton _) (measure_singleton _)
  have result := rejection_probability_limit h hR hb
  rw [← Measure.map_apply_of_aemeasurable h.aemeasurable_limit hR, hlaw] at result
  rw [← region] at result
  exact result

/-- Asymptotic rejection probability of the directed rank statistic under the
joint rank/median CLT and a negligible sample-adjustment error. -/
theorem pinned_directed_test_size (W : NNReal → Ω' → ℝ) (hW : IsPreBrownianReal W P')
    (hint : ∀ ω, Integrable (fun t => pinned W t ω))
    (hG : HasGaussianLaw (fun ω => (hint ω).toL1 (fun t => pinned W t ω)) P')
    (hB : IntegrableHalves P' (pinned W))
    (hprod : ∀ s ∈ Icc (0 : ℝ) 1,
      IntegrableHalves P' (fun t ω => pinned W s ω * pinned W t ω))
    (harea : IntegrableHalves P' (fun t ω => contrast (fun s => pinned W s ω) * pinned W t ω))
    (v : (n : ℕ) → Ω → Fin n → ℝ) (X : ℕ → Ω → Path × ℝ)
    (h : TendstoInDistribution X atTop
      (fun ω => ((hint ω).toL1 (fun t => pinned W t ω), pinned W (1 / 2) ω)) (fun _ => P) P')
    (hrem : TendstoInMeasure P
      ((fun n ω => scaledRanks (v n ω)) - fun n => project medianProfile ∘ X n) atTop 0)
    (hmeas : ∀ n, AEMeasurable (fun ω => scaledRanks (v n ω)) P) (c : ℝ) :
    Tendsto (fun (n : ℕ) => P {ω | c < |Real.sqrt n * directedScore (v n ω)|}) atTop
      (𝓝 (gaussianReal 0 (1 / 48) {x | c < |x|})) := by
  apply directed_rejection_probability (adjusted_score_limits v X _ h hrem hmeas).2
  simpa only [signedArea_toL1] using
    (pinned_directed_law hW hint hG hB hprod harea)

/-- Directed test size with only the sampling assumptions left. Brownian motion
supplies all regularity, Gaussianity and moment inputs for the reference process. -/
theorem brownian_directed_test_size (W : NNReal → Ω' → ℝ) (hW : IsBrownianReal W P')
    (v : (n : ℕ) → Ω → Fin n → ℝ) (X : ℕ → Ω → Path × ℝ)
    (h : TendstoInDistribution X atTop
      (fun ω => (unitToL1 (brownianBridge W ω), pinned W (1 / 2) ω)) (fun _ => P) P')
    (hrem : TendstoInMeasure P
      ((fun n ω => scaledRanks (v n ω)) - fun n => project medianProfile ∘ X n) atTop 0)
    (hmeas : ∀ n, AEMeasurable (fun ω => scaledRanks (v n ω)) P) (c : ℝ) :
    Tendsto (fun (n : ℕ) => P {ω | c < |Real.sqrt n * directedScore (v n ω)|}) atTop
      (𝓝 (gaussianReal 0 (1 / 48) {x | c < |x|})) := by
  apply directed_rejection_probability (adjusted_score_limits v X _ h hrem hmeas).2
  exact (Measure.map_congr (brownianBridge_area_ae hW)).trans (brownian_directed_law hW)

end PITW
