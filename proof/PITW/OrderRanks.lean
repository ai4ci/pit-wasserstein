/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.RankLimits
public import PITW.EmpiricalGrid

/-! Inverting the empirical CDF on strictly ordered rows. Its value at the ith
observation is exactly its integer rank divided by the sample size. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Filter
open scoped Topology unitInterval
namespace PITW

/-- Scaled difference between the empirical and uniform CDF at t, for N=n+1. -/
@[expose] def empiricalRow (n : ℕ) (u : Fin (n + 1) → ℝ) (t : ℝ) : ℝ :=
  ((∑ j, if u j ≤ t then (1 : ℝ) else 0) - (n + 1) * t) / rankScale n

private theorem empirical_at_rank {n : ℕ} {u : Fin (n + 1) → ℝ}
    (hs : StrictMono u) (i : Fin (n + 1)) :
    empiricalRow n u (u i) =
      rankScale n * (midpoint i - u i) + (1 / 2) / rankScale n := by
  have card : (∑ j : Fin (n + 1), if u j ≤ u i then (1 : ℝ) else 0) = (i : ℝ) + 1 := by
    simp only [hs.le_iff_le, ← Finset.sum_filter]
    rw [show Finset.filter (fun j => j ≤ i) Finset.univ = Finset.Iic i by ext; simp]
    simp [Fin.card_Iic]
  rw [empiricalRow, card, midpoint]
  push_cast
  have sqn : rankScale n ^ 2 = n + 1 := Real.sq_sqrt (by positivity)
  field_simp [(rankScale_pos n).ne', show (n : ℝ) + 1 ≠ 0 by positivity]
  ring_nf; rw [sqn]; ring

/-- A pathwise uniform empirical-CDF approximation transfers to all quantile
ranks, even though the CDF is evaluated at sample-dependent thresholds. -/
theorem uniformRanks_of_empirical (z : (n : ℕ) → Fin (n + 1) → ℝ) (G : C(I, ℝ))
    (hs : ∀ n, StrictMono (z n))
    (h : ∀ ε > (0 : ℝ), ∀ᶠ n in atTop, ∀ t : I,
      |empiricalRow n (Φ ∘ z n) t - G t| < ε) : UniformRanks z G := by
  let u := fun n (i : Fin (n + 1)) => Φ (z n i)
  let T := fun n (i : Fin (n + 1)) => (⟨u n i, cdf_nonneg _ _, cdf_le_one _ _⟩ : I)
  let d := fun n (i : Fin (n + 1)) => rankScale n * (midpoint i - u n i)
  let c := fun n => (1 / 2 : ℝ) / rankScale n
  have hc : Tendsto c atTop (𝓝 0) := rankScale_atTop.const_div_atTop _
  have eqn n i : empiricalRow n (Φ ∘ z n) ((T n i : I) : ℝ) = d n i + c n :=
    empirical_at_rank (normalCDF_strictMono.comp (hs n)) i
  have bd : ∀ᶠ n in atTop, ∀ i, |d n i| ≤ ‖G‖ + 2 := by
    filter_upwards [h 1 zero_lt_one, (tendsto_order.mp hc.abs).2 1 (by simp)] with n hn hcn i
    have he := hn (T n i)
    rw [eqn] at he
    have hg := G.norm_coe_le_norm (T n i)
    rw [Real.norm_eq_abs] at hg
    have hc' := abs_sub (d n i + c n - G (T n i) + G (T n i)) (c n)
    simp only [sub_add_cancel, add_sub_cancel_right] at hc'
    have hadd := abs_add_le (d n i + c n - G (T n i)) (G (T n i))
    rw [sub_add_cancel] at hadd
    linarith
  apply Metric.tendsto_nhds.mpr
  intro ε hε
  obtain ⟨δ, hδ, hosc⟩ := Metric.uniformContinuous_iff.mp
    (CompactSpace.uniformContinuous_of_continuous G.continuous) (ε / 4) (by positivity)
  have small := (tendsto_order.mp (rankScale_atTop.const_div_atTop (‖G‖ + 2))).2 δ hδ
  filter_upwards [bd, small, h (ε / 4) (by positivity),
    (tendsto_order.mp hc.abs).2 (ε / 4) (by simpa using (show 0 < ε / 4 by positivity))] with
    n hbd hsmall hn hcn
  rw [Real.dist_eq, sub_zero, abs_of_nonneg (norm_nonneg _)]
  apply lt_of_le_of_lt ((pi_norm_le_iff_of_nonempty _).mpr ?_) (show 3 * ε / 4 < ε by linarith)
  intro i
  have near : dist (midUnit i) (T n i) < δ := by
    change |midpoint i - u n i| < δ
    apply lt_of_le_of_lt _ hsmall
    apply (le_div_iff₀ (rankScale_pos n)).2
    simpa only [d, abs_mul, abs_of_pos (rankScale_pos _), mul_comm] using hbd i
  have ho := hosc near
  rw [Real.dist_eq] at ho
  have he := hn (T n i); rw [eqn] at he
  change |d n i - G (midUnit i)| ≤ _
  have he' := abs_sub ((d n i + c n - G (T n i)) - c n) (G (midUnit i) - G (T n i))
  have hx : d n i + c n - G (T n i) - c n - (G (midUnit i) - G (T n i)) =
      d n i - G (midUnit i) := by ring
  rw [hx] at he'
  linarith [abs_sub (d n i + c n - G (T n i)) (c n)]

end PITW
