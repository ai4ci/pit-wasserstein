/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import Mathlib.MeasureTheory.Function.ConvergenceInMeasure
import Mathlib.MeasureTheory.Measure.Real
import Mathlib.Topology.Instances.Real.Lemmas
import Mathlib.Tactic.Linarith

/-! Inverting a threshold-count approximation on compact intervals. -/

public section
noncomputable section
open Filter MeasureTheory Set
open scoped Topology
namespace PITW

/-- When each fixed threshold comparison has a vanishing error in probability,
a tight comparison statistic approximates the quantile itself in probability. -/
theorem quantile_inversion_in_measure {Ω : Type*} [MeasurableSpace Ω]
    {P : Measure Ω} [IsProbabilityMeasure P] (X Y : ℕ → Ω → ℝ) (R : ℝ → ℕ → Ω → ℝ)
    (htight : ∀ η > (0 : ℝ), ∃ K > (0 : ℝ), ∀ᶠ n in atTop, P.real {ω | K ≤ |Y n ω|} < η)
    (hR : ∀ x, TendstoInMeasure P (R x) atTop 0)
    (hcross : ∀ x n ω, X n ω ≤ x ↔ Y n ω ≤ x + R x n ω) :
    TendstoInMeasure P (fun n ω => X n ω - Y n ω) atTop 0 := by
  classical
  apply tendstoInMeasure_iff_measureReal_norm.mpr
  intro ε hε
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs]
  apply tendsto_order.mpr
  constructor
  · intro b hb
    exact .of_forall fun _ => hb.trans_le measureReal_nonneg
  intro η hη
  obtain ⟨K, _, hK⟩ := htight (η / 2) (by linarith)
  let δ := ε / 4
  have hd : 0 < δ := by dsimp [δ]; linarith
  obtain ⟨grid, hcover⟩ := (isCompact_Icc (α := ℝ) (a := -K) (b := K)).elim_finite_subcover
    (fun q : ℝ => Ioo (q - δ) (q + δ)) (fun _ => isOpen_Ioo) (by
      intro y _
      exact mem_iUnion.mpr ⟨y, by constructor <;> linarith⟩)
  let bad (q : ℝ) (n : ℕ) := {ω | δ ≤ |R q n ω|}
  have hb q : Tendsto (fun n => P.real (bad q n)) atTop (𝓝 0) := by
    simpa [bad] using tendstoInMeasure_iff_measureReal_norm.mp (hR q) δ hd
  let ends (q : ℝ) (n : ℕ) := bad (q - 2 * δ) n ∪ bad (q + 2 * δ) n
  have hends q : Tendsto (fun n => P.real (ends q n)) atTop (𝓝 0) := by
    apply squeeze_zero (fun _ => measureReal_nonneg) (fun _ => measureReal_union_le _ _)
    simpa using (hb (q - 2 * δ)).add (hb (q + 2 * δ))
  have hall : Tendsto (fun n => ∑ q ∈ grid, P.real (ends q n)) atTop (𝓝 0) := by
    simpa using tendsto_finsetSum grid (fun q _ => hends q)
  filter_upwards [hK, hall.eventually_lt_const (show 0 < η / 2 by linarith)] with n hn hg
  have sub : {ω | ε ≤ |X n ω - Y n ω|} ⊆
      {ω | K ≤ |Y n ω|} ∪ ⋃ q ∈ grid, ends q n := by
    intro ω hω
    by_contra h
    have hy : |Y n ω| < K := lt_of_not_ge (fun e => h (Or.inl e))
    obtain ⟨q, hq, hlo, hhi⟩ := mem_iUnion₂.mp (hcover (abs_lt.mp hy |>.imp le_of_lt le_of_lt))
    have good : ω ∉ ends q n := fun e => h (Or.inr (mem_iUnion₂.mpr ⟨q, hq, e⟩))
    have rl := abs_lt.mp (lt_of_not_ge (fun e => good (Or.inl e)) :
      |R (q - 2 * δ) n ω| < δ)
    have ru := abs_lt.mp (lt_of_not_ge (fun e => good (Or.inr e)) :
      |R (q + 2 * δ) n ω| < δ)
    have upper : X n ω ≤ q + 2 * δ := (hcross _ _ _).mpr (by linarith [ru.1])
    have lower : q - 2 * δ < X n ω := lt_of_not_ge fun e => by
      have := (hcross _ _ _).mp e
      linarith [rl.2]
    change ε ≤ |X n ω - Y n ω| at hω
    apply (not_lt_of_ge hω)
    apply abs_lt.mpr
    dsimp [δ] at lower upper hlo hhi
    constructor <;> linarith
  have hle := (measureReal_mono (μ := P) sub).trans (measureReal_union_le _ _)
  have hunion := measureReal_biUnion_finset_le (μ := P) grid (fun q => ends q n)
  linarith

end PITW
