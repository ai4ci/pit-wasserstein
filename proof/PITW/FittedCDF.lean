/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.EmpiricalGrid
public import PITW.SampleMedian
import Mathlib.MeasureTheory.Constructions.Polish.Basic

/-! Empirical CDF increments at fitted normal-location thresholds. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

local notation "dens" => gaussianPDFReal 0 1 0
private theorem normalEmbedding : MeasurableEmbedding Φ :=
  normalCDF_strictMono.monotone.measurable.measurableEmbedding normalCDF_strictMono.injective

/-- Normal-scale shift of a PIT threshold. Both endpoints remain fixed. -/
def shiftPIT (h : ℝ) (t : I) : I := by
  classical
  exact if (t : ℝ) ∈ Set.range Φ then
    ⟨Φ (normalEmbedding.invFun t + h), cdf_nonneg _ _, cdf_le_one _ _⟩ else t

theorem shiftPIT_cdf (h z : ℝ) :
    (shiftPIT h ⟨Φ z, cdf_nonneg _ _, cdf_le_one _ _⟩ : ℝ) = Φ (z + h) := by
  simp [shiftPIT, normalEmbedding.leftInverse_invFun z]

@[simp] theorem shiftPIT_zero (t : I) : shiftPIT 0 t = t := by
  rcases t with ⟨t, ht⟩
  by_cases h : t ∈ range Φ
  · obtain ⟨z, rfl⟩ := h
    exact Subtype.ext (by simpa using shiftPIT_cdf 0 z)
  · simp [shiftPIT, h]

theorem shiftPIT_mono (t : I) : Monotone (fun h => shiftPIT h t) := by
  intro a b hab
  rcases t with ⟨t, ht⟩
  by_cases h : t ∈ range Φ
  · obtain ⟨z, rfl⟩ := h
    change (shiftPIT a _ : ℝ) ≤ (shiftPIT b _ : ℝ)
    rw [shiftPIT_cdf, shiftPIT_cdf]
    exact normalCDF_strictMono.monotone (by linarith)
  · simp [shiftPIT, h]

theorem shiftPIT_lipschitz (a b : ℝ) (t : I) :
    |(shiftPIT a t : ℝ) - shiftPIT b t| ≤ dens * |a - b| := by
  rcases t with ⟨t, ht⟩
  by_cases h : t ∈ range Φ
  · obtain ⟨z, rfl⟩ := h
    rw [shiftPIT_cdf, shiftPIT_cdf]
    simpa using normalCDF_lipschitz (z+b) (z+a)
  · simp only [shiftPIT, h, ite_false, sub_self, abs_zero]
    exact mul_nonneg (gaussianPDFReal_nonneg ..) (abs_nonneg _)

theorem shiftPIT_measurable : Measurable (fun p : ℝ × I => shiftPIT p.1 p.2) := by
  classical
  unfold shiftPIT
  apply Measurable.ite _ _ measurable_snd
  · exact (measurable_subtypeVal.comp measurable_snd) normalEmbedding.measurableSet_range
  · apply Measurable.subtype_mk
    exact normalEmbedding.measurable.comp (((normalEmbedding.measurable_invFun.comp
      measurable_subtypeVal).comp measurable_snd).add measurable_fst)

/-- Integral of the absolute centred empirical fluctuation produced by the
deterministic displacement h on the normal scale. -/
@[expose] def shiftIncrement {Ω : Type*} (U : ℕ → Ω → ℝ) (n : ℕ) (h : ℝ) (ω : Ω) : ℝ :=
  ∫ t : I, |empiricalAt U (n+1) (shiftPIT h t) ω - empiricalAt U (n+1) t ω|

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

private lemma shiftJoint {U : ℕ → Ω → ℝ} (hm : ∀ i, Measurable (U i)) (n : ℕ) (h : ℝ) :
    Measurable (fun p : I × Ω => |empiricalAt U (n+1) (shiftPIT h p.1) p.2 -
      empiricalAt U (n+1) p.1 p.2|) := by
  have e := empiricalAt_measurable hm (n+1)
  have hs : Measurable (fun p : I × Ω => shiftPIT h p.1) :=
    shiftPIT_measurable.comp (measurable_const.prodMk measurable_fst)
  exact ((e.comp (hs.prodMk measurable_snd)).sub e).abs

omit [MeasurableSpace Ω] in
private lemma shiftBound (U : ℕ → Ω → ℝ) (n : ℕ) (h : ℝ) (t : I) (ω : Ω) :
    |empiricalAt U (n+1) (shiftPIT h t) ω - empiricalAt U (n+1) t ω| ≤
      2 * ((Real.sqrt (n+1))⁻¹ * ((n+1) + (n+1) : ℝ)) := by
  have b₁ := empiricalAt_bound U (n+1) (shiftPIT h t) ω
  have b₂ := empiricalAt_bound U (n+1) t ω
  simpa [two_mul] using (abs_sub ..).trans (add_le_add b₁ b₂)

theorem shiftIncrement_integrand_integrable {U : ℕ → Ω → ℝ} (hm : ∀ i, Measurable (U i))
    (n : ℕ) (h : ℝ) (ω : Ω) :
    Integrable (fun t => |empiricalAt U (n+1) (shiftPIT h t) ω - empiricalAt U (n+1) t ω|) := by
  apply Integrable.of_bound ((shiftJoint hm n h).comp
    (measurable_id.prodMk measurable_const)).aestronglyMeasurable _
  exact ae_of_all _ fun t => by simpa using shiftBound U n h t ω

/-- Expected integrated error of evaluating the empirical process at a
fixed shifted threshold, uniformly in sample size. -/
theorem iid_shiftIncrement_mean (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P) (n : ℕ) (h : ℝ) :
    (∫ ω, shiftIncrement U n h ω ∂P) ≤ Real.sqrt (dens * |h|) := by
  let D t ω := |empiricalAt U (n+1) (shiftPIT h t) ω - empiricalAt U (n+1) t ω|
  have hD : Integrable (Function.uncurry D) (volume.prod P) :=
    Integrable.of_bound (shiftJoint hm n h).aestronglyMeasurable _
      (ae_of_all _ fun p => by simpa [D, Function.uncurry] using shiftBound U n h p.1 p.2)
  have bound (t : I) : (∫ ω, D t ω ∂P) ≤ Real.sqrt (dens * |h|) := by
    have hdist : |(shiftPIT h t : ℝ) - t| ≤ dens * |h| := by simpa using shiftPIT_lipschitz h 0 t
    apply le_trans _ (Real.sqrt_le_sqrt hdist)
    by_cases ht : t ≤ shiftPIT h t
    · rw [abs_of_nonneg (sub_nonneg.mpr (show (t : ℝ) ≤ shiftPIT h t from ht))]
      exact iid_empirical_increment U hu hi _ _ _ ht
    · have ht' := le_of_not_ge ht
      rw [abs_sub_comm, abs_of_nonneg (sub_nonneg.mpr (show (shiftPIT h t : ℝ) ≤ t from ht'))]
      simpa only [D, abs_sub_comm (empiricalAt U _ t _)] using
        iid_empirical_increment U hu hi (n+1) _ _ ht'
  change (∫ ω, ∫ t : I, D t ω ∂volume ∂P) ≤ _
  rw [← integral_integral_swap hD]
  exact (integral_mono hD.integral_prod_left (integrable_const _) bound).trans_eq (by simp)


omit [MeasurableSpace Ω] in
theorem shiftIncrement_nonneg (U : ℕ → Ω → ℝ) (n : ℕ) (h : ℝ) (ω : Ω) :
    0 ≤ shiftIncrement U n h ω := integral_nonneg fun _ => abs_nonneg _

/-- The effect of a fixed root-sample-size offset tends to zero in probability. -/
theorem iid_fixed_shiftIncrement (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P) (q : ℝ) :
    TendstoInMeasure P (fun n => shiftIncrement U n (q / rankScale n)) atTop 0 := by
  apply tendstoInMeasure_iff_measureReal_norm.mpr
  intro ε hε
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs, abs_of_nonneg (shiftIncrement_nonneg ..)]
  apply squeeze_zero (fun _ => measureReal_nonneg)
  · intro n
    let h := q / rankScale n
    have hD : Integrable (fun p : I × Ω => |empiricalAt U (n+1) (shiftPIT h p.1) p.2 -
        empiricalAt U (n+1) p.1 p.2|) (volume.prod P) :=
      Integrable.of_bound (shiftJoint hm n h).aestronglyMeasurable _
        (ae_of_all _ fun p => by simpa using shiftBound U n h p.1 p.2)
    have b := (mul_meas_ge_le_integral_of_nonneg (ae_of_all P (shiftIncrement_nonneg U n h))
      (show Integrable (shiftIncrement U n h) P from hD.integral_prod_right) ε).trans
      (iid_shiftIncrement_mean U hm hu hi n h)
    exact (le_div_iff₀ hε).mpr ((mul_comm ..).le.trans b)
  · simpa using (((rankScale_atTop.const_div_atTop q).abs.const_mul dens).sqrt.div_const ε)

omit [MeasurableSpace Ω] in
private theorem uncentered_mono (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) :
    Monotone (fun t : I => empiricalAt U (n+1) t ω + rankScale n * (t : ℝ)) := by
  have hs := (rankScale_pos n).ne'
  have hs2 : rankScale n ^ 2 = n+1 := Real.sq_sqrt (by positivity)
  have eqn (t : I) : empiricalAt U (n+1) t ω + rankScale n * (t : ℝ) =
      (rankScale n)⁻¹ * ∑ i : Fin (n+1), if U i ω ≤ t then (1:ℝ) else 0 := by
    rw [empiricalAt_eq_count]
    push_cast
    change (rankScale n)⁻¹ * (_ - ((n:ℝ)+1) * t) + _ = _
    rw [← hs2]
    field_simp [hs]
    ring
  intro s t hst
  dsimp only
  rw [eqn, eqn]
  apply mul_le_mul_of_nonneg_left _ (inv_nonneg.mpr (rankScale_pos n).le)
  apply Finset.sum_le_sum
  intro i _
  split_ifs with h₁ h₂ h₂
  all_goals norm_num
  exact h₂ (h₁.trans hst)

/-- Offsets in a finite interval can be bracketed by its ends. The correction
term bounds the normal CDF drift across the interval on the root-N scale. -/
theorem shiftIncrement_bracket (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (n : ℕ) (a v b : ℝ) (ha : a ≤ v) (hb : v ≤ b) (ω : Ω) :
    shiftIncrement U n (v / rankScale n) ω ≤ shiftIncrement U n (a / rankScale n) ω +
      shiftIncrement U n (b / rankScale n) ω + dens * (b-a) := by
  let D q (t : I) := |empiricalAt U (n+1) (shiftPIT (q/rankScale n) t) ω - empiricalAt U (n+1) t ω|
  have hd q : Integrable (D q) := shiftIncrement_integrand_integrable hm n _ ω
  have bound (t : I) : D v t ≤ D a t + D b t + dens * (b-a) := by
    let g q := shiftPIT (q/rankScale n) t
    have gm : Monotone g := fun _ _ hp =>
      shiftPIT_mono t (div_le_div_of_nonneg_right hp (rankScale_pos n).le)
    let E (s : I) := empiricalAt U (n+1) s ω
    have ml := uncentered_mono U n ω (gm ha)
    have mr := uncentered_mono U n ω (gm hb)
    change E (g a) + rankScale n * (g a : ℝ) ≤ E (g v) + rankScale n * (g v : ℝ) at ml
    change E (g v) + rankScale n * (g v : ℝ) ≤ E (g b) + rankScale n * (g b : ℝ) at mr
    have sep : rankScale n * ((g b : ℝ) - g a) ≤ dens * (b-a) := by
      have lip := shiftPIT_lipschitz (b/rankScale n) (a/rankScale n) t
      rw [← sub_div, abs_of_nonneg (div_nonneg (sub_nonneg.mpr (ha.trans hb)) (rankScale_pos n).le),
        ← mul_div_assoc] at lip
      have one := (le_abs_self ((g b : ℝ) - g a)).trans lip
      linarith [(le_div_iff₀ (rankScale_pos n)).mp one]
    have left := mul_le_mul_of_nonneg_left (show (g a : ℝ) ≤ g v from gm ha) (rankScale_pos n).le
    have right := mul_le_mul_of_nonneg_left (show (g v : ℝ) ≤ g b from gm hb) (rankScale_pos n).le
    change |E (g v) - E t| ≤ |E (g a) - E t| + |E (g b) - E t| + _
    apply abs_le.mpr
    constructor
    · linarith [neg_abs_le (E (g a) - E t), abs_nonneg (E (g b) - E t)]
    · linarith [le_abs_self (E (g b) - E t), abs_nonneg (E (g a) - E t)]
  have i := integral_mono (hd v) (((hd a).add (hd b)).add (integrable_const (dens*(b-a)))) bound
  change (∫ t, D v t) ≤ ∫ t, (D a t + D b t) + dens*(b-a) at i
  have hint : Integrable (fun t => D a t + D b t) := (hd a).add (hd b)
  rw [integral_add hint (integrable_const (dens*(b-a))), integral_add (hd a) (hd b)] at i
  simpa only [D, shiftIncrement, integral_const, probReal_univ, one_smul] using i


/-- Uniform Taylor error for a threshold in the interior of the PIT interval. -/
theorem shiftPIT_remainder (h : ℝ) (t : I) (ht : (t : ℝ) ∈ Ioo 0 1) :
    |(shiftPIT h t : ℝ) - t - h * dens * normalProfile t| ≤ dens * h^2 := by
  rcases t with ⟨t, ht'⟩
  obtain ⟨z, rfl⟩ := normalCDF_range ht
  simp only [shiftPIT_cdf, normalProfile_cdf]
  rw [mul_assoc h, mul_div_cancel₀ _ (gaussianPDFReal_pos 0 1 0 (by norm_num)).ne']
  simpa [sub_eq_add_neg] using normal_shift_remainder z (-h)

/-- Normal-scale recentering corresponds exactly to moving the PIT threshold. -/
theorem cdf_sub_le_iff_shift (h z : ℝ) (t : I) :
    Φ (z - h) ≤ (t:ℝ) ↔ Φ z ≤ shiftPIT h t := by
  rcases t with ⟨t, ht⟩
  by_cases hmem : t ∈ range Φ
  · obtain ⟨u, rfl⟩ := hmem
    rw [shiftPIT_cdf, normalCDF_strictMono.le_iff_le, normalCDF_strictMono.le_iff_le]
    constructor <;> intro hh <;> linarith
  · have outside : t ∉ Ioo (0 : ℝ) 1 := fun e => hmem (normalCDF_range e)
    have ends : t = 0 ∨ t = 1 := by
      by_cases hzero : t = 0
      · exact Or.inl hzero
      · exact Or.inr (le_antisymm ht.2 (le_of_not_gt fun e =>
          outside ⟨lt_of_le_of_ne ht.1 (Ne.symm hzero), e⟩))
    have pos (x : ℝ) : 0 < Φ x :=
      (cdf_nonneg _ (x-1)).trans_lt (normalCDF_strictMono (show x-1 < x by linarith))
    rcases ends with rfl | rfl
    · simp [shiftPIT, hmem, not_le.mpr (pos _)]
    · simp [shiftPIT, hmem, cdf_le_one]

/-- A random fitted location with tight root-sample-size scaling produces
a vanishing integrated centred empirical-process increment. -/
theorem iid_fitted_empirical_increment (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P) (m : ℕ → Ω → ℝ)
    (htight : ∀ η > (0 : ℝ), ∃ K > (0 : ℝ), ∀ᶠ n in atTop,
      P.real {ω | K ≤ |rankScale n * m n ω|} < η) :
    TendstoInMeasure P (fun n ω => shiftIncrement U n (m n ω) ω) atTop 0 := by
  classical
  apply tendstoInMeasure_iff_measureReal_norm.mpr
  intro ε hε
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs, abs_of_nonneg (shiftIncrement_nonneg ..)]
  apply tendsto_order.mpr
  constructor
  · intro b hb
    exact .of_forall fun _ => hb.trans_le measureReal_nonneg
  intro η hη
  obtain ⟨K, _, hK⟩ := htight (η / 2) (by linarith)
  have hden := gaussianPDFReal_nonneg 0 1 0
  let δ := ε / (8 * (1+dens))
  have hd : 0 < δ := div_pos hε (by positivity)
  have drift : dens * (2*δ) ≤ ε/4 := by
    have eq : δ * (8 * (1+dens)) = ε := div_mul_cancel₀ _ (by positivity)
    nlinarith
  obtain ⟨grid, hcover⟩ := (isCompact_Icc (α := ℝ) (a := -K) (b := K)).elim_finite_subcover
    (fun q : ℝ => Ioo (q - δ) (q + δ)) (fun _ => isOpen_Ioo) (by
      intro y _
      exact mem_iUnion.mpr ⟨y, by constructor <;> linarith⟩)
  let bad (q : ℝ) (n : ℕ) := {ω | ε/4 ≤ shiftIncrement U n (q/rankScale n) ω}
  have hb q : Tendsto (fun n => P.real (bad q n)) atTop (𝓝 0) := by
    simpa [bad, abs_of_nonneg (shiftIncrement_nonneg ..)] using
      tendstoInMeasure_iff_measureReal_norm.mp (iid_fixed_shiftIncrement U hm hu hi q) (ε/4)
        (by positivity)
  let ends (q : ℝ) (n : ℕ) := bad (q-δ) n ∪ bad (q+δ) n
  have he q : Tendsto (fun n => P.real (ends q n)) atTop (𝓝 0) := by
    apply squeeze_zero (fun _ => measureReal_nonneg) (fun _ => measureReal_union_le _ _)
    simpa using (hb (q-δ)).add (hb (q+δ))
  have hall : Tendsto (fun n => ∑ q ∈ grid, P.real (ends q n)) atTop (𝓝 0) := by
    simpa using tendsto_finsetSum grid (fun q _ => he q)
  filter_upwards [hK, hall.eventually_lt_const (show 0 < η/2 by linarith)] with n hn hg
  have sub : {ω | ε ≤ shiftIncrement U n (m n ω) ω} ⊆
      {ω | K ≤ |rankScale n * m n ω|} ∪ ⋃ q ∈ grid, ends q n := by
    intro ω hω
    by_contra H
    let v := rankScale n * m n ω
    have hv : |v| < K := lt_of_not_ge fun e => H (Or.inl e)
    obtain ⟨q, hq, hl, hr⟩ := mem_iUnion₂.mp (hcover (abs_lt.mp hv |>.imp le_of_lt le_of_lt))
    have good : ω ∉ ends q n := fun e => H (Or.inr (mem_iUnion₂.mpr ⟨q, hq, e⟩))
    have rl : shiftIncrement U n ((q-δ)/rankScale n) ω < ε/4 :=
      lt_of_not_ge fun e => good (Or.inl e)
    have rr : shiftIncrement U n ((q+δ)/rankScale n) ω < ε/4 :=
      lt_of_not_ge fun e => good (Or.inr e)
    have h := shiftIncrement_bracket U hm n (q-δ) v (q+δ) hl.le hr.le ω
    rw [show v/rankScale n = m n ω from mul_div_cancel_left₀ _ (rankScale_pos _).ne',
      show q+δ-(q-δ) = 2*δ by ring] at h
    change ε ≤ shiftIncrement U n (m n ω) ω at hω
    linarith
  have hle := (measureReal_mono (μ := P) sub).trans (measureReal_union_le _ _)
  have hunion := measureReal_biUnion_finset_le (μ := P) grid (fun q => ends q n)
  linarith

end PITW
