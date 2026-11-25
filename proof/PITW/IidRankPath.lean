/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.IntegratedConvergence
public import PITW.IidQuantilePoint
public import PITW.QuantilePath
import Mathlib.MeasureTheory.Measure.SeparableMeasure

/-! The ordered midpoint discrepancies and the sample median share a bridge limit. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval ENNReal
namespace PITW

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

local instance : Fact ((1 : ℝ≥0∞) ≠ ∞) := ⟨by simp⟩

private lemma ae_interior : ∀ᵐ t : I, (t : ℝ) ∈ Ioo 0 1 := by
  filter_upwards [(volume : Measure I).ae_ne (0 : I), (volume : Measure I).ae_ne (1 : I)]
    with t h0 h1
  exact ⟨unitInterval.pos_iff_ne_zero.mpr h0, unitInterval.lt_one_iff_ne_one.mpr h1⟩

private lemma difference_tail {X Y : Ω → ℝ} {b : ℝ} (hb : 0 < b)
    (hX : P.real {ω | b / 2 ≤ |X ω|} ≤ 2 / (b / 2) ^ 2)
    (hY : P.real {ω | b / 2 ≤ |Y ω|} ≤ 1 / (4 * (b / 2) ^ 2)) :
    P.real {ω | b ≤ |X ω - Y ω|} ≤ 9 / b ^ 2 := by
  have sub : {ω | b ≤ |X ω - Y ω|} ⊆ {ω | b / 2 ≤ |X ω|} ∪ {ω | b / 2 ≤ |Y ω|} := by
    intro ω h
    by_contra hn
    have hx : |X ω| < b / 2 := lt_of_not_ge (fun hh => hn (Or.inl hh))
    have hy : |Y ω| < b / 2 := lt_of_not_ge (fun hh => hn (Or.inr hh))
    change b ≤ |X ω - Y ω| at h
    change |X ω| < b / 2 at hx
    change |Y ω| < b / 2 at hy
    linarith [abs_sub (X ω) (Y ω)]
  calc
    _ ≤ _ := (measureReal_mono sub (measure_ne_top _ _)).trans (measureReal_union_le _ _)
    _ ≤ _ := add_le_add hX hY
    _ = _ := by field_simp; ring

private lemma pair_error {E : Type*} [SeminormedAddCommGroup E]
    {X : ℕ → Ω → E} {Y : ℕ → Ω → ℝ}
    (hx : TendstoInMeasure P X atTop 0) (hy : TendstoInMeasure P Y atTop 0) :
    TendstoInMeasure P (fun n ω => (X n ω, Y n ω)) atTop 0 := by
  rw [tendstoInMeasure_iff_measureReal_norm] at hx hy ⊢
  simp only [Pi.zero_apply, sub_zero, Prod.norm_mk] at hx hy ⊢
  intro ε hε
  have h := (hx ε hε).add (hy ε hε)
  rw [add_zero] at h
  apply squeeze_zero (fun _ => measureReal_nonneg) _ h
  intro n
  have sub : {ω | ε ≤ max ‖X n ω‖ ‖Y n ω‖} ⊆ {ω | ε ≤ ‖X n ω‖} ∪ {ω | ε ≤ ‖Y n ω‖} := by
    intro ω hω
    change ε ≤ ‖X n ω‖ ∨ ε ≤ ‖Y n ω‖
    exact le_max_iff.mp (show ε ≤ max ‖X n ω‖ ‖Y n ω‖ from hω)
  exact (measureReal_mono sub (measure_ne_top _ _)).trans (measureReal_union_le _ _)

private def errorAt (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (t : I) : ℝ :=
  rankScale n * rankFunction (orderedPIT U (n + 1) ω) t - empiricalAt U (n + 1) t ω

private lemma integrated_rank_error (U : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (U j))
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P) :
    TendstoInMeasure P (fun n ω => ∫ t : I, |errorAt U n ω t|) atTop 0 := by
  apply integrated_tendstoInMeasure (errorAt U) 9 (rank_empirical_error_integrable U hm hu)
  · filter_upwards [ae_interior] with t ht
    choose i hcell using fun n => rank_cell_exists n (show (t : ℝ) ∈ Ioc 0 1 from ⟨ht.1, ht.2.le⟩)
    simpa only [errorAt, fun n ω => rankFunction_at (orderedPIT U (n + 1) ω)
      (i n) (hcell n).1 (hcell n).2] using iid_rank_point_error U hm hu hi t ht i hcell
  · filter_upwards [ae_interior] with t ht
    intro n b hb
    obtain ⟨i, hl, hr⟩ := rank_cell_exists n (show (t : ℝ) ∈ Ioc 0 1 from ⟨ht.1, ht.2.le⟩)
    simp only [errorAt, fun ω => rankFunction_at (orderedPIT U (n + 1) ω) i hl hr]
    have hpos : 0 < b := by linarith
    exact difference_tail hpos (iid_rank_discrepancy_tail U hu hi n i (half_pos hpos))
      (iid_empirical_tail U hu hi (Nat.succ_pos n) t (half_pos hpos))

/-- The scaled midpoint rank path and the empirical CDF path differ by a
vanishing L¹ error under iid uniform sampling. -/
theorem iid_rank_path_error (U : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (U j))
    (hu : ∀ j, HasLaw (U j) uniformPIT P) (hi : iIndepFun U P) :
    TendstoInMeasure P (fun n ω => unitRankPath (orderedPIT U (n + 1) ω) -
      empiricalPath U (n + 1) ω) atTop 0 := by
  have h := integrated_rank_error U hm hu hi
  rw [tendstoInMeasure_iff_measureReal_norm] at h ⊢
  simp only [Pi.zero_apply, sub_zero, Real.norm_eq_abs,
    abs_of_nonneg (integral_nonneg fun _ => abs_nonneg _)] at h
  simp only [Pi.zero_apply, sub_zero]
  have eqn n ω : ‖unitRankPath (orderedPIT U (n + 1) ω) - empiricalPath U (n + 1) ω‖ =
      ∫ t, |errorAt U n ω t| := by
    apply unitL1_norm
    filter_upwards [Lp.coeFn_sub (unitRankPath (orderedPIT U (n + 1) ω))
      (empiricalPath U (n + 1) ω),
      unitRankPath_ae (orderedPIT U (n + 1) ω), empiricalPath_ae U (n + 1) ω] with t hsub hr he
    simpa only [Pi.sub_apply, hr, he, errorAt] using hsub
  simpa only [eqn] using h

/-- Joint convergence of the ordered PIT discrepancy path and the fitted
normal-scale median. Both limits use the same Brownian bridge. -/
theorem iid_rank_path_median_limit (Z : ℕ → Ω → ℝ) (hm : ∀ j, Measurable (Z j))
    (hz : ∀ j, HasLaw (Z j) (gaussianReal 0 1) P) (hi : iIndepFun Z P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution (fun n ω =>
      (unitRankPath (orderedPIT (fun j => Φ ∘ Z j) (n + 1) ω),
       rankScale n * normalMedian n (orderedPIT Z (n + 1) ω))) atTop
      (fun ξ => (ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ),
        -brownianBridge W ξ unitHalf / gaussianPDFReal 0 1 0)) (fun _ => P) Q := by
  let U := fun j => Φ ∘ Z j
  have hU j : Measurable (U j) := normalCDF_strictMono.monotone.measurable.comp (hm j)
  have hu j := stdNormal_pit_law (hz j)
  have hind : iIndepFun U P := hi.comp _ (fun _ => normalCDF_strictMono.monotone.measurable)
  let rescale (x : UnitL1 × ℝ) := (x.1, -x.2 / gaussianPDFReal 0 1 0)
  have hcont : Continuous rescale := continuous_fst.prodMk (continuous_snd.neg.div_const _)
  have h := (iid_empirical_path_eval_limit U hU hu hind W hW unitHalf).continuous_comp hcont
  have hlim : TendstoInDistribution (fun n ω =>
      (empiricalPath U (n + 1) ω, medianInfluence U n ω)) atTop
        (fun ξ => (ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ),
          -brownianBridge W ξ unitHalf / gaussianPDFReal 0 1 0)) (fun _ => P) Q :=
    ⟨fun n => h.forall_aemeasurable (n + 1), h.aemeasurable_limit,
      h.tendsto.comp (tendsto_add_atTop_nat 1)⟩
  refine tendstoInDistribution_of_tendstoInMeasure_sub
    (fun n ω => (unitRankPath (orderedPIT U (n + 1) ω),
      rankScale n * normalMedian n (orderedPIT Z (n + 1) ω))) _ hlim ?_ ?_
  · change TendstoInMeasure P (fun n ω =>
      (unitRankPath (orderedPIT U (n + 1) ω) - empiricalPath U (n + 1) ω,
        rankScale n * normalMedian n (orderedPIT Z (n + 1) ω) - medianInfluence U n ω)) atTop 0
    exact pair_error (iid_rank_path_error U hU hu hind) (iid_normalMedian_expansion Z hm hu hind)
  · intro n
    have hr := (unitRankPath_measurable n).comp
      (Measurable.of_eval fun i => measurable_orderedPIT hU (n + 1) i)
    have hm' : Measurable (fun ω => rankScale n * normalMedian n (orderedPIT Z (n + 1) ω)) :=
      ((measurable_orderedPIT hm _ _).add (measurable_orderedPIT hm _ _)
        |>.div_const 2).const_mul _
    exact (hr.prodMk hm').aemeasurable

end PITW
