/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Limits

/-! Exact finite-sample link. Each rank discrepancy occupies one cell of width
1/n. Raw and adjusted PITs are supplied in their own increasing order. -/

public section
noncomputable section
open MeasureTheory Set
namespace PITW

private def lo {n : ℕ} (i : Fin n) : ℝ := (i : ℝ) / n
private def hi {n : ℕ} (i : Fin n) : ℝ := ((i : ℝ) + 1) / n

/-- Uniform plotting position with zero-based rank index. -/
@[expose] def midpoint {n : ℕ} (i : Fin n) : ℝ := ((i : ℝ) + 1 / 2) / n

private def cell (a b c : ℝ) : ℝ → ℝ := (Ioc a b).indicator (fun _ => c)

private theorem cell_integrable (a b c : ℝ) : Integrable (cell a b c) := by
  exact (integrableOn_const (s := Ioc a b) measure_Ioc_lt_top.ne).integrable_indicator
    measurableSet_Ioc

private def step {n : ℕ} (d : Fin n → ℝ) (t : ℝ) : ℝ :=
  ∑ i, cell (lo i) (hi i) (d i) t

private theorem step_integrable {n : ℕ} (d : Fin n → ℝ) : Integrable (step d) :=
  integrable_finsetSum _ fun _ _ => cell_integrable _ _ _

/-- A representative of the rank path with left-open, right-closed cells. -/
def rankFunction {n : ℕ} (u : Fin n → ℝ) (t : ℝ) : ℝ :=
  step (fun i => midpoint i - u i) t

theorem rankFunction_integrable {n : ℕ} (u : Fin n → ℝ) : Integrable (rankFunction u) :=
  step_integrable _

/-- The L¹ rank discrepancy path, unscaled. For a CLT multiply it by √n. -/
@[expose] def rankPath {n : ℕ} (u : Fin n → ℝ) : Path :=
  (rankFunction_integrable u).toL1 (rankFunction u)

/-- Nonnegative midpoint score; use raw ranks for B and adjusted ranks for U. -/
@[expose] def unsignedScore {n : ℕ} (u : Fin n → ℝ) : ℝ :=
  (∑ i, |midpoint i - u i|) / n

/-- Positive when the adjusted lower and upper ranks move outwards. -/
@[expose] def directedScore {n : ℕ} (v : Fin n → ℝ) : ℝ :=
  (∑ i, (midpoint i - v i) * Real.sign (1 / 2 - midpoint i)) / n

private theorem coeffs {n : ℕ} (i : Fin n) :
    0 ≤ lo i ∧ lo i < hi i ∧ hi i ≤ 1 ∧ hi i - lo i = 1 / n := by
  have hn : (0 : ℝ) < n := by exact_mod_cast i.pos
  unfold lo hi
  refine ⟨by positivity, (div_lt_div_iff_of_pos_right hn).mpr (by linarith), ?_, by ring⟩
  apply (div_le_iff₀ hn).mpr
  rw [one_mul]
  exact_mod_cast (show i.val + 1 ≤ n from i.isLt)

private theorem unique_cell {n : ℕ} {i j : Fin n} {t : ℝ}
    (h : t ∈ Ioc (lo i) (hi i)) (h' : t ∈ Ioc (lo j) (hi j)) : i = j := by
  have before {u v : Fin n} (hu : u < v) : hi u ≤ lo v := by
    apply div_le_div_of_nonneg_right _ (Nat.cast_nonneg n)
    exact_mod_cast (show u.val + 1 ≤ v.val from hu)
  rcases lt_trichotomy i j with H | H | H
  · exact False.elim ((before H).not_gt (h'.1.trans_le h.2))
  · exact H
  · exact False.elim ((before H).not_gt (h.1.trans_le h'.2))

theorem rankPath_toL1 {n : ℕ} (u : Fin n → ℝ) :
    (rankFunction_integrable u).toL1 _ = rankPath u := rfl

/-- Identify the grid cell of a fixed t, including when t is a cell endpoint. -/
theorem rank_cell_exists (n : ℕ) {t : ℝ} (ht : t ∈ Ioc (0 : ℝ) 1) :
    ∃ i : Fin (n + 1), (i : ℝ) / (n + 1) < t ∧ t ≤ ((i : ℝ) + 1) / (n + 1) := by
  let k := ⌈t * (n + 1)⌉₊
  have hn : (0 : ℝ) < n + 1 := by positivity
  have hk : 1 ≤ k := Nat.one_le_ceil_iff.mpr (mul_pos ht.1 hn)
  have hkn : k ≤ n + 1 := Nat.ceil_le.mpr (by push_cast; nlinarith [ht.2])
  refine ⟨⟨k - 1, by omega⟩, ?_⟩
  change ((k - 1 : ℕ) : ℝ) / _ < t ∧ t ≤ (((k - 1 : ℕ) : ℝ) + 1) / _
  rw [Nat.cast_sub hk, Nat.cast_one]
  constructor
  · apply (div_lt_iff₀ hn).2
    have hh := Nat.ceil_lt_add_one ((mul_pos ht.1 hn).le)
    dsimp [k]; linarith
  · apply (le_div_iff₀ hn).2
    simpa [k] using Nat.le_ceil (t * (n + 1))

theorem rankFunction_at {n : ℕ} (u : Fin (n + 1) → ℝ) (i : Fin (n + 1)) {t : ℝ}
    (h₁ : (i : ℝ) / (n + 1) < t) (h₂ : t ≤ ((i : ℝ) + 1) / (n + 1)) :
    rankFunction u t = midpoint i - u i := by
  have h : t ∈ Ioc (lo i) (hi i) := by simpa [lo, hi] using And.intro h₁ h₂
  unfold rankFunction step
  classical
  rw [Finset.sum_eq_single i]
  · exact indicator_of_mem h _
  · intro j _ hj
    exact indicator_of_notMem (fun hj' => hj (unique_cell hj' h)) _
  · simp

theorem rankFunction_outside {n : ℕ} (u : Fin n → ℝ) {t : ℝ} (ht : t ∉ Ioc (0 : ℝ) 1) :
    rankFunction u t = 0 := by
  unfold rankFunction step
  apply Finset.sum_eq_zero
  intro i _
  apply indicator_of_notMem
  exact fun hi => ht ⟨(coeffs i).1.trans_lt hi.1, hi.2.trans (coeffs i).2.2.1⟩

private theorem step_abs {n : ℕ} (d : Fin n → ℝ) (t : ℝ) :
    |step d t| = step (fun i => |d i|) t := by
  classical
  by_cases h : ∃ i : Fin n, t ∈ Ioc (lo i) (hi i)
  · obtain ⟨i, hi'⟩ := h
    have eval (v : Fin n → ℝ) : step v t = v i := by
      unfold step
      rw [Finset.sum_eq_single i, cell, indicator_of_mem hi']
      · intro j _ hj
        exact indicator_of_notMem (fun h => hj (unique_cell h hi')) _
      · simp
    rw [eval, eval]
  · have eval (v : Fin n → ℝ) : step v t = 0 := by
      exact Finset.sum_eq_zero fun j _ => indicator_of_notMem (fun hj => h ⟨j, hj⟩) _
    rw [eval, eval, abs_zero]

theorem norm_rankPath {n : ℕ} (u : Fin n → ℝ) : ‖rankPath u‖ = unsignedScore u := by
  let d := fun i => midpoint i - u i
  rw [L1.norm_eq_integral_norm]
  calc
    _ = ∫ t, step (fun i => |d i|) t := by
      apply integral_congr_ae
      filter_upwards [(step_integrable d).coeFn_toL1] with t ht
      change |((step_integrable d).toL1 (step d)) t| = _
      rw [ht, step_abs]
    _ = _ := by
      unfold step
      rw [integral_finsetSum]
      · simp only [cell,
        integral_indicator_const _ measurableSet_Ioc, Real.volume_real_Ioc_of_le (coeffs _).2.1.le,
        smul_eq_mul, (coeffs _).2.2.2, ← Finset.mul_sum, unsignedScore, d]
        ring
      · exact fun _ _ => cell_integrable ..

private theorem signed_cell (a b c : ℝ) (ha : 0 ≤ a) (hab : a < b) (hb : b ≤ 1)
    (split : b ≤ 1 / 2 ∨ 1 / 2 ≤ a ∨ a + b = 1) :
    contrast (cell a b c) = (b - a) * c * Real.sign (1 / 2 - (a + b) / 2) := by
  have inter (l r : ℝ) : Ioc l r ∩ Ioc a b = Ioc (max l a) (min r b) := by
    ext t; simp [and_and_and_comm]
  simp only [contrast, intervalIntegral.integral_of_le (show (0 : ℝ) ≤ 1 / 2 by norm_num),
    intervalIntegral.integral_of_le (show (1 / 2 : ℝ) ≤ 1 by norm_num), cell,
    setIntegral_indicator measurableSet_Ioc, setIntegral_const, inter, Real.volume_real_Ioc,
    max_eq_right ha, min_eq_right hb, smul_eq_mul]
  rcases split with h | h | h
  · rw [min_eq_right h, max_eq_left (by linarith : a ≤ 1 / 2), Real.sign_of_pos (by linarith)]
    rw [max_eq_left (by linarith : 0 ≤ b - a), max_eq_right (by linarith : b - 1 / 2 ≤ 0)]; ring
  · rw [min_eq_left (by linarith : 1 / 2 ≤ b), max_eq_right h, Real.sign_of_neg (by linarith)]
    rw [max_eq_right (by linarith : 1 / 2 - a ≤ 0), max_eq_left (by linarith : 0 ≤ b - a)]; ring
  · have h₁ : a ≤ 1 / 2 := by linarith
    have h₂ : 1 / 2 ≤ b := by linarith
    rw [min_eq_left h₂, max_eq_left h₁, max_eq_left (by linarith : 0 ≤ 1 / 2 - a),
      max_eq_left (by linarith : 0 ≤ b - 1 / 2), h, sub_self, Real.sign_zero]
    rw [show b - 1 / 2 = 1 / 2 - a by linarith]; ring

theorem signed_rankPath {n : ℕ} (v : Fin n → ℝ) : signedArea (rankPath v) = directedScore v := by
  let d := fun i => midpoint i - v i
  change signedArea ((step_integrable d).toL1 _) = _
  rw [signedArea_toL1]
  have aux (i : Fin n) : contrast (cell (lo i) (hi i) (d i)) =
      (1 / n) * (d i * Real.sign (1 / 2 - midpoint i)) := by
    obtain ⟨ha, hab, hb, hw⟩ := coeffs i
    have hn : (0 : ℝ) < n := by exact_mod_cast i.pos
    have split : hi i ≤ 1 / 2 ∨ 1 / 2 ≤ lo i ∨ lo i + hi i = 1 := by
      obtain H | H | H : 2 * (i.val + 1) ≤ n ∨ n ≤ 2 * i.val ∨ 2 * i.val + 1 = n := by omega
      · left; unfold hi; field_simp; exact_mod_cast (by omega : (i.val + 1) * 2 ≤ n)
      · right; left; unfold lo; field_simp; exact_mod_cast (by omega : n ≤ 2 * i.val)
      · right; right; unfold hi lo; field_simp; exact_mod_cast (by omega : i.val + (i.val + 1) = n)
    rw [signed_cell _ _ _ ha hab hb split, hw]
    have hm : (lo i + hi i) / 2 = midpoint i := by unfold lo hi midpoint; ring
    rw [hm]; ring
  have H (a b : ℝ) (i : Fin n) (_ : i ∈ Finset.univ) :
      IntervalIntegrable (cell (lo i) (hi i) (d i)) volume a b :=
    (cell_integrable ..).intervalIntegrable
  simp only [contrast, step, intervalIntegral.integral_finsetSum (H _ _), ← Finset.sum_sub_distrib]
  change (∑ i, contrast (cell (lo i) (hi i) (d i))) = _
  simp_rw [aux]
  rw [← Finset.mul_sum]
  unfold directedScore
  ring

/-- The continuous-uniform W₁ calculation integrates the empirical quantile on
each cell, where it is constant and equal to the corresponding order statistic. -/
def uniformDistance {n : ℕ} (u : Fin n → ℝ) : ℝ :=
  ∑ i, ∫ t in lo i..hi i, |t - u i|

private theorem midpoint_integral (a b : ℝ) (hab : a ≤ b) :
    (∫ t in a..b, |t - (a + b) / 2|) = (b - a) ^ 2 / 4 := by
  let m := (a + b) / 2
  have h₁ : a ≤ m := by dsimp [m]; linarith
  have h₂ : m ≤ b := by dsimp [m]; linarith
  have hc : Continuous (fun t : ℝ => |t - m|) := by fun_prop
  change (∫ t in a..b, |t - m|) = _
  rw [← intervalIntegral.integral_add_adjacent_intervals
    (hc.intervalIntegrable a m) (hc.intervalIntegrable m b)]
  have left : (∫ t in a..m, |t - m|) = ∫ t in a..m, m - t := by
    apply intervalIntegral.integral_congr
    rw [uIcc_of_le h₁]
    intro t ht
    change |t - m| = m - t
    rw [abs_of_nonpos (sub_nonpos.mpr ht.2)]; ring
  have right : (∫ t in m..b, |t - m|) = ∫ t in m..b, t - m := by
    apply intervalIntegral.integral_congr
    rw [uIcc_of_le h₂]
    intro t ht; exact abs_of_nonneg (sub_nonneg.mpr ht.1)
  have hi (l r : ℝ) : IntervalIntegrable (fun t : ℝ => t) volume l r :=
    continuous_id.intervalIntegrable ..
  rw [left, right, intervalIntegral.integral_sub intervalIntegrable_const (hi a m),
    intervalIntegral.integral_sub (hi m b) intervalIntegrable_const]
  simp only [integral_id, intervalIntegral.integral_const, smul_eq_mul, m]
  ring

/-- Finite midpoint approximation error. After multiplication by √n this
deterministic error is at most 1/(4√n), for raw or adjusted order statistics. -/
theorem midpoint_error {n : ℕ} (hn : 0 < n) (u : Fin n → ℝ) :
    |uniformDistance u - unsignedScore u| ≤ 1 / (4 * n) := by
  have hn' : (0 : ℝ) < n := by exact_mod_cast hn
  have bound (i : Fin n) :
      |(∫ t in lo i..hi i, |t - u i|) - |midpoint i - u i| / n| ≤ (1 / n : ℝ) ^ 2 / 4 := by
    have h := (coeffs i).2.1.le
    have hw := (coeffs i).2.2.2
    have hc : Continuous (fun t : ℝ => |t - u i|) := by fun_prop
    have const : (∫ _ in lo i..hi i, |midpoint i - u i|) = |midpoint i - u i| / n := by
      rw [intervalIntegral.integral_const, hw, smul_eq_mul]; ring
    rw [← const, ← intervalIntegral.integral_sub
      (hc.intervalIntegrable ..) intervalIntegrable_const]
    apply (intervalIntegral.abs_integral_le_integral_abs h).trans
    calc
      _ ≤ ∫ t in lo i..hi i, |t - midpoint i| := by
        apply intervalIntegral.integral_mono_on h
          (Continuous.intervalIntegrable (by fun_prop) ..)
          (Continuous.intervalIntegrable (by fun_prop) ..)
        intro t _
        simpa only [sub_sub_sub_cancel_right] using abs_abs_sub_abs_le_abs_sub (t - u i)
          (midpoint i - u i)
      _ = _ := by
        have hm : midpoint i = (lo i + hi i) / 2 := by unfold midpoint lo hi; ring
        rw [hm, midpoint_integral _ _ h, hw]
  unfold uniformDistance unsignedScore
  rw [Finset.sum_div, ← Finset.sum_sub_distrib]
  calc
    _ ≤ _ := Finset.abs_sum_le_sum_abs _ _
    _ ≤ ∑ _i : Fin n, (1 / n : ℝ) ^ 2 / 4 := Finset.sum_le_sum fun i _ => bound i
    _ = _ := by simp; field_simp

end PITW
