/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Baseline
public import PITW.OrderRanks

/-! Finite-sample CDF representations of the median-adjusted scores. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set
open scoped unitInterval
namespace PITW

/-- Square-root scaled empirical CDF discrepancy of the fitted PITs. -/
@[expose] def adjustedEmpirical (n : ℕ) (z : Fin (n + 1) → ℝ) (t : I) : ℝ :=
  empiricalRow n (adjustedPIT n z) t

private lemma adj_mono {n : ℕ} {z : Fin (n + 1) → ℝ} (h : Monotone z) :
    Monotone (adjustedPIT n z) :=
  fun _ _ hij => normalCDF_strictMono.monotone (sub_le_sub_right (h hij) _)

private lemma adj_unit {n : ℕ} (z : Fin (n + 1) → ℝ) (i : Fin (n + 1)) :
    adjustedPIT n z i ∈ Icc (0 : ℝ) 1 := ⟨cdf_nonneg _ _, cdf_le_one _ _⟩

/-- For an ordered Gaussian row, the scaled unsigned fitted score and the
absolute area of its fitted empirical CDF differ by at most half a scaled rank. -/
theorem adjusted_unsigned_empirical_error {n : ℕ} {z : Fin (n + 1) → ℝ} (h : Monotone z) :
    |rankScale n * unsignedScore (adjustedPIT n z) - (∫ t : I, |adjustedEmpirical n z t|)| ≤
      (1 / 2) / rankScale n := by
  let u := adjustedPIT n z
  let U := fun (j : ℕ) (_ : Unit) => u (Fin.ofNat (n + 1) j)
  have eu (i : Fin (n + 1)) : U i () = u i := by simp [U]
  have sort : orderedPIT U (n + 1) () = u := by
    change (fun j : Fin (n + 1) => U j ()) ∘ _ = u
    simp_rw [eu]
    rw [Tuple.sort_eq_refl_iff_monotone.mpr (adj_mono h)]
    rfl
  have area : empiricalArea U (n + 1) () = ∫ t : I, |adjustedEmpirical n z t| := by
    unfold empiricalArea adjustedEmpirical empiricalRow
    simp only [empiricalAt_eq_count, Nat.cast_add, Nat.cast_one, eu, u, div_eq_inv_mul, rankScale]
  simpa only [sort, area, Nat.cast_add, Nat.cast_one, rankScale, u] using
    baseline_midpoint_error U (n + 1) () (fun j => adj_unit z _)

/-- In an ordered row the fitted median puts the lower and upper ranks on
opposite sides of one half, including when the two middle values coincide. -/
theorem adjusted_directed_deviation {n : ℕ} {z : Fin (n + 1) → ℝ} (h : Monotone z) :
    directedScore (adjustedPIT n z) =
      (∑ i, (|adjustedPIT n z i - 1 / 2| - |midpoint i - 1 / 2|)) / (n + 1) := by
  let l : Fin (n + 1) := ⟨n / 2, by omega⟩
  let r : Fin (n + 1) := ⟨(n + 1) / 2, by omega⟩
  have lr : l ≤ r := by change n / 2 ≤ (n + 1) / 2; omega
  have lm : z l ≤ normalMedian n z := by change z l ≤ (z l + z r) / 2; linarith [h lr]
  have mr : normalMedian n z ≤ z r := by change (z l + z r) / 2 ≤ z r; linarith [h lr]
  unfold directedScore
  push_cast
  congr 1
  apply Finset.sum_congr rfl
  intro i _
  have pos : (0 : ℝ) < n + 1 := by positivity
  have m : midpoint i = ((i : ℝ) + 1 / 2) / (n + 1) := by simp [midpoint]
  rcases lt_trichotomy (2 * i.val) n with hi | hi | hi
  · have i_le : i ≤ l := by change i.val ≤ n / 2; omega
    have hm : midpoint i < 1 / 2 := by
      rw [m, div_lt_iff₀ pos]; have hc : 2 * (i : ℝ) < n := by exact_mod_cast hi
      linarith
    have ha : adjustedPIT n z i ≤ 1 / 2 := by
      rw [adjustedPIT, ← normalCDF_zero]; exact normalCDF_strictMono.monotone (by linarith [h i_le])
    rw [Real.sign_of_pos (sub_pos.mpr hm), abs_of_nonpos (sub_nonpos.mpr ha),
      abs_of_nonpos (sub_nonpos.mpr hm.le)]
    ring
  · have il : i = l := Fin.ext (by change i.val = n / 2; omega)
    have ir : i = r := Fin.ext (by change i.val = (n + 1) / 2; omega)
    have hm : midpoint i = 1 / 2 := by
      rw [m, div_eq_iff pos.ne']; have hc : 2 * (i : ℝ) = n := by exact_mod_cast hi
      linarith
    have ha : adjustedPIT n z i = 1 / 2 := by
      have zm : z i = normalMedian n z := le_antisymm (il ▸ lm) (ir ▸ mr)
      simp [adjustedPIT, zm, normalCDF_zero]
    simp [ha, hm]
  · have r_le : r ≤ i := by change (n + 1) / 2 ≤ i.val; omega
    have hm : 1 / 2 < midpoint i := by
      rw [m, lt_div_iff₀ pos]; have hc : (n : ℝ) < 2 * i := by exact_mod_cast hi
      linarith
    have ha : 1 / 2 ≤ adjustedPIT n z i := by
      rw [adjustedPIT, ← normalCDF_zero]; exact normalCDF_strictMono.monotone (by linarith [h r_le])
    rw [Real.sign_of_neg (sub_neg.mpr hm), abs_of_nonneg (sub_nonneg.mpr ha),
      abs_of_nonneg (sub_nonneg.mpr hm.le)]
    ring

private abbrev halfSign (t : I) : ℝ := Real.sign (1 / 2 - (t : ℝ))

private lemma halfSign_bound (t : I) : |halfSign t| ≤ 1 := by
  unfold halfSign
  rcases Real.sign_apply_eq (1 / 2 - (t : ℝ)) with h | h | h <;> rw [h] <;> norm_num

private lemma halfSign_measurable : Measurable halfSign := by
  unfold halfSign Real.sign
  have hm : Measurable (fun t : I => 1 / 2 - (t : ℝ)) := measurable_const.sub measurable_subtypeVal
  exact measurable_const.ite (measurableSet_lt hm measurable_const)
    (measurable_const.ite (measurableSet_lt measurable_const hm) measurable_const)

private lemma upperIndicator_integrable (a : I) :
    Integrable (fun t : I => if a ≤ t then (1 : ℝ) else 0) := by
  exact (integrable_const 1).indicator measurableSet_Ici

/-- The empirical path of every finite fitted row is integrable on the unit interval. -/
theorem adjustedEmpirical_integrable (n : ℕ) (z : Fin (n + 1) → ℝ) :
    Integrable (adjustedEmpirical n z) := by
  let u (i : Fin (n + 1)) : I := ⟨adjustedPIT n z i, adj_unit z i⟩
  have hi : Integrable (fun t : I => (t : ℝ)) :=
    continuous_subtypeVal.integrable_of_hasCompactSupport (HasCompactSupport.of_compactSpace _)
  exact ((integrable_finsetSum _ (fun i _ => upperIndicator_integrable (u i))).sub
    (hi.const_mul ((n : ℝ) + 1))).div_const _

private lemma weighted_integral {f : I → ℝ} (hf : Integrable f) :
    (∫ t : I, halfSign t * f t) = 2 * (∫ t in Iic unitHalf, f t) - ∫ t, f t := by
  let L := Iic unitHalf
  have e : (fun t : I => halfSign t * f t) =ᵐ[volume]
      (fun t => 2 * L.indicator f t - f t) := by
    filter_upwards [(volume : Measure I).ae_ne unitHalf] with t ht
    rcases lt_or_gt_of_ne ht with h | h
    · have ht' : (t : ℝ) < 1 / 2 := h
      rw [show halfSign t = 1 from Real.sign_of_pos (sub_pos.mpr ht'),
        indicator_of_mem (show t ∈ L from h.le)]
      ring
    · have ht' : 1 / 2 < (t : ℝ) := h
      rw [show halfSign t = -1 from Real.sign_of_neg (sub_neg.mpr ht'),
        indicator_of_notMem (show t ∉ L from h.not_ge)]
      ring
  rw [integral_congr_ae e, integral_sub ((hf.indicator measurableSet_Iic).const_mul 2) hf,
    integral_const_mul, integral_indicator measurableSet_Iic]

private lemma weighted_indicator (a : I) :
    (∫ t : I, halfSign t * (if a ≤ t then (1 : ℝ) else 0)) = |(a : ℝ) - 1 / 2| - 1 / 2 := by
  rw [weighted_integral (upperIndicator_integrable a)]
  change 2 * (∫ t in Iic unitHalf, (Ici a).indicator (fun _ => (1 : ℝ)) t) -
    (∫ t, (Ici a).indicator (fun _ => (1 : ℝ)) t) = _
  rw [integral_indicator_const _ measurableSet_Ici, integral_indicator_const _ measurableSet_Ici]
  simp only [smul_eq_mul, mul_one, Measure.real_def, Measure.restrict_apply measurableSet_Ici,
    Ici_inter_Iic, unitInterval.volume_Icc, unitInterval.volume_Ici, ENNReal.toReal_ofReal',
    unitHalf]
  rcases le_total (a : ℝ) (1 / 2) with h | h
  · rw [abs_of_nonpos (sub_nonpos.mpr h), max_eq_left (by linarith [a.property.2]),
      max_eq_left (by linarith)]
    ring
  · rw [abs_of_nonneg (sub_nonneg.mpr h), max_eq_right (by linarith),
      max_eq_left (by linarith [a.property.2])]
    ring

private lemma weighted_uniform : (∫ t : I, halfSign t * (t : ℝ)) = -(1 / 4) := by
  have hi : Integrable (fun t : I => (t : ℝ)) :=
    continuous_subtypeVal.integrable_of_hasCompactSupport (HasCompactSupport.of_compactSpace _)
  rw [weighted_integral hi]
  have hhalf : (∫ t in Iic unitHalf, (t : ℝ)) = (∫ x in (0 : ℝ)..1 / 2, x) := by
    rw [← integral_indicator measurableSet_Iic]
    change (∫ t : I, (Iic (1 / 2 : ℝ)).indicator id (t : ℝ)) = _
    rw [integral_subtype measurableSet_Icc, integral_indicator measurableSet_Iic,
      Measure.restrict_restrict measurableSet_Iic]
    have he : Iic (1 / 2 : ℝ) ∩ Icc 0 1 = Icc 0 (1 / 2) := by ext x; simp; constructor <;> grind
    rw [he, integral_Icc_eq_integral_Ioc, intervalIntegral.integral_of_le (by norm_num)]
    rfl
  rw [hhalf, integral_subtype measurableSet_Icc (fun x : ℝ => x), integral_Icc_eq_integral_Ioc,
    ← intervalIntegral.integral_of_le (by norm_num : (0 : ℝ) ≤ 1)]
  rw [integral_id, integral_id]; norm_num

private lemma weighted_indicator_integrable (a : I) :
    Integrable (fun t : I => halfSign t * (if a ≤ t then (1 : ℝ) else 0)) :=
  (upperIndicator_integrable a).bdd_mul halfSign_measurable.aestronglyMeasurable
    (ae_of_all _ halfSign_bound)

/-- The integral of a signed empirical CDF discrepancy is determined by the
mean absolute distance of the observations from one half. -/
theorem signed_empirical_row (n : ℕ) (u : Fin (n + 1) → I) :
    (∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * empiricalRow n (fun i => (u i : ℝ)) t) =
      ((∑ i, |(u i : ℝ) - 1 / 2|) - (n + 1) / 4) / rankScale n := by
  have e (t : I) : halfSign t * empiricalRow n (fun i => (u i : ℝ)) t =
      ((∑ i, halfSign t * (if u i ≤ t then (1 : ℝ) else 0)) - (n + 1) * (halfSign t * (t : ℝ))) /
        rankScale n := by
    unfold empiricalRow
    rw [← Finset.mul_sum]
    change _ = (halfSign t * (∑ i, if (u i : ℝ) ≤ (t : ℝ) then (1 : ℝ) else 0) - _) / _
    ring
  have hi : Integrable (fun t : I => (t : ℝ)) :=
    continuous_subtypeVal.integrable_of_hasCompactSupport (HasCompactSupport.of_compactSpace _)
  have hw := hi.bdd_mul halfSign_measurable.aestronglyMeasurable (ae_of_all _ halfSign_bound)
  change (∫ t : I, halfSign t * _) = _
  simp_rw [e]
  have hflag (i : Fin (n + 1)) (_ : i ∈ Finset.univ) := weighted_indicator_integrable (u i)
  rw [integral_div, integral_sub (integrable_finsetSum _ hflag) (hw.const_mul _),
    integral_finsetSum _ hflag,
    integral_const_mul, weighted_uniform]
  simp_rw [weighted_indicator]
  rw [Finset.sum_sub_distrib]
  simp
  ring

private lemma midpoint_weighted_bound (n : ℕ) :
    |∫ t : I, halfSign t * empiricalRow n midpoint t| ≤ (1 / 2) / rankScale n := by
  have h (t : I) : |halfSign t * empiricalRow n midpoint t| ≤ (1 / 2) / rankScale n := by
    rw [abs_mul]
    calc
      _ ≤ 1 * |empiricalRow n midpoint t| :=
        mul_le_mul_of_nonneg_right (halfSign_bound t) (abs_nonneg _)
      _ ≤ _ := by
        rw [one_mul, empiricalRow, abs_div, abs_of_pos (rankScale_pos n)]
        apply div_le_div_of_nonneg_right _ (rankScale_pos n).le
        simpa using empirical_midpoint_count_bound (n + 1) t
  calc
    _ ≤ ∫ t : I, |halfSign t * empiricalRow n midpoint t| := abs_integral_le_integral_abs
    _ ≤ ∫ _ : I, (1 / 2) / rankScale n :=
      integral_mono_of_nonneg (ae_of_all _ (fun _ => abs_nonneg _)) (integrable_const _)
        (ae_of_all _ h)
    _ = _ := by simp

/-- The scaled directed fitted score approximates the sign-weighted area of the
fitted empirical CDF, with a deterministic plotting-position error. -/
theorem adjusted_directed_empirical_error {n : ℕ} {z : Fin (n + 1) → ℝ} (h : Monotone z) :
    |rankScale n * directedScore (adjustedPIT n z) -
      (∫ t : I, Real.sign (1 / 2 - (t : ℝ)) * adjustedEmpirical n z t)| ≤
      (1 / 2) / rankScale n := by
  let u (i : Fin (n + 1)) : I := ⟨adjustedPIT n z i, adj_unit z i⟩
  have ha := signed_empirical_row n u
  have hm := signed_empirical_row n midUnit
  change (∫ t : I, halfSign t * adjustedEmpirical n z t) =
    ((∑ i, |adjustedPIT n z i - 1 / 2|) - (n + 1) / 4) / rankScale n at ha
  change (∫ t : I, halfSign t * empiricalRow n midpoint t) =
    ((∑ i : Fin (n + 1), |midpoint i - 1 / 2|) - (n + 1) / 4) / rankScale n at hm
  have hn : 0 < (n : ℝ) + 1 := by positivity
  have hs : rankScale n ^ 2 = n + 1 := Real.sq_sqrt hn.le
  have e : rankScale n * directedScore (adjustedPIT n z) -
      (∫ t : I, halfSign t * adjustedEmpirical n z t) =
      -(∫ t : I, halfSign t * empiricalRow n midpoint t) := by
    rw [ha, hm, adjusted_directed_deviation h, Finset.sum_sub_distrib, ← hs]
    field_simp [(rankScale_pos n).ne']
    ring_nf
  rw [e, abs_neg]
  exact midpoint_weighted_bound n

end PITW
