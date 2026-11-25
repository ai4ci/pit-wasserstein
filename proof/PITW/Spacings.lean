/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.RankLimits

/-! Converting a coupling for centred partial sums of spacings into one for the
normalised order statistics. A row of N ranks has N+1 spacings, including the
interval above the largest observation. -/

public section
noncomputable section
open Filter MeasureTheory ProbabilityTheory
open scoped Topology unitInterval
namespace PITW

/-- Difference between elapsed mean time and elapsed spacing time, scaled by √N.
The sign agrees with the manuscript's midpoint minus observed PIT. -/
def spacingFluctuation (n k : ℕ) (S : ℕ → ℝ) : ℝ := (k - S k) / rankScale n

/-- The random denominator removes t times the endpoint fluctuation. The final
half-cell correction vanishes uniformly, also at the smallest and largest ranks. -/
theorem normalized_spacings_limit (S : ℕ → ℕ → ℝ) (z : (n : ℕ) → Fin (n + 1) → ℝ)
    (F G : C(I, ℝ)) (hG : ∀ t : I, G t = F t - (t : ℝ) * F 1)
    (hu : ∀ n (i : Fin (n + 1)), Φ (z n i) = S n (i.val + 1) / S n (n + 2))
    (hs : Tendsto (fun n => ‖fun i : Fin (n + 1) =>
      spacingFluctuation n (i.val + 1) (S n) - F (midUnit i)‖) atTop (𝓝 0))
    (he : Tendsto (fun n => spacingFluctuation n (n + 2) (S n)) atTop (𝓝 (F 1))) :
    UniformRanks z G := by
  let q := fun n => spacingFluctuation n (n + 2) (S n)
  let c := fun n : ℕ => (n + 1 : ℝ) / S n (n + 2)
  have sqn (n : ℕ) : rankScale n ^ 2 = n + 1 := Real.sq_sqrt (by positivity)
  have invN : Tendsto (fun n : ℕ => (1 : ℝ) / (n + 1)) atTop (𝓝 0) :=
    (tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop).const_div_atTop 1
  have denom : Tendsto (fun n : ℕ => S n (n + 2) / (n + 1)) atTop (𝓝 1) := by
    have H := ((tendsto_const_nhds (x := (1 : ℝ))).add invN).sub (he.div_atTop rankScale_atTop)
    convert H using 1
    · funext n
      change _ = 1 + 1 / ((n : ℝ) + 1) - (((n + 2 : ℕ) : ℝ) - S n (n + 2)) / _ / _
      rw [div_div, ← sq, sqn]; push_cast
      field_simp; ring
    · simp
  have hc : Tendsto c atTop (𝓝 1) := by simpa [c] using denom.inv₀ one_ne_zero
  have hne : ∀ᶠ n in atTop, S n (n + 2) ≠ 0 := by
    filter_upwards [denom.eventually_ne one_ne_zero] with n hn
    exact fun h => hn (by simp [h])
  let e := fun n => ‖fun i : Fin (n + 1) =>
    spacingFluctuation n (i.val + 1) (S n) - F (midUnit i)‖
  let b := fun n => e n + |q n - F 1| + (1 / rankScale n)
  have hb : Tendsto b atTop (𝓝 0) := by
    simpa [b, e, q] using (hs.add ((he.sub_const (F 1)).abs)).add
      (rankScale_atTop.const_div_atTop 1)
  have lim := (hc.abs.mul hb).add (((hc.sub_const 1).abs).mul_const ‖G‖)
  apply squeeze_zero' (.of_forall fun _ => norm_nonneg _) _ (by simpa using lim)
  filter_upwards [hne] with n hn
  apply (pi_norm_le_iff_of_nonempty _).mpr
  intro i
  let r := midpoint i
  have hr : r ∈ Set.Icc (0 : ℝ) 1 := (midUnit i).property
  have hr' : |r| ≤ 1 := abs_le.mpr ⟨by linarith [hr.1], hr.2⟩
  have herr : |r - 1 / 2| ≤ 1 := abs_le.mpr ⟨by linarith [hr.1], by linarith [hr.2]⟩
  let d := spacingFluctuation n (i.val + 1) (S n)
  let u := midUnit i
  have Id : rankScale n * (r - Φ (z n i)) =
      c n * (d - r * q n + (r - 1 / 2) / rankScale n) := by
    rw [hu]
    dsimp [c, d, q, spacingFluctuation, r, midpoint]
    push_cast
    have hsn := (rankScale_pos n).ne'
    have hN : (n : ℝ) + 1 ≠ 0 := by positivity
    field_simp [hn, hsn, hN]
    ring_nf
    simp only [sqn]
    ring
  have eqn : rankScale n * (r - Φ (z n i)) - G u =
      c n * ((d - F u) - r * (q n - F 1) + (r - 1 / 2) / rankScale n) +
        (c n - 1) * G u := by
    rw [Id, hG]; dsimp only [u, midUnit, r]; ring
  have hdiff : |d - F u| ≤ e n :=
    norm_le_pi_norm (fun j : Fin (n + 1) =>
      spacingFluctuation n (j.val + 1) (S n) - F (midUnit j)) i
  have hmul : |r * (q n - F 1)| ≤ |q n - F 1| := by
    rw [abs_mul]; exact mul_le_of_le_one_left (abs_nonneg _) hr'
  have hdiv : |(r - 1 / 2) / rankScale n| ≤ 1 / rankScale n := by
    rw [abs_div, abs_of_pos (rankScale_pos _)]
    exact div_le_div_of_nonneg_right herr (rankScale_pos _).le
  have hbr : |(d - F u) - r * (q n - F 1) + (r - 1 / 2) / rankScale n| ≤ b n :=
    (abs_add_le ..).trans (add_le_add ((abs_sub ..).trans (add_le_add hdiff hmul)) hdiv)
  change |rankScale n * (r - Φ (z n i)) - G u| ≤ _
  rw [eqn]
  refine (abs_add_le ..).trans ?_
  simp only [abs_mul]
  exact add_le_add (mul_le_mul_of_nonneg_left hbr (abs_nonneg _))
    (mul_le_mul_of_nonneg_left (G.norm_coe_le_norm _) (abs_nonneg _))

end PITW
