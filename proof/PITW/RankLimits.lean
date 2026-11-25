/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.SampleMedian

/-! From a uniform approximation of the raw order statistics to all three scores.
The fitted scores use the central order statistics of each actual sample. -/

public section
noncomputable section
open Filter Set MeasureTheory ProbabilityTheory
open scoped Topology unitInterval
namespace PITW

private abbrev φ := gaussianPDFReal 0 1

theorem inCell_midpoint {t : ℝ} (i : (n : ℕ) → Fin (n + 1))
    (hc : ∀ n, ((i n : ℝ) / (n + 1) < t ∧ t ≤ ((i n : ℝ) + 1) / (n + 1))) :
    Tendsto (fun n => midpoint (i n)) atTop (𝓝 t) := by
  apply tendsto_iff_norm_sub_tendsto_zero.mpr
  have hh : Tendsto (fun n : ℕ => (1 : ℝ) / (n + 1)) atTop (𝓝 0) :=
    (tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop).const_div_atTop 1
  apply squeeze_zero (fun _ => norm_nonneg _) _ hh
  intro n
  have hn : (0 : ℝ) < n + 1 := by positivity
  have hl := (div_lt_iff₀ hn).mp (hc n).1
  have hr := (le_div_iff₀ hn).mp (hc n).2
  simp only [midpoint, Nat.cast_add, Nat.cast_one, Real.norm_eq_abs, abs_le]
  constructor <;> field_simp <;> linarith

private def rep (n : ℕ) (u : Fin (n + 1) → ℝ) : ℝ → ℝ :=
  fun t => rankScale n * rankFunction u t

private theorem rep_int (n : ℕ) (u : Fin (n + 1) → ℝ) : Integrable (rep n u) :=
  (rankFunction_integrable u).const_mul _

private theorem rep_toL1 (n : ℕ) (u : Fin (n + 1) → ℝ) :
    (rep_int n u).toL1 _ = scaledRanks u := by
  rw [scaledRanks, ← rankPath_toL1, ← Integrable.toL1_smul]
  simp only [Nat.cast_add, Nat.cast_one]
  rfl

/-- Dominated convergence for equal-width quantile steps. Values at either
endpoint of the interval have no effect on convergence in L¹. -/
private theorem grid_limit (u : (n : ℕ) → Fin (n + 1) → ℝ) (f : ℝ → ℝ) (hf : Integrable f)
    (hout : ∀ t ∉ Icc (0 : ℝ) 1, f t = 0)
    (hgrid : ∀ t ∈ Ioo (0 : ℝ) 1, ∀ (i : (n : ℕ) → Fin (n + 1)),
      Tendsto (fun n => midpoint (i n)) atTop (𝓝 t) →
      Tendsto (fun n => rankScale n * (midpoint (i n) - u n (i n))) atTop (𝓝 (f t)))
    (C : ℝ) (hC : ∀ᶠ n in atTop, ∀ i, |rankScale n * (midpoint i - u n i)| ≤ C) :
    Tendsto (fun n => scaledRanks (u n)) atTop (𝓝 (hf.toL1 f)) := by
  have pt : ∀ᵐ t ∂volume, Tendsto (fun n => rep n (u n) t) atTop (𝓝 (f t)) := by
    filter_upwards [volume.ae_ne (0 : ℝ), volume.ae_ne (1 : ℝ)] with t h₀ h₁
    by_cases ht : t ∈ Icc (0 : ℝ) 1
    · have ht' : t ∈ Ioo (0 : ℝ) 1 := ⟨lt_of_le_of_ne ht.1 h₀.symm, lt_of_le_of_ne ht.2 h₁⟩
      choose i hi using fun n => rank_cell_exists n (show t ∈ Ioc (0 : ℝ) 1 from ⟨ht'.1, ht.2⟩)
      apply (hgrid t ht' i (inCell_midpoint i hi)).congr
      intro n; rw [rep, rankFunction_at _ _ (hi n).1 (hi n).2]
    · have hc : t ∉ Ioc (0 : ℝ) 1 := fun hx => ht ⟨hx.1.le, hx.2⟩
      simpa only [rep, rankFunction_outside _ hc, mul_zero, hout t ht] using
        (tendsto_const_nhds (x := (0 : ℝ)) (f := atTop (α := ℕ)))
  let b := (Ioc (0 : ℝ) 1).indicator (fun _ => C)
  have hb : Integrable b :=
    (integrableOn_const (s := Ioc (0 : ℝ) 1) measure_Ioc_lt_top.ne).integrable_indicator
      measurableSet_Ioc
  have dom : ∀ᶠ n in atTop, ∀ᵐ t ∂volume, ‖rep n (u n) t‖ ≤ b t := by
    filter_upwards [hC] with n hn
    filter_upwards with t
    by_cases ht : t ∈ Ioc (0 : ℝ) 1
    · obtain ⟨i, h₁, h₂⟩ := rank_cell_exists n ht
      simpa only [rep, b, indicator_of_mem ht, Real.norm_eq_abs, rankFunction_at _ i h₁ h₂]
        using hn i
    · simp [rep, b, rankFunction_outside _ ht, ht]
  let D := fun n t => ‖rep n (u n) t - f t‖
  have hi := tendsto_integral_filter_of_dominated_convergence (μ := volume)
    (F := D) (f := fun _ => (0 : ℝ)) (fun t => b t + ‖f t‖)
    (.of_forall fun n => ((rep_int n (u n)).sub hf).norm.aestronglyMeasurable)
    (dom.mono fun n hn => hn.mono fun t h => by
      simpa [D, Real.norm_of_nonneg (norm_nonneg _)] using
        (norm_sub_le (rep n (u n) t) (f t)).trans (add_le_add h (le_refl ‖f t‖)))
    (hb.add hf.norm) (pt.mono fun t h => by
      simpa [D] using (tendsto_iff_norm_sub_tendsto_zero.mp h))
  apply tendsto_iff_norm_sub_tendsto_zero.mpr
  convert hi using 1
  · funext n
    rw [← rep_toL1, ← Integrable.toL1_sub, L1.norm_eq_integral_norm]
    apply integral_congr_ae
    exact ((rep_int n (u n)).sub hf).coeFn_toL1.mono fun _ h => congrArg norm h
  · simp

/-- For a nonempty ordered row, apply the fitted common shift on the Gaussian scale. -/
@[expose] def adjustedPIT (n : ℕ) (z : Fin (n + 1) → ℝ) (i : Fin (n + 1)) : ℝ :=
  Φ (z i - normalMedian n z)

/-- A single uniform approximation of the raw PIT ranks implies both path limits.
The sample median and the adjustment error are derived from the rows themselves. -/
theorem coupled_rank_limits {z : (n : ℕ) → Fin (n + 1) → ℝ} {G : C(I, ℝ)}
    (h : UniformRanks z G) :
    Tendsto (fun n => scaledRanks (fun i => Φ (z n i))) atTop (𝓝 (unitToL1 G)) ∧
    Tendsto (fun n => scaledRanks (adjustedPIT n (z n))) atTop
      (𝓝 (project medianProfile (unitToL1 G, G unitHalf))) := by
  let m n := normalMedian n (z n)
  let a := -G unitHalf / φ 0
  have hm : Tendsto (fun n => rankScale n * m n) atTop (𝓝 a) := normalMedian_limit h
  have hzero : Tendsto m atTop (𝓝 0) := by
    simpa only [mul_div_cancel_left₀ _ (rankScale_pos _).ne'] using hm.div_atTop rankScale_atTop
  have hquad : Tendsto (fun n => rankScale n * (φ 0 * m n ^ 2)) atTop (𝓝 0) := by
    convert ((hm.mul hzero).const_mul (φ 0)) using 1
    · funext n; ring
    · ring_nf
  let R := fun n (i : Fin (n + 1)) => rankScale n * (midpoint i - Φ (z n i))
  have hbound : ∀ᶠ n in atTop, ∀ i, |R n i| ≤ 1 + ‖G‖ := by
    have he := (tendsto_order.mp h).2 1 zero_lt_one
    filter_upwards [he] with n hn i
    have hd := (norm_le_pi_norm (fun j => R n j - G (midUnit j)) i).trans hn.le
    calc
      |R n i| = ‖(R n i - G (midUnit i)) + G (midUnit i)‖ := by simp [Real.norm_eq_abs]
      _ ≤ _ := (norm_add_le _ _).trans (add_le_add hd (G.norm_coe_le_norm _))
  constructor
  · rw [unitToL1_apply]
    apply grid_limit _ _ _ (fun _ ht => extendUnit_outside G ht) _ _ hbound
    intro t ht i hi
    rw [extendUnit_at G ⟨ht.1.le, ht.2.le⟩]
    exact uniformRanks_along h i hi
  let f := fun t => extendUnit G t - G unitHalf * normalProfile t
  have hf : Integrable f := (extendUnit_integrable G).sub (normalProfile_integrable.const_mul _)
  have hpath : project medianProfile (unitToL1 G, G unitHalf) = hf.toL1 f := by
    rw [project, unitToL1_apply, medianProfile, ← Integrable.toL1_smul, ← Integrable.toL1_sub]
    rfl
  rw [hpath]
  apply grid_limit _ _ hf
  · intro t ht; simp [f, extendUnit_outside _ ht, normalProfile_outside ht]
  · intro t ht i hi
    let u : I := ⟨t, ht.1.le, ht.2.le⟩
    have hr : Tendsto (fun n => R n (i n)) atTop (𝓝 (G u)) := uniformRanks_along h i hi
    obtain ⟨x, hx⟩ := normalCDF_range ht
    have hu := hr.div_atTop rankScale_atTop
    have hpit : Tendsto (fun n => Φ (z n (i n))) atTop (𝓝 (Φ x)) := by
      simp only [R, mul_div_cancel_left₀ _ (rankScale_pos _).ne'] at hu
      simpa [hx] using hi.sub hu
    have hd := normalPDF_continuous.continuousAt.tendsto.comp (normal_tendsto_of_cdf hpit)
    let e n := Φ (z n (i n) - m n) - Φ (z n (i n)) + m n * φ (z n (i n))
    have he : Tendsto (fun n => rankScale n * e n) atTop (𝓝 0) := by
      apply squeeze_zero_norm' _ hquad
      exact .of_forall fun n => by
        rw [Real.norm_eq_abs, abs_mul, abs_of_pos (rankScale_pos _)]
        exact mul_le_mul_of_nonneg_left (normal_shift_remainder _ _) (rankScale_pos _).le
    convert (hr.add (hm.mul hd)).sub he using 1
    · funext n; dsimp [R, e, adjustedPIT, m, φ]; ring
    · apply congrArg nhds
      rw [show f t = G u - G unitHalf * normalProfile t from by
        simp only [f, extendUnit_at G ⟨ht.1.le, ht.2.le⟩]; rfl]
      rw [← hx, normalProfile_cdf]
      dsimp [a, φ]; ring
  · have hab := (tendsto_order.mp hm.abs).2 (|a| + 1) (by linarith)
    filter_upwards [hbound, hab] with n hb hm' i
    have hd := normalCDF_lipschitz (z n i - m n) (z n i)
    have hin : |rankScale n * (Φ (z n i) - Φ (z n i - m n))| ≤ φ 0 * (|a| + 1) := by
      rw [abs_mul, abs_of_pos (rankScale_pos _)]
      have hh := mul_le_mul_of_nonneg_left hd (rankScale_pos n).le
      simp only [sub_sub_cancel] at hh
      apply hh.trans
      rw [mul_left_comm, ← abs_of_pos (rankScale_pos n), ← abs_mul]
      exact mul_le_mul_of_nonneg_left hm'.le (gaussianPDFReal_nonneg ..)
    calc
      _ = |R n i + rankScale n * (Φ (z n i) - Φ (z n i - m n))| := by
        congr 1; dsimp [R, adjustedPIT, m]; ring
      _ ≤ _ := (abs_add_le ..).trans (add_le_add (hb i) hin)

/-- The baseline, fitted unsigned and fitted directed scores on the same coupling. -/
theorem coupled_score_limits {z : (n : ℕ) → Fin (n + 1) → ℝ} {G : C(I, ℝ)}
    (h : UniformRanks z G) :
    Tendsto (fun n => rankScale n * unsignedScore (fun i => Φ (z n i))) atTop
      (𝓝 ‖unitToL1 G‖) ∧
    Tendsto (fun n => rankScale n * unsignedScore (adjustedPIT n (z n))) atTop
      (𝓝 ‖project medianProfile (unitToL1 G, G unitHalf)‖) ∧
    Tendsto (fun n => rankScale n * directedScore (adjustedPIT n (z n))) atTop
      (𝓝 (signedArea (unitToL1 G))) := by
  obtain ⟨raw, adj⟩ := coupled_rank_limits h
  have hs := signedArea.continuous.continuousAt.tendsto.comp adj
  simpa only [Function.comp_def, scaledRanks, norm_smul, Real.norm_eq_abs,
    abs_of_nonneg (Real.sqrt_nonneg _), norm_rankPath, map_smul, signed_rankPath, smul_eq_mul,
    Nat.cast_add, Nat.cast_one, rankScale, signed_project signed_medianProfile] using
    And.intro raw.norm (And.intro adj.norm hs)

/-- The three statistics computed from the same ordered row, in manuscript order. -/
@[expose] def sampleScores (n : ℕ) (z : Fin (n + 1) → ℝ) : ℝ × ℝ × ℝ :=
  (rankScale n * unsignedScore (fun i => Φ (z i)),
   rankScale n * unsignedScore (adjustedPIT n z),
   rankScale n * directedScore (adjustedPIT n z))

theorem sampleScores_measurable (n : ℕ) : Measurable (sampleScores n) := by
  have hΦ : Continuous Φ :=
    continuous_iff_continuousAt.mpr fun t => (normalCDF_deriv t).continuousAt
  unfold sampleScores unsignedScore directedScore adjustedPIT normalMedian
  fun_prop

/-- Joint limiting scores as functions of one bridge. -/
@[expose] def bridgeScores (G : C(I, ℝ)) : ℝ × ℝ × ℝ :=
  (‖unitToL1 G‖, ‖project medianProfile (unitToL1 G, G unitHalf)‖, signedArea (unitToL1 G))

private lemma bridgeScores_continuous : Continuous bridgeScores := by
  exact (continuous_norm.comp unitToL1.continuous).prodMk
    ((continuous_norm.comp ((continuous_project medianProfile).comp
      (unitToL1.continuous.prodMk (ContinuousMap.evalCLM ℝ unitHalf).continuous))).prodMk
      (signedArea.continuous.comp unitToL1.continuous))

variable {Ω Ξ : Type*} [MeasurableSpace Ω] [MeasurableSpace Ξ]
  {P : Measure Ω} [IsProbabilityMeasure P] {Q : Measure Ξ} [IsProbabilityMeasure Q]

/-- The coupling may use a different probability space and different rows for each
sample size. Only the law of each observed row must agree with its coupled copy. -/
theorem coupled_sampling_limits (z : (n : ℕ) → Ω → Fin (n + 1) → ℝ)
    (copy : (n : ℕ) → Ξ → Fin (n + 1) → ℝ) (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q)
    (hlaw : ∀ n, IdentDistrib (z n) (copy n) P Q)
    (hrank : ∀ᵐ ξ ∂Q, UniformRanks (fun n => copy n ξ) (brownianBridge W ξ)) :
    TendstoInDistribution (fun n ω => sampleScores n (z n ω)) atTop
      (bridgeScores ∘ brownianBridge W) (fun _ => P) Q := by
  have hcopy (n : ℕ) := (hlaw n).comp (sampleScores_measurable n)
  have h := tendstoInDistribution_of_ae_tendsto
    (fun n => (hcopy n).aemeasurable_snd)
    (bridgeScores_continuous.measurable.comp_aemeasurable (brownianBridge_gaussian hW).aemeasurable)
    (hrank.mono fun ξ hξ => by
      obtain ⟨b, u, d⟩ := coupled_score_limits hξ
      exact b.prodMk_nhds (u.prodMk_nhds d))
  refine ⟨fun n => (hcopy n).aemeasurable_fst, h.aemeasurable_limit, ?_⟩
  exact h.tendsto.congr fun n => Subtype.ext (hcopy n).map_eq.symm

/-- Two-sided asymptotic rejection probability using the observed sample median.
Every cutoff is a continuity point of the absolute Gaussian limiting law. -/
theorem coupled_directed_test_size (z : (n : ℕ) → Ω → Fin (n + 1) → ℝ)
    (copy : (n : ℕ) → Ξ → Fin (n + 1) → ℝ) (W : NNReal → Ξ → ℝ) (hW : IsBrownianReal W Q)
    (hlaw : ∀ n, IdentDistrib (z n) (copy n) P Q)
    (hrank : ∀ᵐ ξ ∂Q, UniformRanks (fun n => copy n ξ) (brownianBridge W ξ)) (c : ℝ) :
    Tendsto (fun n => P {ω | c < |rankScale n * directedScore (adjustedPIT n (z n ω))|}) atTop
      (𝓝 (gaussianReal 0 (1 / 48) {x | c < |x|})) := by
  have h := coupled_sampling_limits z copy W hW hlaw hrank
  apply directed_rejection_probability (h.continuous_comp (continuous_snd.comp continuous_snd))
  exact (Measure.map_congr (brownianBridge_area_ae hW)).trans (brownian_directed_law hW)

end PITW
