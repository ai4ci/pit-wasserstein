/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.BrownianBridge

/-! Finite-dimensional convergence of the empirical CDF from independent uniform
PITs. Linear projections of the threshold counts obey the ordinary iid CLT. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Filter
open scoped Topology unitInterval RealInnerProductSpace
namespace PITW

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

/-- Uniform probability on the unit interval, regarded as a measure on ℝ. -/
abbrev uniformPIT := (volume : Measure ℝ).restrict (Icc 0 1)

private def hit (t : I) : ℝ → ℝ := (Iic (t : ℝ)).indicator (fun _ => 1)

private lemma hit_meas (t : I) : Measurable (hit t) :=
  measurable_const.indicator measurableSet_Iic

private lemma hit_L2 {U : Ω → ℝ} (hu : AEMeasurable U P) (t : I) : MemLp (hit t ∘ U) 2 P := by
  apply MemLp.of_bound ((hit_meas t).comp_aemeasurable hu).aestronglyMeasurable 1
  filter_upwards with ω
  by_cases ht : U ω ≤ t <;> simp [hit, ht]

omit [IsProbabilityMeasure P] in
private lemma hit_mean {U : Ω → ℝ} (hu : HasLaw U uniformPIT P) (t : I) :
    (∫ ω, hit t (U ω) ∂P) = t := by
  rw [show (∫ ω, hit t (U ω) ∂P) = _ from hu.integral_comp (hit_meas t).aestronglyMeasurable]
  have he : Iic (t : ℝ) ∩ Icc 0 1 = Icc (0 : ℝ) (t : ℝ) := by
    ext x; simp only [mem_inter_iff, mem_Iic, mem_Icc]
    exact ⟨fun h => ⟨h.2.1, h.1⟩, fun h => ⟨h.2, h.1, h.2.trans t.property.2⟩⟩
  simp [integral_indicator_const _ measurableSet_Iic, Measure.real_def,
    Measure.restrict_apply measurableSet_Iic, he, t.property.1]

private lemma hit_cov {U : Ω → ℝ} (hu : HasLaw U uniformPIT P) (s t : I) :
    cov[hit s ∘ U, hit t ∘ U; P] = bridgeKernel s t := by
  rw [covariance_eq_sub (hit_L2 hu.aemeasurable _) (hit_L2 hu.aemeasurable _)]
  have hm : ((hit s ∘ U) * (hit t ∘ U)) = hit (min s t) ∘ U := by
    funext ω
    by_cases h : U ω ≤ s <;> by_cases h' : U ω ≤ t <;>
      simp [hit, Function.comp_def, h, h', le_min_iff]
  rw [hm]
  simp only [Function.comp_def, hit_mean hu, bridgeKernel]
  rfl

variable {k : ℕ} (t : Fin k → I)

private def observe (a : Fin k → ℝ) (u : ℝ) := ∑ i, a i * hit (t i) u

private lemma observe_meas (a : Fin k → ℝ) : Measurable (observe t a) :=
  Finset.measurable_fun_sum _ fun _ _ => measurable_const.mul (hit_meas _)

private def projectGrid (a : Fin k → ℝ) : C(I, ℝ) →L[ℝ] ℝ :=
  ∑ i, a i • ContinuousMap.evalCLM ℝ (t i)

private lemma variance_projection {U : Ω → ℝ} (hu : HasLaw U uniformPIT P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) (a : Fin k → ℝ) :
    Var[observe t a ∘ U; P] = Var[projectGrid t a ∘ brownianBridge W; Q] := by
  let A i := hit (t i) ∘ U
  let B i := fun ξ => brownianBridge W ξ (t i)
  have hA i : MemLp (A i) 2 P := hit_L2 hu.aemeasurable _
  have hB i : MemLp (B i) 2 Q :=
    ((brownianBridge_gaussian hW).map (ContinuousMap.evalCLM ℝ (t i))).memLp_two
  have hcov (i j : Fin k) : cov[B i, B j; Q] = bridgeKernel (t i) (t j) := by
    let eqn i := (brownianBridge_ae hW).mono fun ξ h => h (t i)
    have mean i : (∫ ξ, B i ξ ∂Q) = 0 :=
      (integral_congr_ae (eqn i)).trans (pinned_mean hW.toIsPreBrownianReal _ (t i).property)
    rw [covariance_eq_sub (hB i) (hB j), mean, mean, mul_zero, sub_zero]
    exact (integral_congr_ae ((brownianBridge_ae hW).mono
      fun ξ e => congrArg₂ (· * ·) (e (t i)) (e (t j)))).trans
      (pinned_secondMoment hW.toIsPreBrownianReal _ _ (t i).property (t j).property)
  rw [← covariance_self ((observe_meas t a).comp_aemeasurable hu.aemeasurable),
    ← covariance_self (((brownianBridge_gaussian hW).map (projectGrid t a)).aemeasurable)]
  have eA : observe t a ∘ U = fun ω => ∑ i, (a i • A i) ω := rfl
  have eB : projectGrid t a ∘ brownianBridge W = fun ω => ∑ i, (a i • B i) ω := by
    funext ω; simp [projectGrid, B, sum_apply]
  rw [eA, eB, covariance_fun_sum_fun_sum (fun i => (hA i).const_smul (a i))
    (fun i => (hA i).const_smul (a i)), covariance_fun_sum_fun_sum
      (fun i => (hB i).const_smul (a i)) (fun i => (hB i).const_smul (a i))]
  simp only [covariance_smul_left, covariance_smul_right, hcov, A, hit_cov hu]

private lemma scalar_limit (U : ℕ → Ω → ℝ) (hu : ∀ i, HasLaw (U i) uniformPIT P)
    (hi : iIndepFun U P) (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) (a : Fin k → ℝ) :
    TendstoInDistribution (fun (n : ℕ) ω => (Real.sqrt n)⁻¹ *
      (∑ j ∈ Finset.range n, observe t a (U j ω) - n * ∑ i, a i * (t i : ℝ))) atTop
      (projectGrid t a ∘ brownianBridge W) (fun _ => P) Q := by
  let X := fun n => observe t a ∘ U n
  have hX : MemLp (X 0) 2 P := memLp_finsetSum Finset.univ fun i _ =>
    (hit_L2 (hu 0).aemeasurable (t i)).const_smul (a i)
  have hG := (brownianBridge_gaussian hW).map (projectGrid t a)
  have mean : (∫ ξ, projectGrid t a (brownianBridge W ξ) ∂Q) = 0 := by
    simp only [projectGrid, sum_apply, smul_apply,
      ContinuousMap.evalCLM_apply, smul_eq_mul]
    rw [integral_finsetSum]
    · apply Finset.sum_eq_zero
      intro i _
      rw [integral_const_mul, integral_congr_ae ((brownianBridge_ae hW).mono fun _ h => h (t i)),
        pinned_mean hW.toIsPreBrownianReal _ (t i).property, mul_zero]
    · intro i _
      exact ((brownianBridge_gaussian hW).map
        (ContinuousMap.evalCLM ℝ (t i))).integrable.const_mul _
  have hY : HasLaw (projectGrid t a ∘ brownianBridge W) (gaussianReal 0 Var[X 0; P].toNNReal) Q :=
    ⟨hG.aemeasurable, by
      rw [hG.map_eq_gaussianReal, variance_projection t (hu 0) W hW a]; simp [mean]⟩
  have hh := tendstoInDistribution_inv_sqrt_mul_sum_sub hY hX
    (hi.comp _ (fun _ => observe_meas t a))
    (fun i => ((hu i).identDistrib (hu 0)).comp (observe_meas t a))
  have e : (∫ ω, X 0 ω ∂P) = ∑ i, a i * (t i : ℝ) := by
    unfold X observe; simp only [Function.comp_apply]
    rw [integral_finsetSum]
    · simp only [integral_const_mul, hit_mean (hu 0)]
    · intro i _
      exact ((hit_L2 (hu 0).aemeasurable (t i)).integrable (by norm_num)).const_mul (a i)
  simp only [X, Function.comp_apply] at hh e
  simpa only [e] using hh

/-- The scaled empirical CDF at an arbitrary fixed finite grid. -/
def empiricalGrid (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : EuclideanSpace ℝ (Fin k) :=
  WithLp.toLp 2 fun i => (Real.sqrt n)⁻¹ *
    ((∑ j ∈ Finset.range n, hit (t i) (U j ω)) - n * (t i : ℝ))

private def bridgeGrid (W : NNReal → Ξ → ℝ) (ξ : Ξ) : EuclideanSpace ℝ (Fin k) :=
  WithLp.toLp 2 fun i => brownianBridge W ξ (t i)

/-- All threshold counts converge jointly to the corresponding evaluations of
one Brownian bridge, directly from independence and the uniform marginal law. -/
theorem iid_empirical_grid_limit (U : ℕ → Ω → ℝ) (hu : ∀ i, HasLaw (U i) uniformPIT P)
    (hi : iIndepFun U P) (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    TendstoInDistribution (empiricalGrid t U) atTop
      (fun ξ => WithLp.toLp 2 fun i => brownianBridge W ξ (t i)) (fun _ => P) Q := by
  change TendstoInDistribution _ _ (bridgeGrid t W) _ _
  have hem (n : ℕ) : AEMeasurable (empiricalGrid t U n) P := by
    apply (WithLp.measurable_toLp ..).comp_aemeasurable
    apply AEMeasurable.of_eval
    intro i
    exact (Finset.aemeasurable_fun_sum _ (fun j _ =>
      (hit_meas (t i)).comp_aemeasurable (hu j).aemeasurable)).sub_const _ |>.const_mul _
  have hbm : AEMeasurable (bridgeGrid t W) Q := by
    apply (WithLp.measurable_toLp ..).comp_aemeasurable
    exact AEMeasurable.of_eval fun i =>
      ((brownianBridge_gaussian hW).map (ContinuousMap.evalCLM ℝ (t i))).aemeasurable
  apply TendstoInDistribution.of_tendsto_charFun hem hbm
  intro a
  simp_rw [charFun_map_eq_charFun_map_inner_one (hem _) a,
    charFun_map_eq_charFun_map_inner_one hbm a]
  have h := (scalar_limit t U hu hi W hW (fun i => a i)).tendsto_charFun 1
  convert h using 2
  · rename_i n
    congr 2
    funext ω
    simp only [PiLp.inner_apply, Real.inner_apply, empiricalGrid, observe]
    rw [Finset.sum_comm (s := Finset.range n)]
    simp only [Finset.mul_sum, mul_sub, sub_mul, Finset.sum_mul, Finset.sum_sub_distrib]
    congr 1 <;> apply Finset.sum_congr rfl <;> intro i _
    · apply Finset.sum_congr rfl; intro j _; ring
    · ring
  · congr 3
    funext ξ
    simp [bridgeGrid, projectGrid, PiLp.inner_apply, sum_apply]

/-- Scaled empirical CDF at one threshold. -/
def empiricalAt (U : ℕ → Ω → ℝ) (n : ℕ) (t : I) (ω : Ω) : ℝ :=
  (Real.sqrt n)⁻¹ * ((∑ j ∈ Finset.range n, hit t (U j ω)) - n * (t : ℝ))

omit [MeasurableSpace Ω] in
theorem empiricalAt_eq_count (U : ℕ → Ω → ℝ) (n : ℕ) (t : I) (ω : Ω) :
    empiricalAt U n t ω = (Real.sqrt n)⁻¹ *
      ((∑ i : Fin n, if U i ω ≤ t then (1 : ℝ) else 0) - n * (t : ℝ)) := by
  rw [Fin.sum_univ_eq_sum_range (fun j => if U j ω ≤ t then (1 : ℝ) else 0)]
  simp [empiricalAt, hit, Set.indicator_apply]

omit [MeasurableSpace Ω] in
theorem empiricalGrid_apply (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) (i : Fin k) :
    empiricalGrid t U n ω i = empiricalAt U n (t i) ω := by simp [empiricalGrid, empiricalAt]

/-- The expected absolute fluctuation between two thresholds is bounded uniformly
in sample size. This gives an L¹ error bound when replacing the process by a grid. -/
theorem iid_empirical_increment (U : ℕ → Ω → ℝ) (hu : ∀ i, HasLaw (U i) uniformPIT P)
    (hi : iIndepFun U P) (n : ℕ) (s t : I) (hst : s ≤ t) :
    (∫ ω, |empiricalAt U n t ω - empiricalAt U n s ω| ∂P) ≤ Real.sqrt ((t : ℝ) - s) := by
  let D i := (hit t ∘ U i) - (hit s ∘ U i)
  let p : ℝ := t - (s : ℝ)
  have hp : 0 ≤ p := sub_nonneg.mpr hst
  have hm i : MemLp (D i) 2 P := (hit_L2 (hu i).aemeasurable t).sub (hit_L2 (hu i).aemeasurable s)
  have mean i : (∫ ω, D i ω ∂P) = p := by
    rw [show (∫ ω, D i ω ∂P) = _ from integral_sub
      ((hit_L2 (hu i).aemeasurable t).integrable (by norm_num))
      ((hit_L2 (hu i).aemeasurable s).integrable (by norm_num))]
    simp only [Function.comp_def, hit_mean (hu i), p]
  have var i : Var[D i; P] = p - p ^ 2 := by
    rw [← covariance_self (hm i).aemeasurable]
    dsimp only [D]
    rw [covariance_sub_sub (hit_L2 (hu i).aemeasurable _) (hit_L2 (hu i).aemeasurable _)
      (hit_L2 (hu i).aemeasurable _) (hit_L2 (hu i).aemeasurable _)]
    simp only [hit_cov (hu i), bridgeKernel, min_self, min_eq_left (show (s:ℝ) ≤ t from hst),
      min_eq_right (show (s:ℝ) ≤ t from hst), p]; ring
  have hind : iIndepFun D P :=
    hi.comp (fun _ => hit t - hit s) (fun _ => (hit_meas t).sub (hit_meas s))
  let S := ∑ j ∈ Finset.range n, D j
  have sm : MemLp S 2 P := by
    simpa [S, ← Finset.sum_apply] using memLp_finsetSum (Finset.range n) (fun i _ => hm i)
  have sv : Var[S; P] = n * (p - p ^ 2) := by
    rw [IndepFun.variance_sum (fun i _ => hm i) (fun i _ j _ h => hind.indepFun h)]
    simp [var]; ring
  have se : (∫ ω, S ω ∂P) = n * p := by
    simp only [S, Finset.sum_apply,
      integral_finsetSum _ (fun i _ => (hm i).integrable (by norm_num)),
      mean, Finset.sum_const, Finset.card_range, nsmul_eq_mul]
  let X := fun ω => (Real.sqrt n)⁻¹ * (S ω - n * p)
  have xm : MemLp X 2 P := (sm.sub (memLp_const ((n : ℝ) * p))).const_smul (Real.sqrt n)⁻¹
  have xe : (∫ ω, X ω ∂P) = 0 := by
    simp [X, integral_const_mul, integral_sub (sm.integrable (by norm_num))
      (integrable_const _), se]
  have xv : Var[X; P] ≤ p := by
    rw [variance_const_mul, variance_sub_const sm.aestronglyMeasurable, sv]
    rcases n.eq_zero_or_pos with rfl | hn
    · simpa using hp
    · have hsqrt := Real.sq_sqrt (Nat.cast_nonneg n)
      rw [inv_pow, hsqrt]
      field_simp
      nlinarith [mul_nonneg (Nat.cast_nonneg n : (0:ℝ) ≤ n) (sq_nonneg p)]
  have abs2 := variance_nonneg (fun ω => ‖X ω‖) P
  rw [variance_eq_sub xm.norm] at abs2
  rw [variance_eq_sub xm, xe] at xv
  simp only [Pi.pow_apply, sq_abs, Real.norm_eq_abs, zero_pow (by decide : 2 ≠ 0),
    sub_zero] at xv abs2
  have bound : (∫ ω, |X ω| ∂P) ≤ Real.sqrt p := by
    nlinarith [Real.sq_sqrt hp, Real.sqrt_nonneg p]
  apply le_trans (le_of_eq (integral_congr_ae (ae_of_all P fun ω => ?_))) bound
  congr 1
  simp only [X, S, Finset.sum_apply, D, Pi.sub_apply, Function.comp_apply, Finset.sum_sub_distrib,
    p, empiricalAt]
  ring

/-- Joint measurability in threshold and sample, allowing Fubini for random PITs. -/
theorem empiricalAt_measurable {U : ℕ → Ω → ℝ} (h : ∀ i, Measurable (U i)) (n : ℕ) :
    Measurable (fun p : I × Ω => empiricalAt U n p.1 p.2) := by
  have hhit j : Measurable (fun p : I × Ω => hit p.1 (U j p.2)) := by
    have hs : MeasurableSet {p : I × Ω | U j p.2 ≤ (p.1 : ℝ)} :=
      measurableSet_le ((h j).comp measurable_snd)
      (measurable_subtypeVal.comp measurable_fst)
    convert (measurable_const (a := (1 : ℝ))).indicator hs using 1
    ext p
    by_cases ht : U j p.2 ≤ (p.1 : ℝ) <;> simp [hit, ht]
  unfold empiricalAt
  exact ((Finset.measurable_fun_sum _ fun j _ => hhit j).sub
    (measurable_subtypeVal.comp measurable_fst |>.const_mul _)).const_mul _

omit [MeasurableSpace Ω] in
theorem empiricalAt_bound (U : ℕ → Ω → ℝ) (n : ℕ) (t : I) (ω : Ω) :
    |empiricalAt U n t ω| ≤ (Real.sqrt n)⁻¹ * (n + n : ℝ) := by
  unfold empiricalAt
  rw [abs_mul, abs_of_nonneg (inv_nonneg.mpr (Real.sqrt_nonneg _))]
  apply mul_le_mul_of_nonneg_left _ (inv_nonneg.mpr (Real.sqrt_nonneg _))
  apply (abs_sub ..).trans
  apply add_le_add
  · apply (Finset.abs_sum_le_sum_abs ..).trans
    calc
      _ ≤ ∑ _j ∈ Finset.range n, (1 : ℝ) := by
        apply Finset.sum_le_sum
        intro j _; by_cases ht : U j ω ≤ t <;> simp [hit, ht]
      _ = _ := by simp
  · rw [abs_of_nonneg (mul_nonneg (Nat.cast_nonneg _) t.property.1)]
    exact mul_le_of_le_one_right (Nat.cast_nonneg _) t.property.2


/-- Chebyshev bound for a centred threshold count at square-root sample-size scale. -/
theorem iid_empirical_tail (U : ℕ → Ω → ℝ) (hu : ∀ i, HasLaw (U i) uniformPIT P)
    (hi : iIndepFun U P) {n : ℕ} (hn : 0 < n) (t : I) {b : ℝ} (hb : 0 < b) :
    P.real {ω | b ≤ |empiricalAt U n t ω|} ≤ 1 / (4 * b ^ 2) := by
  let X i := hit t ∘ U i
  let S := ∑ j ∈ Finset.range n, X j
  have hm i : MemLp (X i) 2 P := hit_L2 (hu i).aemeasurable t
  have hs : MemLp S 2 P := by
    simpa [S, ← Finset.sum_apply] using memLp_finsetSum (Finset.range n) (fun i _ => hm i)
  have mean : P[S] = n * (t : ℝ) := by
    simp only [S, Finset.sum_apply]
    rw [integral_finsetSum _ (fun j _ => (hm j).integrable (by norm_num))]
    simp [X, Function.comp_def, hit_mean (hu _)]
  have hind : iIndepFun X P := hi.comp _ (fun _ => hit_meas t)
  have var : Var[S; P] = n * ((t : ℝ) - t * (t : ℝ)) := by
    rw [IndepFun.variance_sum (fun i _ => hm i) (fun i _ j _ h => hind.indepFun h)]
    simp only [← covariance_self (hm _).aemeasurable, X, hit_cov (hu _), bridgeKernel,
      min_self, Finset.sum_const, Finset.card_range, nsmul_eq_mul]
  have hpos : (0 : ℝ) < n := by exact_mod_cast hn
  have hp := Real.sqrt_pos.mpr hpos
  have cpos := mul_pos hp hb
  have bound := ENNReal.toReal_mono ENNReal.ofReal_ne_top (meas_ge_le_variance_div_sq hs cpos)
  rw [ENNReal.toReal_ofReal (div_nonneg (variance_nonneg _ _) (sq_nonneg _)), mean, var] at bound
  have event : {ω | b ≤ |empiricalAt U n t ω|} =
      {ω | Real.sqrt n * b ≤ |S ω - n * (t : ℝ)|} := by
    ext ω
    simp only [mem_ofPred_eq, empiricalAt, abs_mul, abs_of_pos (inv_pos.mpr hp), S,
      Finset.sum_apply, X, Function.comp_apply]
    rw [← div_eq_inv_mul, le_div_iff₀ hp, mul_comm b]
  rw [event]
  apply bound.trans
  rw [mul_pow, Real.sq_sqrt hpos.le]
  apply (div_le_div_iff₀ (mul_pos hpos (sq_pos_of_pos hb)) (by positivity)).mpr
  nlinarith [mul_nonneg (mul_nonneg hpos.le (sq_nonneg b)) (sq_nonneg (2 * (t : ℝ) - 1))]

end PITW
