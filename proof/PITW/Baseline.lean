/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.EmpiricalArea
public import PITW.SampleMedian
import Mathlib.Data.Fin.Tuple.Sort

/-! The baseline score of the actual order statistics of iid uniform PITs. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

private def flag (a t : ℝ) : ℝ := if a ≤ t then 1 else 0
private def count {n : ℕ} (u : Fin n → ℝ) (t : I) := ∑ i, flag (u i) t

private lemma flag_meas (a : ℝ) : Measurable (fun t : I => flag a t) :=
  measurable_const.ite (measurableSet_le measurable_const measurable_subtypeVal) measurable_const

private lemma count_meas {n : ℕ} (u : Fin n → ℝ) : Measurable (count u) :=
  Finset.measurable_fun_sum _ fun i _ => flag_meas (u i)

private lemma flag_distance (a b : I) :
    (∫ t : I, |flag a t - flag b t|) = |(a : ℝ) - b| := by
  wlog hab : a ≤ b generalizing a b
  · simpa only [abs_sub_comm] using this b a (le_of_not_ge hab)
  have e (t : I) : |flag a t - flag b t| = (Ico a b).indicator (fun _ => (1 : ℝ)) t := by
    change |(if a ≤ t then (1 : ℝ) else 0) - (if b ≤ t then 1 else 0)| = _
    by_cases ha : a ≤ t <;> by_cases hb : b ≤ t <;>
      simp_all [not_le] <;> grind
  simp_rw [e]
  rw [integral_indicator_const _ measurableSet_Ico, Measure.real_def, unitInterval.volume_Ico,
    ENNReal.toReal_ofReal (sub_nonneg.mpr (show (a : ℝ) ≤ b from hab)), abs_sub_comm,
    abs_of_nonneg (sub_nonneg.mpr (show (a : ℝ) ≤ b from hab))]
  simp

private lemma sorted_crossings {n : ℕ} (u v : Fin n → ℝ)
    (hu : Monotone u) (hv : Monotone v) (t : I) :
    |count u t - count v t| = ∑ i, |flag (u i) t - flag (v i) t| := by
  let D i := flag (u i) t - flag (v i) t
  change |(∑ i, flag (u i) t) - ∑ i, flag (v i) t| = _
  rw [← Finset.sum_sub_distrib]
  change |∑ i, D i| = ∑ i, |D i|
  by_cases h : ∀ i, 0 ≤ D i
  · simp [abs_of_nonneg (Finset.sum_nonneg (fun i _ => h i)), abs_of_nonneg (h _)]
  · push Not at h
    obtain ⟨i, hi⟩ := h
    have ei : t < u i ∧ v i ≤ t := by
      by_cases a : u i ≤ t <;> by_cases b : v i ≤ t <;> simp_all [D, flag, not_le]
      norm_num at hi
    have hj j : D j ≤ 0 := by
      rcases le_total i j with h | h
      · have a := ei.1.trans_le (hu h)
        by_cases b : v j ≤ t <;> simp [D, flag, not_le.mpr a, b]
      · have b := (hv h).trans ei.2
        by_cases a : u j ≤ t <;> simp [D, flag, a, b]
    simp [abs_of_nonpos (Finset.sum_nonpos (fun j _ => hj j)), abs_of_nonpos (hj _)]

private lemma sorted_distance {n : ℕ} (u v : Fin n → I) (hu : Monotone u) (hv : Monotone v) :
    (∫ t, |count (fun i => (u i : ℝ)) t - count (fun i => (v i : ℝ)) t|) =
      ∑ i, |(u i : ℝ) - v i| := by
  simp_rw [sorted_crossings _ _ (fun _ _ h => hu h) (fun _ _ h => hv h)]
  rw [integral_finsetSum]
  · simp [flag_distance]
  · intro i _
    apply Integrable.of_bound ((flag_meas _).sub (flag_meas _)).abs.aestronglyMeasurable 1
    exact ae_of_all _ fun t => by
      change ‖|(if u i ≤ t then (1 : ℝ) else 0) - (if v i ≤ t then 1 else 0)|‖ ≤ 1
      split <;> split <;> norm_num

private lemma midpoint_count (n : ℕ) (t : I) :
    |count (n := n) midpoint t - n * (t : ℝ)| ≤ 1 / 2 := by
  rcases n.eq_zero_or_pos with rfl | hn
  · norm_num [count]
  have hp : (0 : ℝ) < n := by exact_mod_cast hn
  let y : ℝ := n * (t : ℝ) + 1 / 2
  have hy : 0 ≤ y := by dsimp [y]; nlinarith [mul_nonneg hp.le t.property.1]
  have hyf := Nat.floor_le hy
  have hyl := Nat.lt_floor_add_one y
  have hk : ⌊y⌋₊ ≤ n := by
    by_contra! h
    have hh : (n : ℝ) + 1 ≤ ⌊y⌋₊ := by exact_mod_cast h
    have := mul_le_of_le_one_right hp.le t.property.2
    dsimp [y] at hyf; linarith
  have iff' (i : Fin n) : midpoint i ≤ t ↔ i.val < ⌊y⌋₊ := by
    rw [Nat.lt_iff_add_one_le, Nat.le_floor_iff hy]
    unfold midpoint y
    push_cast
    rw [div_le_iff₀ hp, mul_comm (t : ℝ)]
    constructor <;> intro <;> linarith
  have eqn : count (n := n) midpoint t = ⌊y⌋₊ := by
    unfold count flag
    simp only [iff', ← Finset.sum_filter, Finset.sum_const, nsmul_eq_mul, mul_one,
      Fin.card_filter_val_lt, min_eq_right hk]
  rw [eqn, abs_le]
  dsimp [y] at hyf hyl
  constructor <;> linarith

/-- Midpoint plotting positions approximate the uniform threshold count to half a rank. -/
theorem empirical_midpoint_count_bound (n : ℕ) (t : I) :
    |(∑ i : Fin n, if midpoint i ≤ (t : ℝ) then (1 : ℝ) else 0) - n * (t : ℝ)| ≤ 1 / 2 :=
  midpoint_count n t

/-- The first n observations put in ascending order, with ties allowed. -/
@[expose] def orderedPIT {Ω : Type*} (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : Fin n → ℝ :=
  let u := fun i : Fin n => U i ω
  u ∘ Tuple.sort u

private def midError (n : ℕ) (t : I) : ℝ :=
  (Real.sqrt n)⁻¹ * (count (n := n) midpoint t - n * (t : ℝ))

private lemma midError_meas (n : ℕ) : Measurable (midError n) :=
  ((count_meas midpoint).sub (measurable_subtypeVal.const_mul _)).const_mul _

private lemma midError_bound (n : ℕ) (t : I) : |midError n t| ≤ (1 / 2) / Real.sqrt n := by
  rw [midError, abs_mul, abs_of_nonneg (inv_nonneg.mpr (Real.sqrt_nonneg _)), div_eq_inv_mul]
  gcongr
  exact midpoint_count n t

private lemma ordered_score_identity {Ω : Type*} (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω)
    (h : ∀ i, U i ω ∈ Icc (0 : ℝ) 1) :
    Real.sqrt n * unsignedScore (orderedPIT U n ω) =
      ∫ t : I, |empiricalAt U n t ω - midError n t| := by
  have es (t : I) : count (orderedPIT U n ω) t = count (fun i : Fin n => U i ω) t :=
    Equiv.sum_comp (Tuple.sort (fun i : Fin n => U i ω)) (fun i : Fin n => flag (U i ω) t)
  have e (t : I) : empiricalAt U n t ω - midError n t =
      (Real.sqrt n)⁻¹ * (count (orderedPIT U n ω) t - count (n := n) midpoint t) := by
    rw [es, empiricalAt_eq_count, midError]
    change _ * (count _ t - _) - _ * (_ - _) = _
    ring
  simp_rw [e, abs_mul, abs_of_nonneg (inv_nonneg.mpr (Real.sqrt_nonneg _))]
  rw [integral_const_mul]
  cases n with
  | zero => simp
  | succ n =>
    let v := orderedPIT U (n+1) ω
    let u (i : Fin (n+1)) : I := ⟨v i, h _⟩
    have hu : Monotone u := fun _ _ hij => Tuple.monotone_sort (fun i : Fin (n+1) => U i ω) hij
    have hm : Monotone (midUnit (n := n)) := by
      intro i j hij
      change ((i : ℝ) + 1 / 2) / _ ≤ ((j : ℝ) + 1 / 2) / _
      gcongr
      exact_mod_cast hij
    rw [show (∫ t, |count v t - count (n := n+1) midpoint t|) =
        ∑ i, |v i - midpoint i| from sorted_distance u midUnit hu hm]
    simp_rw [abs_sub_comm (v _) (midpoint _)]
    change Real.sqrt (n+1 : ℕ) * ((∑ i, |midpoint i - v i|) / (n+1 : ℕ)) = _
    have hp : 0 < (n + 1 : ℝ) := by positivity
    push_cast
    field_simp [hp.ne', (Real.sqrt_pos.mpr hp).ne']
    rw [Real.sq_sqrt hp.le]

/-- A deterministic comparison for the two scaled baseline statistics. -/
theorem baseline_midpoint_error {Ω : Type*} (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω)
    (hw : ∀ i, U i ω ∈ Icc (0 : ℝ) 1) :
    |Real.sqrt n * unsignedScore (orderedPIT U n ω) - empiricalArea U n ω| ≤
      (1 / 2) / Real.sqrt n := by
  rw [ordered_score_identity U n ω hw]
  have hmeas : Measurable (fun t => empiricalAt U n t ω) := by
    simp_rw [empiricalAt_eq_count]
    exact ((count_meas (fun i : Fin n => U i ω)).sub
      (measurable_subtypeVal.const_mul _)).const_mul _
  let E t := empiricalAt U n t ω
  have hE : Integrable E :=
    Integrable.of_bound hmeas.aestronglyMeasurable _
      (ae_of_all _ fun t => empiricalAt_bound U n t ω)
  have hM : Integrable (midError n) :=
    Integrable.of_bound (midError_meas n).aestronglyMeasurable _
      (ae_of_all _ fun t => midError_bound n t)
  change |(∫ t, |E t - midError n t|) - (∫ t, |E t|)| ≤ _
  have hD : Integrable (fun t => |E t - midError n t|) volume := (hE.sub hM).abs
  rw [← integral_sub hD hE.abs]
  apply abs_integral_le_integral_abs.trans
  rw [← show (∫ _ : I, (1 / 2 : ℝ) / Real.sqrt n) = (1 / 2 : ℝ) / Real.sqrt n by simp]
  apply integral_mono_of_nonneg (ae_of_all _ fun _ => abs_nonneg _) (integrable_const _)
  apply ae_of_all; intro t
  exact (abs_abs_sub_abs_le_abs_sub ..).trans (by simpa using midError_bound n t)

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

/-- For iid uniform observations the scaled midpoint score of the sorted sample
converges to the area under the absolute value of a standard Brownian bridge. -/
theorem iid_baseline_score_limit (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution (fun (n : ℕ) ω => Real.sqrt n * unsignedScore (orderedPIT U n ω)) atTop
      (fun ξ => ∫ t : I, |brownianBridge W ξ t|) (fun _ => P) Q := by
  let A := empiricalArea U
  let Y := fun (n : ℕ) ω => Real.sqrt n * unsignedScore (orderedPIT U n ω)
  have support : ∀ᵐ ω ∂P, ∀ i, U i ω ∈ Icc (0 : ℝ) 1 := by
    apply ae_all_iff.mpr; intro i
    exact ((hu i).ae_iff (measurableSet_setOfPred.mp measurableSet_Icc)).mpr
      (ae_restrict_mem measurableSet_Icc)
  have idn n : Y n =ᵐ[P] (fun ω => ∫ t : I, |empiricalAt U n t ω - midError n t|) :=
    support.mono (fun ω hw => ordered_score_identity U n ω hw)
  have hj n := (empiricalAt_measurable hm n).sub ((midError_meas n).comp measurable_fst)
  have ym n : AEMeasurable (Y n) P :=
    (hj n).abs.stronglyMeasurable.integral_prod_left'.aemeasurable.congr (idn n).symm
  have limit := iid_empirical_area_limit U hm hu hi W hW
  apply tendstoInDistribution_of_tendstoInMeasure_sub (X := A) Y _ limit _ ym
  apply tendstoInMeasure_of_tendsto_ae
  · intro n
    exact ((ym n).sub (limit.forall_aemeasurable n)).aestronglyMeasurable
  · filter_upwards [support] with ω hw
    apply squeeze_zero_norm' _ ((Real.tendsto_sqrt_atTop.comp
      tendsto_natCast_atTop_atTop).const_div_atTop (1 / 2 : ℝ))
    apply Eventually.of_forall; intro n
    exact baseline_midpoint_error U n ω hw

/-- A one-sided baseline test has the reference tail probability at each cutoff
where the absolute bridge area has no atom. -/
theorem iid_baseline_test_size (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) (c : ℝ)
    (hc : Q.map (fun ξ => ∫ t : I, |brownianBridge W ξ t|) {c} = 0) :
    Tendsto (fun (n : ℕ) => P {ω | c < Real.sqrt n * unsignedScore (orderedPIT U n ω)}) atTop
      (𝓝 (Q {ξ | c < ∫ t : I, |brownianBridge W ξ t|})) := by
  apply rejection_probability_limit (R := Ioi c) (iid_baseline_score_limit U hm hu hi W hW)
    measurableSet_Ioi
  simpa only [frontier_Ioi] using hc

end PITW
