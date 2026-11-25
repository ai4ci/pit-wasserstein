/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.AdjustedScores
public import PITW.UnitScores

/-! Finite-sample comparison with the scores of the projected raw empirical path. -/

public section
noncomputable section

open MeasureTheory ProbabilityTheory Set
open scoped unitInterval

namespace PITW

/-- For any row of normal scores, the largest error among the three scaled statistics
is bounded by the midpoint plotting error plus the integrated fitted CDF approximation error. -/
theorem iid_score_error_bound {Ω : Type*} (Z : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) :
    ‖sampleScores n (orderedPIT Z (n + 1) ω) -
      unitScores (empiricalPath (fun j => Φ ∘ Z j) (n + 1) ω,
        empiricalAt (fun j => Φ ∘ Z j) (n + 1) unitHalf ω)‖ ≤
    (1 / 2) / rankScale n +
      ∫ t : I, |adjustedEmpirical n (orderedPIT Z (n + 1) ω) t -
        (empiricalAt (fun j => Φ ∘ Z j) (n + 1) t ω -
          empiricalAt (fun j => Φ ∘ Z j) (n + 1) unitHalf ω * normalProfile t)| := by
  let U j := Φ ∘ Z j
  let z := orderedPIT Z (n + 1) ω
  let X := empiricalPath U (n + 1) ω
  let a := empiricalAt U (n + 1) unitHalf ω
  let A := adjustedEmpirical n z
  let B (t : I) := empiricalAt U (n + 1) t ω - a * normalProfile t
  have hz : Monotone z := Tuple.monotone_sort (fun i : Fin (n + 1) => Z i ω)
  have sort : (fun i => Φ (z i)) = orderedPIT U (n + 1) ω := by
    let r (i : Fin (n + 1)) := Z i ω
    let u (i : Fin (n + 1)) := U i ω
    change u ∘ Tuple.sort r = u ∘ Tuple.sort u
    exact Tuple.comp_sort_eq_comp_iff_monotone.mpr (normalCDF_strictMono.monotone.comp hz)
  have hX := empiricalPath_ae U (n + 1) ω
  have hB : ⇑(X - a • unitProfile) =ᵐ[volume] B := projected_unit_ae hX a
  have errors := unit_area_errors (adjustedEmpirical_integrable n z)
    ((L1.integrable_coeFn (X - a • unitProfile)).congr hB)
  have raw : |rankScale n * unsignedScore (fun i => Φ (z i)) - ‖X‖| ≤
      (1 / 2) / rankScale n := by
    rw [sort, unitL1_norm hX]
    simpa only [rankScale, Nat.cast_add, Nat.cast_one, empiricalArea] using
      baseline_midpoint_error U (n + 1) ω (fun j => ⟨cdf_nonneg _ _, cdf_le_one _ _⟩)
  change ‖sampleScores n z - unitScores (X, a)‖ ≤ _ + ∫ t, |A t - B t|
  simp only [sampleScores, unitScores, Prod.norm_def, Prod.fst_sub, Prod.snd_sub,
    Real.norm_eq_abs, max_le_iff, unitL1_norm hB, unitSigned_eq hB]
  refine ⟨raw.trans (le_add_of_nonneg_right (integral_nonneg fun _ => abs_nonneg _)), ?_, ?_⟩
  · exact (abs_sub_le _ (∫ t, |A t|) _).trans
      (add_le_add (adjusted_unsigned_empirical_error hz) errors.1)
  · exact (abs_sub_le _ (∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * A t) _).trans
      (add_le_add (adjusted_directed_empirical_error hz) errors.2)

end PITW
