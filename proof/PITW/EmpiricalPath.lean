/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.EmpiricalGrid
public import Mathlib.MeasureTheory.Function.LpSpace.ContinuousFunctions
import Mathlib.MeasureTheory.Function.Floor

/-! Joint iid convergence of the empirical CDF in L¹ and at a fixed threshold. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Set Filter
open scoped Topology unitInterval
namespace PITW

private def node (m : ℕ) (i : Fin (m + 2)) : I :=
  ⟨(i : ℝ) / (m + 1), by
    constructor
    · positivity
    · apply (div_le_one (by positivity)).mpr
      exact_mod_cast (show i.val ≤ m + 1 by omega)⟩

private def index (m : ℕ) (t : I) : Fin (m + 2) :=
  ⟨⌊(m + 1 : ℝ) * (t : ℝ)⌋₊, by
    have hb : (m + 1 : ℝ) * t ≤ m + 1 :=
      mul_le_of_le_one_right (by positivity) t.property.2
    have := Nat.floor_le (show 0 ≤ (m + 1 : ℝ) * t from mul_nonneg (by positivity) t.property.1)
    have h : (⌊(m + 1 : ℝ) * (t : ℝ)⌋₊ : ℝ) ≤ m + 1 := this.trans hb
    have : ⌊(m + 1 : ℝ) * (t : ℝ)⌋₊ ≤ m + 1 := by exact_mod_cast h
    omega⟩

private lemma index_meas (m : ℕ) : Measurable (index m) := by
  apply measurable_to_countable'
  intro i
  have e : index m ⁻¹' {i} = (fun t : I => ⌊(m + 1 : ℝ) * (t : ℝ)⌋₊) ⁻¹' {i.val} := by
    ext t; simp [index, Fin.ext_iff]
  rw [e]
  exact (Nat.measurable_floor.comp (measurable_subtypeVal.const_mul _)) (measurableSet_singleton _)

private lemma node_bounds (m : ℕ) (t : I) :
    node m (index m t) ≤ t ∧ (t : ℝ) - node m (index m t) ≤ 1 / (m + 1 : ℝ) := by
  change (⌊(m + 1 : ℝ) * (t : ℝ)⌋₊ : ℝ) / (m + 1) ≤ t ∧ _
  have hp : 0 < (m + 1 : ℝ) := by positivity
  constructor
  · apply (div_le_iff₀ hp).mpr
    simpa [mul_comm] using Nat.floor_le
      (show 0 ≤ (m + 1 : ℝ) * t from mul_nonneg (by positivity) t.property.1)
  · change _ - (⌊(m + 1 : ℝ) * (t : ℝ)⌋₊ : ℝ) / (m + 1) ≤ _
    rw [sub_le_iff_le_add, ← add_div, le_div_iff₀ hp]
    linarith [Nat.lt_floor_add_one ((m + 1 : ℝ) * (t : ℝ)),
      mul_comm (t : ℝ) (m + 1 : ℝ)]

/-- L¹ path space for discrepancies on the unit interval. -/
abbrev UnitL1 := Lp ℝ 1 (volume : Measure I)

scoped instance : MeasurableSpace UnitL1 := borel _
scoped instance : BorelSpace UnitL1 := ⟨rfl⟩

private lemma mesh_zero : Tendsto (fun m : ℕ => 1 / (m + 1 : ℝ)) atTop (𝓝 0) :=
  tendsto_one_div_add_atTop_nhds_zero_nat

private lemma node_limit (t : I) : Tendsto (fun m => node m (index m t)) atTop (𝓝 t) := by
  apply tendsto_iff_dist_tendsto_zero.mpr
  apply squeeze_zero (fun _ => dist_nonneg) _ mesh_zero
  intro m
  have hb := node_bounds m t
  change |((node m (index m t) : I) : ℝ) - (t : ℝ)| ≤ _
  rw [abs_sub_comm, abs_of_nonneg (sub_nonneg.mpr
    (show ((node m (index m t) : I) : ℝ) ≤ (t : ℝ) from hb.1))]
  exact hb.2

private theorem path_dist {X Y : UnitL1} {f g : I → ℝ}
    (hx : ⇑X =ᵐ[volume] f) (hy : ⇑Y =ᵐ[volume] g) :
    dist X Y = ∫ t, |f t - g t| := by
  rw [dist_eq_norm, L1.norm_eq_integral_norm]
  apply integral_congr_ae
  filter_upwards [Lp.coeFn_sub X Y, hx, hy] with t ht h₁ h₂
  simp only [ht, Pi.sub_apply, h₁, h₂, Real.norm_eq_abs]

/-- The L¹ norm is the area under the absolute value of any representative. -/
theorem unitL1_norm {X : UnitL1} {f : I → ℝ} (hx : ⇑X =ᵐ[volume] f) :
    ‖X‖ = ∫ t, |f t| := by
  rw [L1.norm_eq_integral_norm]
  exact integral_congr_ae (hx.mono fun _ h => by simpa using congrArg norm h)

private def gridTime (s : I) (m : ℕ) : Fin (m + 3) → I := Fin.lastCases s (node m)

private def stepRep (m : ℕ) (x : EuclideanSpace ℝ (Fin (m + 3))) (t : I) : ℝ :=
  x (index m t).castSucc

private lemma stepRep_meas (m : ℕ) (x : EuclideanSpace ℝ (Fin (m + 3))) :
    Measurable (stepRep m x) :=
  (measurable_of_finite (f := fun i : Fin (m + 2) => x i.castSucc)).comp (index_meas m)

private lemma stepRep_int (m : ℕ) (x : EuclideanSpace ℝ (Fin (m + 3))) :
    Integrable (stepRep m x) volume :=
  Integrable.of_bound (stepRep_meas m x).aestronglyMeasurable ‖x‖
    (ae_of_all _ fun _ => PiLp.norm_apply_le x _)

private def gridPair (m : ℕ) (x : EuclideanSpace ℝ (Fin (m + 3))) : UnitL1 × ℝ :=
  ((stepRep_int m x).toL1 _, x (Fin.last _))

private lemma gridPair_cont (m : ℕ) : Continuous (gridPair m) := by
  apply Continuous.prodMk _ (by fun_prop : Continuous (fun x : EuclideanSpace ℝ (Fin (m+3)) =>
    x (Fin.last _)))
  apply LipschitzWith.continuous (K := 1)
  apply LipschitzWith.of_dist_le_mul
  intro x y
  simp only [NNReal.coe_one, one_mul]
  rw [path_dist (stepRep_int m x).coeFn_toL1 (stepRep_int m y).coeFn_toL1]
  calc
    _ ≤ ∫ _t : I, dist x y := by
      apply integral_mono ((stepRep_int m x).sub (stepRep_int m y)).abs (integrable_const _)
      exact fun t => PiLp.dist_apply_le x y (index m t).castSucc
    _ = _ := by simp

private def sampleGrid (s : I) (m : ℕ) (f : I → ℝ) : EuclideanSpace ℝ (Fin (m + 3)) :=
  WithLp.toLp 2 (f ∘ gridTime s m)

private lemma grid_sample (s : I) (m : ℕ) (f : I → ℝ) :
    ⇑(gridPair m (sampleGrid s m f)).1 =ᵐ[volume] fun t => f (node m (index m t)) := by
  apply (stepRep_int m _).coeFn_toL1.trans
  exact ae_of_all _ fun _ => by simp [stepRep, sampleGrid, gridTime]

private lemma grid_sample_last (s : I) (m : ℕ) (f : I → ℝ) :
    (gridPair m (sampleGrid s m f)).2 = f s := by simp [gridPair, sampleGrid, gridTime]

private lemma grid_approx (s : I) (f : I → ℝ) (X : UnitL1) (hx : ⇑X =ᵐ[volume] f)
    (C : ℝ) (hm : Measurable f) (hb : ∀ t, |f t| ≤ C)
    (hc : ∀ᵐ t ∂volume, Tendsto (fun m => f (node m (index m t))) atTop (𝓝 (f t))) :
    Tendsto (fun m => gridPair m (sampleGrid s m f)) atTop (𝓝 (X, f s)) := by
  apply tendsto_iff_dist_tendsto_zero.mpr
  simp_rw [Prod.dist_eq, grid_sample_last, dist_self, max_eq_left dist_nonneg,
    path_dist (grid_sample s _ f) hx]
  have limit : Tendsto (fun m => ∫ t : I, |f (node m (index m t)) - f t|) atTop
      (𝓝 (∫ _t : I, (0 : ℝ))) := by
    apply tendsto_integral_of_dominated_convergence (fun _ => C + C)
    · intro m
      exact ((((measurable_of_finite (f := fun i => f (node m i))).comp (index_meas m)).sub
        hm).abs).aestronglyMeasurable
    · exact integrable_const _
    · intro m; apply ae_of_all; intro t
      simpa using (abs_sub ..).trans (add_le_add (hb _) (hb t))
    · filter_upwards [hc] with t ht
      simpa using (ht.sub_const (f t)).abs
  simpa using limit

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

omit [MeasurableSpace Ω] in
private lemma empirical_int (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) :
    Integrable (fun t : I => empiricalAt U n t ω) volume := by
  have hm : Measurable (fun t : I => empiricalAt U n t ω) := by
    simp_rw [empiricalAt_eq_count]
    apply Measurable.const_mul
    apply Measurable.sub _ (measurable_subtypeVal.const_mul _)
    exact Finset.measurable_fun_sum _ fun j _ => measurable_const.ite
      (measurableSet_le measurable_const measurable_subtypeVal) measurable_const
  exact Integrable.of_bound hm.aestronglyMeasurable _ (ae_of_all _ fun t => empiricalAt_bound ..)

/-- The empirical CDF discrepancy, already multiplied by √n, as an L¹ path. -/
def empiricalPath (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) : UnitL1 :=
  (empirical_int U n ω).toL1 _

omit [MeasurableSpace Ω] in
theorem empiricalPath_ae (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) :
    ⇑(empiricalPath U n ω) =ᵐ[volume] fun t : I => empiricalAt U n t ω :=
  (empirical_int U n ω).coeFn_toL1

omit [MeasurableSpace Ω] in
private lemma empirical_grid_sample (U : ℕ → Ω → ℝ) (s : I) (m n : ℕ) (ω : Ω) :
    empiricalGrid (gridTime s m) U n ω = sampleGrid s m (fun t => empiricalAt U n t ω) := by
  apply WithLp.ofLp_injective
  funext i
  exact empiricalGrid_apply (gridTime s m) U n ω i

omit [MeasurableSpace Ω] in
private lemma empirical_grid_pointwise (U : ℕ → Ω → ℝ) (n : ℕ) (ω : Ω) :
    ∀ᵐ t : I ∂volume, Tendsto (fun m => empiricalAt U n (node m (index m t)) ω) atTop
      (𝓝 (empiricalAt U n t ω)) := by
  have distinct : ∀ᵐ t : I ∂volume, ∀ i, (t : ℝ) ≠ U i ω := by
    apply ae_all_iff.mpr; intro i
    apply ae_of_ae_map (μ := (volume : Measure I)) (p := fun x : ℝ => x ≠ U i ω)
      measurable_subtypeVal.aemeasurable
    rw [unitInterval.measurePreserving_subtypeVal.map_eq]
    exact ae_restrict_of_ae (volume.ae_ne (U i ω))
  filter_upwards [distinct] with t ht
  have hnode : Tendsto (fun m => ((node m (index m t) : I) : ℝ)) atTop (𝓝 (t : ℝ)) :=
    continuous_subtypeVal.continuousAt.tendsto.comp (node_limit t)
  have hit (i : Fin n) : Tendsto
      (fun m => if U i ω ≤ (node m (index m t) : ℝ) then (1 : ℝ) else 0) atTop
      (𝓝 (if U i ω ≤ t then 1 else 0)) := by
    rcases lt_or_gt_of_ne (ht i) with hl | hg
    · rw [ite_eq_right (not_le.mpr hl)]
      exact tendsto_const_nhds.congr' ((hnode.eventually_lt_const hl).mono
        fun m hm => (ite_eq_right (not_le.mpr hm)).symm)
    · rw [ite_eq_left hg.le]
      exact tendsto_const_nhds.congr' ((hnode.eventually_const_lt hg).mono
        fun m hm => (ite_eq_left hm.le).symm)
  simp only [empiricalAt_eq_count]
  exact (((tendsto_finsetSum Finset.univ fun i _ => hit i).sub (hnode.const_mul _)).const_mul _)

private def empiricalPair (U : ℕ → Ω → ℝ) (s : I) (n : ℕ) (ω : Ω) : UnitL1 × ℝ :=
  (empiricalPath U n ω, empiricalAt U n s ω)

private def bridgePair (W : NNReal → Ξ → ℝ) (s : I) (ξ : Ξ) : UnitL1 × ℝ :=
  (ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ), brownianBridge W ξ s)

private lemma empirical_grid_limit (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (s : I) (n : ℕ) (ω : Ω) : Tendsto
      (fun m => gridPair m (empiricalGrid (gridTime s m) U n ω)) atTop
      (𝓝 (empiricalPair U s n ω)) := by
  simp_rw [empirical_grid_sample]
  exact grid_approx s _ _ (empiricalPath_ae U n ω) _ ((empiricalAt_measurable hm n).comp
    (measurable_id.prodMk measurable_const)) (fun t => empiricalAt_bound U n t ω)
    (empirical_grid_pointwise U n ω)

omit [MeasurableSpace Ω] in
private lemma grid_distance (U : ℕ → Ω → ℝ) (s : I) (n m : ℕ) (ω : Ω) :
    dist (empiricalPair U s n ω) (gridPair m (empiricalGrid (gridTime s m) U n ω)) =
      ∫ t : I, |empiricalAt U n t ω - empiricalAt U n (node m (index m t)) ω| := by
  rw [Prod.dist_eq, empirical_grid_sample, grid_sample_last]
  change max _ (dist (empiricalAt U n s ω) (empiricalAt U n s ω)) = _
  rw [dist_self, max_eq_left dist_nonneg]
  exact path_dist (empiricalPath_ae U n ω) (grid_sample ..)

private lemma iid_grid_distance (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P) (s : I) (m n : ℕ) :
    Integrable (fun ω => dist (empiricalPair U s n ω)
      (gridPair m (empiricalGrid (gridTime s m) U n ω))) P ∧
    (∫ ω, dist (empiricalPair U s n ω) (gridPair m (empiricalGrid (gridTime s m) U n ω)) ∂P)
      ≤ Real.sqrt (1 / (m + 1 : ℝ)) := by
  simp_rw [grid_distance]
  let E := empiricalAt U n
  let T t := node m (index m t)
  let C := (Real.sqrt n)⁻¹ * (n + n : ℝ)
  have hT : Measurable T := (measurable_of_finite (f := node m)).comp (index_meas m)
  have he := empiricalAt_measurable hm n
  have hq : Measurable (fun p : I × Ω => E (T p.1) p.2) :=
    he.comp ((hT.comp measurable_fst).prodMk measurable_snd)
  have hdiff : Integrable (fun p : I × Ω => |E p.1 p.2 - E (T p.1) p.2|) (volume.prod P) := by
    apply Integrable.of_bound (he.sub hq).abs.aestronglyMeasurable (C + C)
    exact ae_of_all _ fun p => by
      simpa using (abs_sub ..).trans (add_le_add (empiricalAt_bound U n p.1 p.2)
        (empiricalAt_bound U n (T p.1) p.2))
  refine ⟨hdiff.integral_prod_right, ?_⟩
  calc
    _ = ∫ t, ∫ ω, |E t ω - E (T t) ω| ∂P ∂volume := (integral_integral_swap hdiff).symm
    _ ≤ ∫ _t : I, Real.sqrt (1 / (m + 1 : ℝ)) := by
      apply integral_mono hdiff.integral_prod_left (integrable_const _)
      intro t
      exact (iid_empirical_increment U hu hi n _ _ (node_bounds m t).1).trans
        (Real.sqrt_le_sqrt (node_bounds m t).2)
    _ = _ := by simp

/-- The scaled empirical CDF converges jointly in L¹ and at any specified
threshold. The separate coordinate retains the value lost by a.e. identification. -/
theorem iid_empirical_path_eval_limit (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) (s : I) :
    TendstoInDistribution (fun n ω => (empiricalPath U n ω, empiricalAt U n s ω)) atTop
      (fun ξ => (ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ), brownianBridge W ξ s))
      (fun _ => P) Q := by
  let A := empiricalPair U s
  let Z := bridgePair W s
  let G m n := gridPair m ∘ empiricalGrid (gridTime s m) U n
  let B m := fun ξ => gridPair m (sampleGrid s m (brownianBridge W ξ))
  have hG m : TendstoInDistribution (G m) atTop (B m) (fun _ => P) Q :=
    (iid_empirical_grid_limit (gridTime s m) U hu hi W hW).continuous_comp (gridPair_cont m)
  have ha n : AEMeasurable (A n) P := aemeasurable_of_tendsto_metrizable_ae atTop
    (fun m => (hG m).forall_aemeasurable n) (ae_of_all _ (empirical_grid_limit U hm s n))
  have hb ξ : Tendsto (fun m => B m ξ) atTop (𝓝 (Z ξ)) := by
    let f := brownianBridge W ξ
    exact grid_approx s f _ (ContinuousMap.coeFn_toLp (𝕜 := ℝ) volume f) ‖f‖ f.continuous.measurable
      (fun t => f.norm_coe_le_norm t)
      (ae_of_all _ fun t => f.continuous.continuousAt.tendsto.comp (node_limit t))
  have hz : AEMeasurable Z Q := aemeasurable_of_tendsto_metrizable_ae atTop
    (fun m => (hG m).aemeasurable_limit) (ae_of_all _ hb)
  have hB := tendstoInDistribution_of_ae_tendsto
    (fun m => (hG m).aemeasurable_limit) hz (ae_of_all _ hb)
  change TendstoInDistribution A atTop Z (fun _ => P) Q
  refine ⟨ha, hz, ?_⟩
  apply tendsto_iff_forall_lipschitz_integral_tendsto.mpr
  rintro F ⟨M, hM⟩ ⟨L, hL⟩
  let J (μ : Measure (UnitL1 × ℝ)) := ∫ x, F x ∂μ
  have grid m : Tendsto (fun n => J (P.map (G m n))) atTop (𝓝 (J (Q.map (B m)))) :=
    tendsto_iff_forall_lipschitz_integral_tendsto.mp (hG m).tendsto F ⟨M, hM⟩ ⟨L, hL⟩
  have limit : Tendsto (fun m => J (Q.map (B m))) atTop (𝓝 (J (Q.map Z))) :=
    tendsto_iff_forall_lipschitz_integral_tendsto.mp hB.tendsto F ⟨M, hM⟩ ⟨L, hL⟩
  have int {X : Ω → UnitL1 × ℝ} (hx : AEMeasurable X P) :
      Integrable (fun ω => F (X ω)) P := by
    apply Integrable.of_bound (hL.continuous.measurable.comp_aemeasurable hx).aestronglyMeasurable
      (‖F 0‖ + M)
    apply ae_of_all; intro ω
    change ‖F (X ω)‖ ≤ ‖F 0‖ + M
    linarith [abs_sub_abs_le_abs_sub (F (X ω)) (F 0), hM (X ω) 0,
      Real.dist_eq (F (X ω)) (F 0), Real.norm_eq_abs (F (X ω)), Real.norm_eq_abs (F 0)]
  have error m n : dist (J (P.map (A n))) (J (P.map (G m n))) ≤
      L * Real.sqrt (1 / (m + 1 : ℝ)) := by
    obtain ⟨iD, hD⟩ := iid_grid_distance U hm hu hi s m n
    have gm := (hG m).forall_aemeasurable n
    dsimp only [J]
    rw [Real.dist_eq, integral_map (ha n) hL.continuous.aestronglyMeasurable,
      integral_map gm hL.continuous.aestronglyMeasurable, ← integral_sub (int (ha n)) (int gm)]
    apply abs_integral_le_integral_abs.trans
    calc
      _ ≤ ∫ ω, (L : ℝ) * dist (A n ω) (G m n ω) ∂P := by
        apply integral_mono_of_nonneg (ae_of_all _ fun _ => abs_nonneg _) (iD.const_mul _)
        exact ae_of_all _ fun ω => hL.dist_le_mul _ _
      _ ≤ _ := by rw [integral_const_mul]; exact mul_le_mul_of_nonneg_left hD L.coe_nonneg
  change Tendsto (fun n => J (P.map (A n))) atTop (𝓝 (J (Q.map Z)))
  apply Metric.tendsto_nhds.mpr
  intro ε hε
  have third : 0 < ε / 3 := by positivity
  have he : Tendsto (fun m : ℕ => (L : ℝ) * Real.sqrt (1 / (m + 1 : ℝ))) atTop (𝓝 0) := by
    simpa using ((Real.continuous_sqrt.tendsto _).comp mesh_zero).const_mul (L : ℝ)
  obtain ⟨m, hm₁, hm₂⟩ := ((he.eventually_lt_const third).and
    (Metric.tendsto_nhds.mp limit _ third)).exists
  filter_upwards [Metric.tendsto_nhds.mp (grid m) _ third] with n hn
  have a := dist_triangle (J (P.map (A n))) (J (P.map (G m n))) (J (Q.map (B m)))
  have b := dist_triangle (J (P.map (A n))) (J (Q.map (B m))) (J (Q.map Z))
  linarith [error m n]

/-- The joint reference needed for a median location fit. -/
theorem iid_empirical_path_half_limit (U : ℕ → Ω → ℝ) (hm : ∀ i, Measurable (U i))
    (hu : ∀ i, HasLaw (U i) uniformPIT P) (hi : iIndepFun U P)
    (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q) :
    let half : I := ⟨1/2, by constructor <;> norm_num⟩
    TendstoInDistribution (fun n ω => (empiricalPath U n ω, empiricalAt U n half ω)) atTop
      (fun ξ => (ContinuousMap.toLp 1 volume ℝ (brownianBridge W ξ), brownianBridge W ξ half))
      (fun _ => P) Q :=
  iid_empirical_path_eval_limit U hm hu hi W hW _

end PITW
