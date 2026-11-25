/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.IidMedian
public import PITW.RankLimits

/-! Empirical quantiles and their pointwise approximation by centred PIT counts. -/

public section
noncomputable section
open Filter Set MeasureTheory ProbabilityTheory
open scoped Topology unitInterval
namespace PITW

variable {Ω : Type*}

private def hits (U : ℕ → Ω → ℝ) (N : ℕ) (ω : Ω) (t : ℝ) : ℕ :=
  (Finset.univ.filter (fun i : Fin N => U i ω ≤ t)).card

/-- At a displacement of x/√N from a plotting position, the deviation of the
count from the midpoint rank determines the empirical fluctuation. -/
private lemma displaced_count (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (i : Fin (n + 1))
    (q : I) (x : ℝ) (hq : (q : ℝ) = midpoint i + x / rankScale n) :
    empiricalAt U (n + 1) q ω =
      ((hits U (n + 1) ω q : ℝ) - i - 1 / 2) / rankScale n - x := by
  rw [empiricalAt_eq_count]
  have hc : (∑ j : Fin (n + 1), if U j ω ≤ q then (1 : ℝ) else 0) = hits U (n + 1) ω q := by
    simp [hits]
  rw [hc]
  simp only [Nat.cast_add, Nat.cast_one, ← div_eq_inv_mul]
  change (_ - ((n : ℝ) + 1) * (q : ℝ)) / rankScale n = _
  rw [hq]
  have hp := rankScale_pos n
  have hs : rankScale n ^ 2 = (n : ℝ) + 1 := Real.sq_sqrt (by positivity)
  have hn : 0 < (n : ℝ) + 1 := by positivity
  simp only [midpoint, Nat.cast_add, Nat.cast_one]
  field_simp
  nlinarith [congrArg (· * x) hs]

variable [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

/-- A uniform quadratic tail bound for the scaled error of any PIT plotting position.
The bound is independent of the sample size and the rank. -/
theorem iid_rank_discrepancy_tail (U : ℕ → Ω → ℝ)
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P)
    (n : ℕ) (i : Fin (n + 1)) {b : ℝ} (hb : 0 < b) :
    P.real {ω | b ≤ |rankScale n * (midpoint i - orderedPIT U (n + 1) ω i)|} ≤ 2 / b ^ 2 := by
  have support : ∀ᵐ ω ∂P, ∀ j, U j ω ∈ Icc (0 : ℝ) 1 := by
    apply ae_all_iff.mpr; intro j
    exact ((hu j).ae_iff (measurableSet_setOfPred.mp measurableSet_Icc)).mpr
      (ae_restrict_mem measurableSet_Icc)
  let v := b / 2
  have hv : 0 < v := half_pos hb
  have hs := rankScale_pos n
  let p := midpoint i
  have hp : p ∈ Icc (0 : ℝ) 1 := (midUnit i).property
  let q (x : ℝ) : I := if h : p + x / rankScale n ∈ Icc (0 : ℝ) 1 then ⟨_, h⟩ else 0
  let bad (x : ℝ) := {ω | v ≤ |empiricalAt U (n + 1) (q x) ω|}
  have incl : {ω | b ≤ |rankScale n * (midpoint i - orderedPIT U (n + 1) ω i)|}
      ≤ᵐ[P] bad (-v) ∪ bad v := by
    filter_upwards [support] with ω hω
    let z := orderedPIT U (n + 1) ω i
    have hz : z ∈ Icc (0 : ℝ) 1 := hω _
    intro he
    change b ≤ |rankScale n * (p - z)| at he
    rcases le_abs.mp he with hl | hr
    · left
      have lower : z ≤ p + (-v) / rankScale n := by
        have hh : v / rankScale n ≤ p - z := (div_le_iff₀ hs).mpr (by dsimp [v]; nlinarith)
        rw [neg_div]; linarith
      have hneg := div_nonpos_of_nonpos_of_nonneg (neg_nonpos.mpr hv.le) hs.le
      have hq : (q (-v) : ℝ) = p + (-v) / rankScale n := by
        simp only [q, dite_eq_left (show p + -v / rankScale n ∈ Icc (0 : ℝ) 1 from
          ⟨hz.1.trans lower, by linarith [hp.2]⟩)]
      have hcount : i.val + 1 ≤ hits U (n + 1) ω (q (-v)) :=
        (orderedPIT_le_iff ..).mp (hq ▸ lower)
      have hc : (i : ℝ) + 1 ≤ (hits U (n + 1) ω (q (-v)) : ℝ) := by exact_mod_cast hcount
      change v ≤ |empiricalAt U (n + 1) (q (-v)) ω|
      apply le_trans _ (le_abs_self _)
      rw [displaced_count U n ω i _ _ hq, sub_neg_eq_add]
      linarith [div_nonneg (by linarith : 0 ≤ (hits U (n + 1) ω (q (-v)) : ℝ) - i - 1 / 2) hs.le]
    · right
      have upper : p + v / rankScale n < z := by
        have hh : v / rankScale n < z - p := (div_lt_iff₀ hs).mpr (by dsimp [v]; nlinarith)
        linarith
      have hq : (q v : ℝ) = p + v / rankScale n := by
        simp only [q, dite_eq_left (show p + v / rankScale n ∈ Icc (0 : ℝ) 1 from
          ⟨add_nonneg hp.1 (div_nonneg hv.le hs.le), upper.le.trans hz.2⟩)]
      have hcount : hits U (n + 1) ω (q v) ≤ i.val := Nat.le_of_not_gt fun hh =>
        upper.not_ge (hq ▸ (orderedPIT_le_iff U _ ω i (q v)).mpr hh)
      have hc : (hits U (n + 1) ω (q v) : ℝ) ≤ i := by exact_mod_cast hcount
      change v ≤ |empiricalAt U (n + 1) (q v) ω|
      apply le_trans _ (neg_le_abs _)
      rw [displaced_count U n ω i _ _ hq]
      linarith [div_nonpos_of_nonpos_of_nonneg
        (by linarith : (hits U (n + 1) ω (q v) : ℝ) - i - 1 / 2 ≤ 0) hs.le]
  have hmono := measure_mono_ae incl
  apply (ENNReal.toReal_mono (measure_ne_top P _) hmono).trans ((measureReal_union_le _ _).trans _)
  have bound x := iid_empirical_tail U hu hi (Nat.succ_pos n) (q x) hv
  apply (add_le_add (bound (-v)) (bound v)).trans_eq
  dsimp [v]
  field_simp
  ring

/-- At an interior PIT threshold, a quantile whose plotting positions approach
the threshold has the same first-order error as the empirical CDF there. -/
theorem iid_rank_point_error_of_tendsto (U : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (U j))
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P)
    (t : I) (ht : (t : ℝ) ∈ Ioo 0 1) (i : (n : ℕ) → Fin (n + 1))
    (hc : Tendsto (fun n => midpoint (i n)) atTop (𝓝 (t : ℝ))) :
    TendstoInMeasure P (fun n ω => rankScale n * (midpoint (i n) - orderedPIT U (n + 1) ω (i n)) -
      empiricalAt U (n + 1) t ω) atTop 0 := by
  let X n ω := rankScale n * (orderedPIT U (n + 1) ω (i n) - midpoint (i n))
  let E n (q : I) ω := empiricalAt U (n + 1) q ω
  let Y n ω := -E n t ω
  let p x n := midpoint (i n) + x / rankScale n
  let q x n : I := if h : p x n ∈ Icc (0 : ℝ) 1 then ⟨_, h⟩ else t
  let c n := (1 / 2 : ℝ) / rankScale n
  let D x n ω := E n (q x n) ω - E n t ω
  let R x n ω := if p x n ∈ Icc (0 : ℝ) 1 then D x n ω - c n
    else if X n ω ≤ x then Y n ω - x else Y n ω - x - 1
  have hp x : Tendsto (p x) atTop (𝓝 (t : ℝ)) := by
    simpa [p] using hc.add (rankScale_atTop.const_div_atTop x)
  have interior x : ∀ᶠ n in atTop, p x n ∈ Icc (0 : ℝ) 1 :=
    ((hp x).eventually_mem (isOpen_Ioo.mem_nhds ht)).mono fun _ h => ⟨h.1.le, h.2.le⟩
  have qlim x : Tendsto (fun n => (q x n : ℝ)) atTop (𝓝 (t : ℝ)) :=
    (hp x).congr' ((interior x).mono fun n h => by simp only [q, dite_eq_left h])
  have tight : ∀ η > (0 : ℝ), ∃ K > (0 : ℝ), ∀ᶠ n in atTop, P.real {ω | K ≤ |Y n ω|} < η := by
    intro η hη
    let K := 1 + 1 / η
    have hK : 0 < K := by dsimp [K]; positivity
    refine ⟨K, hK, .of_forall fun n => ?_⟩
    simp only [Y, abs_neg, E]
    apply (iid_empirical_tail U hu hi (Nat.succ_pos n) t hK).trans_lt
    dsimp [K]
    field_simp
    nlinarith [sq_nonneg η]
  have herr : TendstoInMeasure P (fun n ω => X n ω - Y n ω) atTop 0 := by
    apply quantile_inversion_in_measure X Y R tight
    · intro x
      have hD := iid_moving_threshold U hm hu hi (q x) t (qlim x)
      have hsmall : Tendsto c atTop (𝓝 0) := rankScale_atTop.const_div_atTop _
      apply tendstoInMeasure_iff_measureReal_norm.mpr
      intro ε hε
      have hlim := tendstoInMeasure_iff_measureReal_norm.mp hD (ε / 2) (half_pos hε)
      simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] at hlim ⊢
      apply squeeze_zero' (.of_forall fun _ => measureReal_nonneg) _ hlim
      filter_upwards [interior x, hsmall.eventually_lt_const (half_pos hε)] with n hn hcn
      apply measureReal_mono _ (measure_ne_top _ _)
      intro ω hω
      change ε ≤ |R x n ω| at hω
      simp only [R, hn, ite_true] at hω
      have hpos : 0 ≤ c n := div_nonneg (by norm_num) (rankScale_pos n).le
      have h := abs_sub (D x n ω) (c n)
      rw [abs_of_nonneg hpos] at h
      change ε / 2 ≤ |D x n ω|
      linarith
    · intro x n ω
      by_cases hq : p x n ∈ Icc (0 : ℝ) 1
      · have eq : (q x n : ℝ) = p x n := by simp only [q, dite_eq_left hq]
        let C := hits U (n + 1) ω (q x n)
        have hs := rankScale_pos n
        have cross : X n ω ≤ x ↔ (i n : ℝ) + 1 ≤ (C : ℝ) := by
          change rankScale n * (_ - _) ≤ x ↔ _
          rw [mul_comm, ← le_div_iff₀ hs]
          have hcmp : orderedPIT U (n + 1) ω (i n) - midpoint (i n) ≤ x / rankScale n ↔
              orderedPIT U (n + 1) ω (i n) ≤ q x n := by
            rw [eq]
            dsimp [p]
            constructor <;> intro h <;> linarith
          rw [hcmp, orderedPIT_le_iff]
          exact_mod_cast Nat.lt_iff_add_one_le
        rw [cross]
        have count := displaced_count U n ω (i n) (q x n) x eq
        change E n (q x n) ω = ((C : ℝ) - i n - 1 / 2) / rankScale n - x at count
        change _ ↔ -E n t ω ≤ x + R x n ω
        simp only [R, hq, ite_true, D, count, c]
        have arith : 0 ≤ (((C : ℝ) - i n - 1 / 2) / rankScale n - (1 / 2) / rankScale n) ↔
            (i n : ℝ) + 1 ≤ C := by
          rw [← sub_div, le_div_iff₀ hs, zero_mul]
          constructor <;> intro h <;> linarith
        constructor
        · intro h; linarith [arith.mpr h]
        · intro h; apply arith.mp; linarith
      · simp only [R, hq, ite_false]
        by_cases h : X n ω ≤ x <;> simp [h]; linarith
  rw [tendstoInMeasure_iff_measureReal_norm] at herr ⊢
  intro ε hε
  specialize herr ε hε
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] at herr ⊢
  have he n ω : |rankScale n * (midpoint (i n) - orderedPIT U (n + 1) ω (i n)) -
      empiricalAt U (n + 1) t ω| = |X n ω - Y n ω| := by
    rw [← abs_neg (X n ω - Y n ω)]
    congr 1
    dsimp [X, Y, E]
    ring
  simpa only [he] using herr

/-- Pointwise approximation for the cell convention used by the rank path. -/
theorem iid_rank_point_error (U : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (U j))
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P)
    (t : I) (ht : (t : ℝ) ∈ Ioo 0 1) (i : (n : ℕ) → Fin (n + 1))
    (hc : ∀ n, (i n : ℝ) / (n + 1) < t ∧ (t : ℝ) ≤ ((i n : ℝ) + 1) / (n + 1)) :
    TendstoInMeasure P (fun n ω => rankScale n * (midpoint (i n) - orderedPIT U (n + 1) ω (i n)) -
      empiricalAt U (n + 1) t ω) atTop 0 :=
  iid_rank_point_error_of_tendsto U hm hu hi t ht i (inCell_midpoint i hc)

end PITW
