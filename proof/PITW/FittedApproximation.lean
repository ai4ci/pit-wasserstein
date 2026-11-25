/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.FittedCDF
public import PITW.IidMedian
public import PITW.AdjustedScores

/-! Approximation of the empirical CDF after subtracting the sample median. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

variable {Ω : Type*}
local notation "dens" => gaussianPDFReal 0 1 0

/-- Sorting the observations preserves the empirical count at the shifted threshold. -/
theorem adjustedEmpirical_eq_shifted (Z : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (t : I) :
    let z := orderedPIT Z (n + 1) ω
    let h := normalMedian n z
    adjustedEmpirical n z t = empiricalAt (fun j => Φ ∘ Z j) (n + 1) (shiftPIT h t) ω +
      rankScale n * ((shiftPIT h t : ℝ) - t) := by
  classical
  intro z h
  let u := fun i : Fin (n + 1) => Z i ω
  let f := fun i : Fin (n + 1) => if Φ (u i) ≤ shiftPIT h t then (1 : ℝ) else 0
  have counts : (∑ i, if adjustedPIT n z i ≤ t then (1 : ℝ) else 0) = ∑ i, f i := by
    rw [← Equiv.sum_comp (Tuple.sort u) f]
    apply Finset.sum_congr rfl
    intro i _
    exact if_congr (cdf_sub_le_iff_shift h (z i) t) rfl rfl
  rw [adjustedEmpirical, empiricalRow, empiricalAt_eq_count, counts]
  simp only [Nat.cast_add, Nat.cast_one]
  change (_ - ((n : ℝ) + 1) * _) / rankScale n =
    (rankScale n)⁻¹ * ((∑ i, f i) - ((n : ℝ) + 1) * _) + _
  have hs : rankScale n ^ 2 = (n : ℝ) + 1 := Real.sq_sqrt (by positivity)
  rw [← hs]
  field_simp [(rankScale_pos n).ne']
  ring

private theorem drift_bound (n : ℕ) (h e : ℝ) (t : I) (ht : (t : ℝ) ∈ Ioo 0 1) :
    |rankScale n * ((shiftPIT h t : ℝ) - t) + e * normalProfile t| ≤
      dens * (rankScale n * h) ^ 2 / rankScale n + dens * |rankScale n * h - (-e / dens)| := by
  have hd : 0 < dens := gaussianPDFReal_pos _ _ _ one_ne_zero
  have hp : |normalProfile t| ≤ 1 := by
    obtain ⟨z, hz⟩ := normalCDF_range ht
    rw [← hz, normalProfile_cdf]
    have hf : gaussianPDFReal 0 1 z = dens * Real.exp (-(z ^ 2)/2) := by simp [gaussianPDFReal_def]
    rw [hf, mul_div_cancel_left₀ _ hd.ne', abs_of_pos (Real.exp_pos _)]
    exact Real.exp_le_one_iff.mpr (by nlinarith [sq_nonneg z])
  let rem := (shiftPIT h t : ℝ) - t - h * dens * normalProfile t
  have hb : |rem| ≤ dens * h ^ 2 := shiftPIT_remainder h t ht
  let s := rankScale n
  have hs : 0 < s := rankScale_pos n
  calc
    _ = |s * rem + (dens * (s * h - (-e / dens))) * normalProfile t| := by
      congr 1
      dsimp [rem, s]
      field_simp [hd.ne']
      ring
    _ ≤ |s * rem| + |(dens * (s * h - (-e / dens))) * normalProfile t| := abs_add_le ..
    _ ≤ s * (dens * h ^ 2) + (dens * |s * h - (-e / dens)|) * 1 := by
      simp only [abs_mul, abs_of_pos hs, abs_of_pos hd]
      exact add_le_add (mul_le_mul_of_nonneg_left hb hs.le)
        (mul_le_mul_of_nonneg_left hp (by positivity))
    _ = _ := by
      change _ = dens * (s * h) ^ 2 / s + dens * |s * h - (-e / dens)|
      rw [mul_one]
      congr 1
      field_simp [hs.ne']

variable [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

private theorem fitted_error_vanishes (X J A B : ℕ → Ω → ℝ)
    (hj : TendstoInMeasure P J atTop 0) (hb : TendstoInMeasure P B atTop 0)
    (htight : ∀ η > (0 : ℝ), ∃ K > (0 : ℝ), ∀ᶠ n in atTop, P.real {ω | K ≤ |A n ω|} < η)
    (hbound : ∀ n ω, |X n ω| ≤ |J n ω| + dens * (A n ω) ^ 2 / rankScale n + dens * |B n ω|) :
    TendstoInMeasure P X atTop 0 := by
  have hd : 0 < dens := gaussianPDFReal_pos _ _ _ one_ne_zero
  apply tendstoInMeasure_iff_measureReal_norm.mpr
  intro ε hε
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs]
  apply tendsto_order.mpr
  refine ⟨fun b hb' => .of_forall fun _ => hb'.trans_le measureReal_nonneg, ?_⟩
  intro η hη
  obtain ⟨K, hK, ht⟩ := htight (η / 3) (by positivity)
  let δ := ε / 3
  have hδ : 0 < δ := by dsimp [δ]; positivity
  have he (Y : ℕ → Ω → ℝ) (hy : TendstoInMeasure P Y atTop 0) (r : ℝ) (hr : 0 < r) :
      ∀ᶠ n in atTop, P.real {ω | r ≤ |Y n ω|} < η / 3 := by
    have h := tendstoInMeasure_iff_measureReal_norm.mp hy r hr
    simpa only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] using h.eventually_lt_const
      (show 0 < η / 3 by positivity)
  have decay : Tendsto (fun n => dens * K ^ 2 / rankScale n) atTop (𝓝 0) :=
    rankScale_atTop.const_div_atTop _
  filter_upwards [ht, he J hj δ hδ, he B hb (δ / dens) (by positivity),
    decay.eventually_lt_const hδ] with n hA hJ hB hN
  let T := {ω | K ≤ |A n ω|}
  let S := {ω | δ ≤ |J n ω|}
  let Q := {ω | δ / dens ≤ |B n ω|}
  have incl : {ω | ε ≤ |X n ω|} ⊆ T ∪ (S ∪ Q) := by
    intro ω hω
    by_contra h
    have ha : |A n ω| < K := lt_of_not_ge fun e => h (.inl e)
    have hj' : |J n ω| < δ := lt_of_not_ge fun e => h (.inr (.inl e))
    have hb' : |B n ω| < δ / dens := lt_of_not_ge fun e => h (.inr (.inr e))
    have hsq : (A n ω) ^ 2 ≤ K ^ 2 := by simpa using pow_le_pow_left₀ (abs_nonneg _) ha.le 2
    have hr := (div_le_div_of_nonneg_right (mul_le_mul_of_nonneg_left hsq hd.le)
      (rankScale_pos n).le).trans_lt hN
    have hm := (lt_div_iff₀ hd).mp hb'
    change ε ≤ |X n ω| at hω
    dsimp [δ] at hj' hr hm
    linarith [hbound n ω, mul_comm |B n ω| dens]
  have hl := (measureReal_mono (μ := P) incl).trans (measureReal_union_le T (S ∪ Q))
  have hu := measureReal_union_le (μ := P) S Q
  change P.real T < η / 3 at hA
  change P.real S < η / 3 at hJ
  change P.real Q < η / 3 at hB
  linarith

/-- The fitted empirical process differs from the median-adjusted first-order
process by a quantity tending to zero in probability in the integrated absolute norm. -/
theorem iid_fitted_path_error (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hu : ∀ j, HasLaw (Φ ∘ Z j) uniformPIT P) (hi : iIndepFun (fun j => Φ ∘ Z j) P) :
    TendstoInMeasure P (fun n ω => ∫ t : I,
      |adjustedEmpirical n (orderedPIT Z (n + 1) ω) t -
        (empiricalAt (fun j => Φ ∘ Z j) (n + 1) t ω -
          empiricalAt (fun j => Φ ∘ Z j) (n + 1) unitHalf ω * normalProfile t)|) atTop 0 := by
  let U := fun j => Φ ∘ Z j
  let m n (ω : Ω) := normalMedian n (orderedPIT Z (n + 1) ω)
  let A n (ω : Ω) := rankScale n * m n ω
  let B n (ω : Ω) := A n ω - medianInfluence U n ω
  have hU j : Measurable (U j) := normalCDF_strictMono.monotone.measurable.comp (hm j)
  have ht := iid_normalMedian_tight Z hm hu hi
  apply fitted_error_vanishes _ (fun n ω => shiftIncrement U n (m n ω) ω) A B
    (iid_fitted_empirical_increment U hU hu hi m ht) (iid_normalMedian_expansion Z hm hu hi) ht
  intro n ω
  rw [abs_of_nonneg (integral_nonneg fun _ => abs_nonneg _),
    abs_of_nonneg (shiftIncrement_nonneg ..)]
  let J (t : I) := |empiricalAt U (n + 1) (shiftPIT (m n ω) t) ω - empiricalAt U (n + 1) t ω|
  let C := dens * (A n ω) ^ 2 / rankScale n + dens * |B n ω|
  have intJ : Integrable J := shiftIncrement_integrand_integrable hU n (m n ω) ω
  have intJC : (∫ t : I, J t + C) = shiftIncrement U n (m n ω) ω + C := by
    rw [integral_add intJ (integrable_const C)]
    simp [J, shiftIncrement]
  rw [add_assoc, ← intJC]
  apply integral_mono_of_nonneg (ae_of_all _ fun _ => abs_nonneg _) (intJ.add (integrable_const C))
  filter_upwards [(volume : Measure I).ae_ne (0 : I), (volume : Measure I).ae_ne (1 : I)]
    with t h0 h1
  have hinside : (t : ℝ) ∈ Ioo 0 1 :=
    ⟨unitInterval.pos_iff_ne_zero.mpr h0, unitInterval.lt_one_iff_ne_one.mpr h1⟩
  let e := empiricalAt U (n + 1) unitHalf ω
  let E (q : I) := empiricalAt U (n + 1) q ω
  let q := shiftPIT (m n ω) t
  have drift : |rankScale n * ((q : ℝ) - t) + e * normalProfile t| ≤ C :=
    drift_bound n (m n ω) e t hinside
  rw [adjustedEmpirical_eq_shifted]
  change |E q + rankScale n * ((q : ℝ) - t) - (E t - e * normalProfile t)| ≤ J t + C
  calc
    _ = |(E q - E t) + (rankScale n * ((q : ℝ) - t) + e * normalProfile t)| := by congr 1; ring
    _ ≤ _ := (abs_add_le ..).trans (add_le_add le_rfl drift)

end PITW
