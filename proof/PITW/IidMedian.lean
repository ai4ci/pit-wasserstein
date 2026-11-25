/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Baseline
public import PITW.QuantileInversion
public import PITW.MedianReference

/-! Threshold-count inversion for the central order statistics of iid observations. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

variable {Ω : Type*}

private def hits {N : ℕ} (u : Fin N → ℝ) (t : ℝ) : ℕ :=
  (Finset.univ.filter (fun j => u j ≤ t)).card

private lemma sum_hits {N : ℕ} (u : Fin N → ℝ) (t : ℝ) :
    (∑ i, if u i ≤ t then (1 : ℝ) else 0) = hits u t := by
  simp [hits]

/-- Sublevel sets of an order statistic are count events, including at ties. -/
theorem orderedPIT_le_iff (U : ℕ → Ω → ℝ) (N : ℕ) (ω : Ω) (i : Fin N) (t : ℝ) :
    orderedPIT U N ω i ≤ t ↔ i.val < (Finset.univ.filter (fun j : Fin N => U j ω ≤ t)).card := by
  let u := orderedPIT U N ω
  have mono : Monotone u := Tuple.monotone_sort (fun j : Fin N => U j ω)
  have perm : hits u t = hits (fun j : Fin N => U j ω) t := by
    apply Nat.cast_injective (R := ℝ)
    rw [← sum_hits, ← sum_hits]
    exact Equiv.sum_comp (Tuple.sort (fun j : Fin N => U j ω))
      (fun j : Fin N => if U j ω ≤ t then (1 : ℝ) else 0)
  change u i ≤ t ↔ i.val < hits _ t
  rw [← perm]
  constructor
  · intro h
    have sub : Finset.Iic i ⊆ Finset.univ.filter (fun j => u j ≤ t) :=
      fun j hj => Finset.mem_filter.mpr ⟨Finset.mem_univ _, (mono (Finset.mem_Iic.mp hj)).trans h⟩
    have := Finset.card_le_card sub
    rw [Fin.card_Iic] at this
    exact this
  · contrapose!
    intro h
    have sub : Finset.univ.filter (fun j => u j ≤ t) ⊆ Finset.Iio i := by
      intro j hj
      exact Finset.mem_Iio.mpr (lt_of_not_ge fun hij =>
        (h.trans_le (mono hij)).not_ge (Finset.mem_filter.mp hj).2)
    simpa [hits, Fin.card_Iio] using Finset.card_le_card sub

theorem measurable_orderedPIT [MeasurableSpace Ω] {U : ℕ → Ω → ℝ}
    (h : ∀ j, Measurable (U j)) (N : ℕ) (i : Fin N) :
    Measurable (fun ω => orderedPIT U N ω i) := by
  apply measurable_of_Iic
  intro t
  have e : (fun ω => orderedPIT U N ω i) ⁻¹' Iic t =
      {ω | (i : ℝ) < ∑ j : Fin N, if U j ω ≤ t then (1 : ℝ) else 0} := by
    ext ω
    rw [mem_preimage, mem_Iic, orderedPIT_le_iff, mem_ofPred_eq, sum_hits]
    exact_mod_cast Iff.rfl
  rw [e]
  exact measurableSet_lt measurable_const (Finset.measurable_fun_sum _ fun j _ =>
    measurable_const.ite (measurableSet_le (h j) measurable_const) measurable_const)

private lemma empiricalAt_hits (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (t : I) :
    empiricalAt U (n + 1) t ω =
      ((hits (fun j : Fin (n + 1) => U j ω) t : ℝ) - (n + 1) * t) / rankScale n := by
  rw [empiricalAt_eq_count, sum_hits, div_eq_inv_mul]
  simp [rankScale]

variable [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

/-- Either central PIT order statistic lies within δ of one half, with failure
probability bounded by 1/(2Nδ²). The event uses strict exceedance on both sides. -/
theorem iid_central_rank_tail (U : ℕ → Ω → ℝ) (hu : ∀ j, HasLaw (U j) uniformPIT P)
    (hi : iIndepFun U P) (n : ℕ) (i : Fin (n + 1))
    (hk : 2 * i.val ≤ n + 1 ∧ n + 1 ≤ 2 * (i.val + 1)) {δ : ℝ} (hd : 0 < δ) (hd' : δ ≤ 1 / 2) :
    P.real {ω | δ < |orderedPIT U (n + 1) ω i - 1 / 2|} ≤ 1 / (2 * (n + 1) * δ ^ 2) := by
  let l : I := ⟨1 / 2 - δ, by constructor <;> linarith⟩
  let r : I := ⟨1 / 2 + δ, by constructor <;> linarith⟩
  let b := rankScale n * δ
  have hb : 0 < b := mul_pos (rankScale_pos _) hd
  let bad (t : I) := {ω | b ≤ |empiricalAt U (n + 1) t ω|}
  have sub : {ω | δ < |orderedPIT U (n + 1) ω i - 1 / 2|} ⊆ bad l ∪ bad r := by
    intro ω h
    change δ < |orderedPIT U (n + 1) ω i - 1 / 2| at h
    have sqn : rankScale n ^ 2 = n + 1 := Real.sq_sqrt (by positivity)
    rcases lt_abs.mp h with h | h
    · right
      have hr : (r : ℝ) < orderedPIT U (n + 1) ω i := by dsimp [r]; linarith
      have card : hits (fun j : Fin (n + 1) => U j ω) r ≤ i.val :=
        Nat.le_of_not_gt (fun hc => hr.not_ge ((orderedPIT_le_iff ..).mpr hc))
      have hcard : (hits (fun j : Fin (n + 1) => U j ω) r : ℝ) ≤ i := by exact_mod_cast card
      have hk' : 2 * (i : ℝ) ≤ n + 1 := by exact_mod_cast hk.1
      change b ≤ |empiricalAt U (n + 1) r ω|
      apply le_trans _ (neg_le_abs _)
      rw [empiricalAt_hits, ← neg_div, le_div_iff₀ (rankScale_pos _)]
      dsimp [r,b]; nlinarith [sqn, congrArg (· * δ) sqn]
    · left
      have hl : orderedPIT U (n + 1) ω i ≤ (l : ℝ) := by dsimp [l]; linarith
      have card : i.val + 1 ≤ hits (fun j : Fin (n + 1) => U j ω) l :=
        (orderedPIT_le_iff ..).mp hl
      have hcard : (i : ℝ) + 1 ≤ (hits (fun j : Fin (n + 1) => U j ω) l : ℝ) := by
        exact_mod_cast card
      have hk' : (n : ℝ) + 1 ≤ 2 * ((i : ℝ) + 1) := by exact_mod_cast hk.2
      change b ≤ |empiricalAt U (n + 1) l ω|
      apply le_trans _ (le_abs_self _)
      rw [empiricalAt_hits, le_div_iff₀ (rankScale_pos _)]
      dsimp [l,b]; nlinarith [sqn, congrArg (· * δ) sqn]
  apply (measureReal_mono sub).trans ((measureReal_union_le _ _).trans _)
  have bound (t : I) := iid_empirical_tail U hu hi (Nat.succ_pos n) t hb
  apply (add_le_add (bound l) (bound r)).trans
  have sqn : rankScale n ^ 2 = n + 1 := Real.sq_sqrt (by positivity)
  simp only [b, mul_pow, sqn]
  have hn : 0 < (n : ℝ) + 1 := by positivity
  apply le_of_eq
  field_simp
  ring

/-- The centred empirical count at a moving, deterministic threshold has the
same first-order fluctuation as the count at its limit. -/
theorem iid_moving_threshold (U : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (U j))
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P)
    (t : ℕ → I) (a : I) (ht : Tendsto (fun n => (t n : ℝ)) atTop (𝓝 (a : ℝ))) :
    TendstoInMeasure P (fun n ω => empiricalAt U (n + 1) (t n) ω - empiricalAt U (n + 1) a ω)
      atTop 0 := by
  let D n ω := empiricalAt U (n + 1) (t n) ω - empiricalAt U (n + 1) a ω
  have int n : Integrable (fun ω => |D n ω|) P := by
    have me (s : I) := (empiricalAt_measurable hm (n + 1)).comp
      (measurable_const (a := s) |>.prodMk (measurable_id (α := Ω)))
    apply Integrable.of_bound ((me (t n)).sub (me a)).abs.aestronglyMeasurable
      (2 * ((Real.sqrt (n + 1 : ℕ))⁻¹ * ((n + 1 : ℕ) + (n + 1 : ℕ) : ℝ)))
    apply ae_of_all; intro ω
    simp only [Real.norm_eq_abs, abs_abs]
    apply (abs_sub ..).trans
    rw [two_mul]
    exact add_le_add (empiricalAt_bound ..) (empiricalAt_bound ..)
  have bound n : (∫ ω, |D n ω| ∂P) ≤ Real.sqrt |(t n : ℝ) - a| := by
    rcases le_total a (t n) with h | h
    · rw [abs_of_nonneg (sub_nonneg.mpr (show (a : ℝ) ≤ t n from h))]
      exact iid_empirical_increment U hu hi _ _ _ h
    · simp only [D, abs_sub_comm (empiricalAt U _ (t n) _), abs_sub_comm (t n : ℝ) a,
        abs_of_nonneg (sub_nonneg.mpr (show (t n : ℝ) ≤ a from h))]
      exact iid_empirical_increment U hu hi _ _ _ h
  apply tendstoInMeasure_iff_measureReal_norm.mpr
  intro ε hε
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs]
  have hlim : Tendsto (fun n => Real.sqrt |(t n : ℝ) - a| / ε) atTop (𝓝 0) := by
    simpa using (ht.sub_const (a : ℝ)).abs.sqrt.div_const ε
  apply squeeze_zero (fun _ => measureReal_nonneg) _ hlim
  intro n
  apply (le_div_iff₀ hε).mpr
  rw [mul_comm]
  exact (mul_meas_ge_le_integral_of_nonneg (ae_of_all P (fun ω => abs_nonneg (D n ω)))
    (int n) ε).trans (bound n)

private abbrev densityZero := gaussianPDFReal 0 1 0
private lemma densityZero_pos : 0 < densityZero := gaussianPDFReal_pos 0 _ _ one_ne_zero

private def threshold (x : ℝ) (n : ℕ) : I :=
  ⟨Φ (x / rankScale n), cdf_nonneg _ _, cdf_le_one _ _⟩

private lemma threshold_limit (x : ℝ) :
    Tendsto (fun n => (threshold x n : ℝ)) atTop (𝓝 (1 / 2 : ℝ)) := by
  simpa only [threshold, normalCDF_zero, Function.comp_def] using
    (normalCDF_deriv 0).continuousAt.tendsto.comp (rankScale_atTop.const_div_atTop x)

private lemma threshold_drift (x : ℝ) :
    Tendsto (fun n => rankScale n * ((threshold x n : ℝ) - 1 / 2) - densityZero * x)
      atTop (𝓝 0) := by
  apply squeeze_zero_norm' _ ((rankScale_atTop.const_div_atTop (densityZero * x^2)))
  apply Eventually.of_forall; intro n
  have h := normal_shift_remainder 0 (-(x / rankScale n))
  simp only [sub_neg_eq_add, zero_add, normalCDF_zero, neg_mul, ← sub_eq_add_neg, neg_sq] at h
  have hp := rankScale_pos n
  calc
    _ = rankScale n * |Φ (x / rankScale n) - 1 / 2 - x / rankScale n * densityZero| := by
      rw [Real.norm_eq_abs, show rankScale n * |_ - x / rankScale n * densityZero| =
        |rankScale n * (Φ (x / rankScale n) - 1 / 2 - x / rankScale n * densityZero)| by
          rw [abs_mul, abs_of_pos hp]]
      congr 1
      change rankScale n * (Φ (x / rankScale n) - 1 / 2) - densityZero * x = _
      field_simp
    _ ≤ rankScale n * (densityZero * (x / rankScale n)^2) := mul_le_mul_of_nonneg_left h hp.le
    _ = _ := by field_simp

private def offset (n : ℕ) (i : Fin (n + 1)) : ℝ :=
  ((i : ℝ) + 1 - (n + 1) / 2) / rankScale n

private lemma offset_limit (i : (n : ℕ) → Fin (n + 1))
    (hk : ∀ n, 2 * (i n).val ≤ n + 1 ∧ n + 1 ≤ 2 * ((i n).val + 1)) :
    Tendsto (fun n => offset n (i n)) atTop (𝓝 0) := by
  apply squeeze_zero' _ _ (rankScale_atTop.const_div_atTop 1)
  · apply Eventually.of_forall; intro n
    have hk' : (n : ℝ) + 1 ≤ 2 * ((i n : ℝ) + 1) := by exact_mod_cast (hk n).2
    exact div_nonneg (by linarith) (rankScale_pos _).le
  · apply Eventually.of_forall; intro n
    have hk' : 2 * (i n : ℝ) ≤ n + 1 := by exact_mod_cast (hk n).1
    exact div_le_div_of_nonneg_right (by linarith) (rankScale_pos _).le

/-- Empirical fluctuation at one half, expressed on the standard normal scale. -/
@[expose] def medianInfluence (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : ℝ :=
  -empiricalAt U (n + 1) unitHalf ω / gaussianPDFReal 0 1 0

private lemma influence_tight (U : ℕ → Ω → ℝ) (hu : ∀ j, HasLaw (U j) uniformPIT P)
    (hi : iIndepFun U P) (η : ℝ) (hη : 0 < η) :
    ∃ K > (0 : ℝ), ∀ᶠ n in atTop, P.real {ω | K ≤ |medianInfluence U n ω|} < η := by
  let b := 1 + 1 / η
  have hb : 0 < b := by dsimp [b]; positivity
  refine ⟨b / densityZero, div_pos hb densityZero_pos, .of_forall fun n => ?_⟩
  have e : {ω | b / densityZero ≤ |medianInfluence U n ω|} =
      {ω | b ≤ |empiricalAt U (n + 1) unitHalf ω|} := by
    ext ω
    simp only [mem_ofPred_eq, medianInfluence, abs_div, abs_neg, abs_of_pos densityZero_pos,
      div_le_div_iff_of_pos_right densityZero_pos]
  rw [e]
  apply (iid_empirical_tail U hu hi (Nat.succ_pos n) unitHalf hb).trans_lt
  dsimp [b]
  field_simp
  nlinarith [sq_nonneg η]

/-- On the original sample space, each central normal order statistic has the
same first-order error as the centred count at one half. -/
theorem iid_central_rank_expansion (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hu : ∀ j, HasLaw (Φ ∘ Z j) uniformPIT P) (hi : iIndepFun (fun j => Φ ∘ Z j) P)
    (i : (n : ℕ) → Fin (n + 1)) (hk : ∀ n, 2 * (i n).val ≤ n + 1 ∧ n + 1 ≤ 2 * ((i n).val + 1)) :
    TendstoInMeasure P (fun n ω => rankScale n * orderedPIT Z (n + 1) ω (i n) -
      medianInfluence (fun j => Φ ∘ Z j) n ω) atTop 0 := by
  let U := fun j => Φ ∘ Z j
  let X n ω := rankScale n * orderedPIT Z (n + 1) ω (i n)
  let Y := medianInfluence U
  let D x n ω := empiricalAt U (n + 1) (threshold x n) ω - empiricalAt U (n + 1) unitHalf ω
  let a x n := rankScale n * ((threshold x n : ℝ) - 1 / 2) - densityZero * x - offset n (i n)
  let R x n ω := (D x n ω + a x n) / densityZero
  refine quantile_inversion_in_measure (P := P) X Y R (influence_tight U hu hi) ?_ ?_
  · intro x
    have hΦ : Measurable Φ :=
      (continuous_iff_continuousAt.mpr fun y => (normalCDF_deriv y).continuousAt).measurable
    have hD := iid_moving_threshold U (fun j => hΦ.comp (hm j)) hu hi
      (threshold x) unitHalf (threshold_limit x)
    have ha : Tendsto (a x) atTop (𝓝 0) := by
      simpa only [sub_zero] using (threshold_drift x).sub (offset_limit i hk)
    rw [tendstoInMeasure_iff_measureReal_norm] at hD ⊢
    intro ε hε
    let b := densityZero * ε / 2
    have hb : 0 < b := by dsimp [b]; positivity [densityZero_pos]
    have lim := hD b hb
    simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] at lim ⊢
    apply squeeze_zero' (.of_forall fun _ => measureReal_nonneg) _ lim
    filter_upwards [show ∀ᶠ n in atTop, |a x n| < b by
      simpa using (ha.abs.eventually_lt_const (by simpa using hb : |(0 : ℝ)| < b))] with n hn
    refine measureReal_mono ?_ (measure_ne_top _ _)
    intro ω h
    change ε ≤ |(D x n ω + a x n) / densityZero| at h
    rw [abs_div, abs_of_pos densityZero_pos, le_div_iff₀ densityZero_pos] at h
    change b ≤ |D x n ω|
    dsimp [b] at *
    linarith [abs_add_le (D x n ω) (a x n)]
  · intro x n ω
    let t := threshold x n
    let C := hits (fun j : Fin (n + 1) => U j ω) t
    have counts : C = hits (fun j : Fin (n + 1) => Z j ω) (x / rankScale n) := by
      simp only [C, t, threshold, hits, U, Function.comp_apply, normalCDF_strictMono.le_iff_le]
    have cross : X n ω ≤ x ↔ (i n : ℝ) + 1 ≤ (C : ℝ) := by
      change rankScale n * orderedPIT Z (n + 1) ω (i n) ≤ x ↔ _
      rw [mul_comm, ← le_div_iff₀ (rankScale_pos _), orderedPIT_le_iff, counts]
      exact_mod_cast (Nat.lt_iff_add_one_le)
    rw [cross]
    have hp := rankScale_pos n
    have hs : rankScale n ^ 2 = n + 1 := Real.sq_sqrt (by positivity)
    have ec := empiricalAt_hits U n ω t
    change empiricalAt U (n + 1) t ω = ((C : ℝ) - ((n : ℝ) + 1) * (t : ℝ)) / rankScale n at ec
    change _ ↔ -empiricalAt U (n + 1) unitHalf ω / densityZero ≤ x +
      ((empiricalAt U (n + 1) t ω - empiricalAt U (n + 1) unitHalf ω) +
      (rankScale n * ((t : ℝ) - 1 / 2) - densityZero * x - offset n (i n))) / densityZero
    rw [show x + _ / densityZero = (x * densityZero +
        ((empiricalAt U (n + 1) t ω - empiricalAt U (n + 1) unitHalf ω) +
        (rankScale n * ((t : ℝ) - 1 / 2) - densityZero * x - offset n (i n)))) / densityZero by
          rw [add_div (x * densityZero), mul_div_cancel_right₀ _ densityZero_pos.ne']]
    rw [div_le_div_iff_of_pos_right densityZero_pos, ec]
    unfold offset
    have e : (C - ((n : ℝ) + 1) * (t : ℝ)) / rankScale n +
        rankScale n * ((t : ℝ) - 1 / 2) - (((i n : ℝ) + 1-((n : ℝ) + 1) / 2) / rankScale n) =
        (C - ((i n : ℝ) + 1)) / rankScale n := by
      field_simp
      nlinarith [congrArg (· * (t : ℝ)) hs]
    have hh : 0 ≤ ((C : ℝ) - ((i n : ℝ) + 1)) / rankScale n ↔
        0 ≤ (C : ℝ) - ((i n : ℝ) + 1) := by rw [le_div_iff₀ hp, zero_mul]
    constructor <;> intro h
    · linarith [hh.mpr (sub_nonneg.mpr h)]
    · apply sub_nonneg.mp
      apply hh.mp
      linarith

/-- The fitted normal-scale median has the same first-order fluctuation as the
midpoint threshold count. This includes averaging two order statistics when N is even. -/
theorem iid_normalMedian_expansion (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hu : ∀ j, HasLaw (Φ ∘ Z j) uniformPIT P) (hi : iIndepFun (fun j => Φ ∘ Z j) P) :
    TendstoInMeasure P (fun n ω => rankScale n * normalMedian n (orderedPIT Z (n + 1) ω) -
      medianInfluence (fun j => Φ ∘ Z j) n ω) atTop 0 := by
  let lo (n : ℕ) : Fin (n + 1) := ⟨n / 2, by omega⟩
  let up (n : ℕ) : Fin (n + 1) := ⟨(n + 1) / 2, by omega⟩
  let Y := medianInfluence (fun j => Φ ∘ Z j)
  let err (i : (n : ℕ) → Fin (n + 1)) n ω := rankScale n * orderedPIT Z (n + 1) ω (i n) - Y n ω
  have hl := iid_central_rank_expansion Z hm hu hi lo (by intro n; dsimp [lo]; omega)
  have hr := iid_central_rank_expansion Z hm hu hi up (by intro n; dsimp [up]; omega)
  rw [tendstoInMeasure_iff_measureReal_norm] at hl hr ⊢
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] at hl hr ⊢
  intro ε hε
  have lim := (hl ε hε).add (hr ε hε)
  rw [add_zero] at lim
  apply squeeze_zero (fun _ => measureReal_nonneg) _ lim
  intro n
  apply le_trans _ (measureReal_union_le {ω | ε ≤ |err lo n ω|} {ω | ε ≤ |err up n ω|})
  refine measureReal_mono ?_ (measure_ne_top _ _)
  intro ω h
  by_contra hn
  have h1 : |err lo n ω| < ε := lt_of_not_ge (fun he => hn (Or.inl he))
  have h2 : |err up n ω| < ε := lt_of_not_ge (fun he => hn (Or.inr he))
  have e : rankScale n * normalMedian n (orderedPIT Z (n + 1) ω) - Y n ω =
      (err lo n ω + err up n ω) / 2 := by dsimp [err, lo, up, normalMedian]; ring
  change ε ≤ |rankScale n * normalMedian n (orderedPIT Z (n + 1) ω) - Y n ω| at h
  rw [e, abs_div, abs_of_pos (by norm_num : (0 : ℝ)<2), le_div_iff₀ (by norm_num)] at h
  linarith [abs_add_le (err lo n ω) (err up n ω)]

/-- Tightness of the fitted median on the square-root sample-size scale. -/
theorem iid_normalMedian_tight (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hu : ∀ j, HasLaw (Φ ∘ Z j) uniformPIT P) (hi : iIndepFun (fun j => Φ ∘ Z j) P) :
    ∀ η > (0 : ℝ), ∃ K > (0 : ℝ), ∀ᶠ n in atTop,
      P.real {ω | K ≤ |rankScale n * normalMedian n (orderedPIT Z (n + 1) ω)|} < η := by
  let Y := medianInfluence (fun j => Φ ∘ Z j)
  let X n ω := rankScale n * normalMedian n (orderedPIT Z (n + 1) ω)
  intro η hη
  obtain ⟨K, hK, bound⟩ := influence_tight _ hu hi (η / 2) (half_pos hη)
  have h := tendstoInMeasure_iff_measureReal_norm.mp (iid_normalMedian_expansion Z hm hu hi)
    1 (by norm_num)
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs] at h
  refine ⟨K + 1, by positivity, ?_⟩
  filter_upwards [bound, h.eventually_lt_const (half_pos hη)] with n hn hn'
  apply lt_of_le_of_lt _ (show P.real {ω | K ≤ |Y n ω|} + P.real {ω | 1 ≤ |X n ω - Y n ω|} < η
    by linarith)
  apply le_trans _ (measureReal_union_le ..)
  refine measureReal_mono ?_ (measure_ne_top _ _)
  intro ω hw
  change K + 1 ≤ |X n ω| at hw
  change K ≤ |Y n ω| ∨ 1 ≤ |X n ω - Y n ω|
  by_contra! hω
  linarith [abs_sub_abs_le_abs_sub (X n ω) (Y n ω)]


/-- Under iid standard normal sampling the scaled median converges to N(0, π/2).
The sample includes both the odd- and even-size conventions. -/
theorem iid_normalMedian_limit (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hz : ∀ j, HasLaw (Z j) (gaussianReal 0 1) P) (hi : iIndepFun Z P) :
    TendstoInDistribution (fun n ω => rankScale n * normalMedian n (orderedPIT Z (n + 1) ω))
      atTop id (fun _ => P) (gaussianReal 0 (Real.pi / 2).toNNReal) := by
  let U := fun j => Φ ∘ Z j
  have hu j := stdNormal_pit_law (hz j)
  have hind : iIndepFun U P := hi.comp _ (fun _ => normalCDF_strictMono.monotone.measurable)
  have h := iid_median_reference_gaussian_limit U hu hind
  apply tendstoInDistribution_of_tendstoInMeasure_sub (X := medianInfluence U) _ _ h
    (iid_normalMedian_expansion Z hm hu hind)
  intro n
  exact (((measurable_orderedPIT hm _ _).add (measurable_orderedPIT hm _ _)).div_const 2
    |>.const_mul (rankScale n)).aemeasurable

end PITW
