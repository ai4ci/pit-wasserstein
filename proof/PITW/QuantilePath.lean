/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.IidMedian
public import PITW.EmpiricalPath

/-! The scaled order-statistic path on the unit interval and its empirical CDF comparison. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

private def rankCell {n : ℕ} (i : Fin (n + 1)) : Set I :=
  Subtype.val ⁻¹' Ioc ((i : ℝ) / (n + 1)) (((i : ℝ) + 1) / (n + 1))

private lemma rankCell_meas {n : ℕ} (i : Fin (n + 1)) : MeasurableSet (rankCell i) :=
  measurable_subtypeVal measurableSet_Ioc

private lemma rankCell_unique {n : ℕ} {i j : Fin (n + 1)} {t : I}
    (hi : t ∈ rankCell i) (hj : t ∈ rankCell j) : i = j := by
  have hpos : (0 : ℝ) < n + 1 := by positivity
  have before {a b : Fin (n + 1)} (hab : a < b) :
      ((a : ℝ) + 1) / (n + 1) ≤ (b : ℝ) / (n + 1) := by
    apply div_le_div_of_nonneg_right _ hpos.le
    exact_mod_cast (show a.val + 1 ≤ b.val from hab)
  rcases lt_trichotomy i j with h | h | h
  · exact False.elim ((before h).not_gt (hj.1.trans_le hi.2))
  · exact h
  · exact False.elim ((before h).not_gt (hi.1.trans_le hj.2))

private lemma rankFunction_cells {n : ℕ} (u : Fin (n + 1) → ℝ) (t : I) :
    rankFunction u t = ∑ i, (rankCell i).indicator (fun _ => midpoint i - u i) t := by
  classical
  by_cases ht : (t : ℝ) ∈ Ioc 0 1
  · obtain ⟨i, hi⟩ := rank_cell_exists n ht
    have hh : t ∈ rankCell i := hi
    rw [rankFunction_at u i hi.1 hi.2, Finset.sum_eq_single i,
      indicator_of_mem hh]
    · intro j _ hji
      exact indicator_of_notMem (fun hj => hji (rankCell_unique hj hh)) _
    · simp
  · rw [rankFunction_outside u ht, Finset.sum_eq_zero]
    intro i _
    apply indicator_of_notMem
    intro hi
    exact ht ⟨lt_of_le_of_lt (by positivity : (0 : ℝ) ≤ (i : ℝ)/(n + 1)) hi.1, t.property.2⟩

private def cellBasis {n : ℕ} (i : Fin (n + 1)) : UnitL1 :=
  indicatorConstLp 1 (rankCell_meas i) (measure_ne_top _ _) (1 : ℝ)

/-- The order-statistic path as an L¹ equivalence class on the PIT interval. -/
def unitRankPath {n : ℕ} (u : Fin (n + 1) → ℝ) : UnitL1 :=
  ∑ i, (rankScale n * (midpoint i - u i)) • cellBasis i

theorem unitRankPath_ae {n : ℕ} (u : Fin (n + 1) → ℝ) :
    ⇑(unitRankPath u) =ᵐ[volume] fun t : I => rankScale n * rankFunction u t := by
  let f i := rankScale n * (midpoint i - u i)
  have h (i : Fin (n + 1)) : ⇑(f i • cellBasis i) =ᵐ[volume]
      fun t => f i * (rankCell i).indicator (fun _ => (1 : ℝ)) t := by
    filter_upwards [Lp.coeFn_smul (f i) (cellBasis i),
      (show ⇑(cellBasis i) =ᵐ[volume] _ from indicatorConstLp_coeFn)] with t h₁ h₂
    simp only [h₁, Pi.smul_apply, smul_eq_mul, h₂]
  filter_upwards [Lp.coeFn_finsetSum Finset.univ (fun i => f i • cellBasis i),
    ae_all_iff.mpr h] with t hsum ht
  change (∑ i, f i • cellBasis i) t = _
  rw [hsum, rankFunction_cells, Finset.mul_sum]
  simp only [Finset.sum_apply]
  apply Finset.sum_congr rfl
  intro i _
  by_cases hi : t ∈ rankCell i <;> simp [ht i, hi, f]

theorem unitRankPath_measurable (n : ℕ) : Measurable (unitRankPath (n := n)) := by
  unfold unitRankPath
  apply Continuous.measurable
  fun_prop

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

/-- The rank-minus-empirical discrepancy is integrable over samples and thresholds.
Only the one-dimensional uniform laws are needed for this integrability statement. -/
theorem rank_empirical_error_integrable (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (n : ℕ) :
    Integrable (Function.uncurry (fun ω (t : I) =>
      rankScale n * rankFunction (orderedPIT U (n + 1) ω) t - empiricalAt U (n + 1) t ω))
      (P.prod volume) := by
  have hr : Measurable (fun p : Ω × I => rankFunction (orderedPIT U (n + 1) p.1) p.2) := by
    simp_rw [rankFunction_cells]
    apply Finset.measurable_fun_sum
    intro i _
    exact (measurable_const.sub ((measurable_orderedPIT hm _ i).comp measurable_fst)).ite
      (measurable_snd (rankCell_meas i)) measurable_const
  have support : ∀ᵐ ω ∂P, ∀ i, U i ω ∈ Icc (0 : ℝ) 1 := by
    apply ae_all_iff.mpr
    intro i
    exact ((hu i).ae_iff (measurableSet_setOfPred.mp measurableSet_Icc)).mpr
      (ae_restrict_mem measurableSet_Icc)
  have hs : ∀ᵐ p : Ω × I ∂P.prod volume, ∀ i, U i p.1 ∈ Icc (0 : ℝ) 1 :=
    (Measure.quasiMeasurePreserving_fst (μ := P) (ν := (volume : Measure I))).tendsto_ae support
  apply Integrable.of_bound
    ((hr.const_mul _).sub ((empiricalAt_measurable hm _).comp measurable_swap)).aestronglyMeasurable
    (rankScale n + ((Real.sqrt (n + 1))⁻¹ * ((n + 1) + (n + 1) : ℝ)))
  filter_upwards [hs] with p hp
  have hb : |rankFunction (orderedPIT U (n + 1) p.1) p.2| ≤ 1 := by
    by_cases ht : (p.2 : ℝ) ∈ Ioc 0 1
    · obtain ⟨i, hi⟩ := rank_cell_exists n ht
      rw [rankFunction_at _ i hi.1 hi.2]
      have ho : orderedPIT U (n + 1) p.1 i ∈ Icc (0 : ℝ) 1 := hp _
      have hmid : midpoint i ∈ Icc (0 : ℝ) 1 := (midUnit i).property
      exact abs_le.mpr ⟨by linarith [ho.2, hmid.1], by linarith [ho.1, hmid.2]⟩
    · simp [rankFunction_outside _ ht]
  change |rankScale n * rankFunction _ _ - empiricalAt U _ _ _| ≤ _
  apply (abs_sub ..).trans (add_le_add _ (by simpa using empiricalAt_bound U (n + 1) p.2 p.1))
  rw [abs_mul, abs_of_pos (rankScale_pos n)]
  exact mul_le_of_le_one_right (rankScale_pos n).le hb

end PITW
