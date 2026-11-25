/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Pinned

/-! A continuous version of a centred Gaussian process on the unit interval has
a Gaussian law in the supremum norm. Bernstein approximations reduce continuous
linear observations of the path to finite linear combinations of evaluations. -/

public section
noncomputable section
open MeasureTheory ProbabilityTheory Filter Set
open scoped Topology unitInterval
namespace PITW

variable {Ω : Type*} [MeasurableSpace Ω] {P : Measure Ω} [IsProbabilityMeasure P]

private lemma centered_char (v : NNReal) (t : ℝ) :
    charFun (gaussianReal 0 v) t = ((Real.exp (-(v : ℝ) * t ^ 2 / 2) : ℝ) : ℂ) := by
  rw [charFun_gaussianReal, Complex.ofReal_exp]
  push_cast
  congr 1
  ring

/-- Weak limits of centred real Gaussian laws are centred Gaussian, including the
degenerate limit. Recover the variance from the characteristic function near zero. -/
private lemma centered_closed {S : ℕ → Ω → ℝ} {Z : Ω → ℝ}
    (h : TendstoInDistribution S atTop Z (fun _ => P) P)
    (v : ℕ → NNReal) (hv : ∀ n, P.map (S n) = gaussianReal 0 (v n)) :
    ∃ w : NNReal, P.map Z = gaussianReal 0 w := by
  let μ := P.map Z
  have : IsProbabilityMeasure μ := inferInstanceAs (IsProbabilityMeasure (P.map Z))
  have hchar (t : ℝ) := h.tendsto_charFun t
  simp_rw [hv, centered_char] at hchar
  have near : ∀ᶠ u in 𝓝 (0 : ℝ), 0 < (charFun μ u).re := by
    exact (Complex.continuous_re.comp (continuous_charFun (μ := μ))).continuousAt
      (Ioi_mem_nhds (by simp [charFun_zero] : 0 < (charFun μ 0).re))
  have pos : ∀ᶠ u : ℝ in 𝓝[>] 0, 0 < u := self_mem_nhdsWithin
  obtain ⟨u, hu, hpos⟩ := (pos.and (near.filter_mono nhdsWithin_le_nhds)).exists
  have hu' : u ≠ 0 := ne_of_gt hu
  let a := Real.log (charFun μ u).re * (-2 / u ^ 2)
  have lim : Tendsto (fun n => (v n : ℝ)) atTop (𝓝 a) := by
    have hh := ((Complex.continuous_re.continuousAt.tendsto.comp (hchar u)).log hpos.ne').mul_const
      (-2 / u ^ 2)
    convert hh using 1
    funext n
    simp only [Function.comp_apply, Complex.ofReal_re, Real.log_exp]
    field_simp
  have ha : 0 ≤ a := ge_of_tendsto' lim (fun n => (v n).property)
  let w : NNReal := ⟨a, ha⟩
  have : IsProbabilityMeasure (gaussianReal 0 w) := instIsProbabilityMeasureGaussianReal 0 w
  refine ⟨w, ?_⟩
  apply Measure.ext_of_charFun
  funext t
  rw [centered_char]
  exact tendsto_nhds_unique (hchar t) (Complex.continuous_ofReal.continuousAt.tendsto.comp
    (Real.continuous_exp.continuousAt.tendsto.comp ((lim.neg.mul_const (t ^ 2)).div_const 2)))

private def synthesis (n : ℕ) : (Fin (n + 1) → ℝ) →L[ℝ] C(I, ℝ) :=
  ∑ k : Fin (n + 1), (ContinuousLinearMap.proj (R := ℝ) k).smulRight (bernstein n k)

private lemma synthesis_eq (n : ℕ) (f : C(I, ℝ)) :
    synthesis n (fun k => f (bernstein.z k)) = bernsteinApproximation n f := by
  ext t
  simp [synthesis, bernsteinApproximation.apply, mul_comm]

/-- Finite-dimensional Gaussianity and centred evaluations determine the Gaussian
law of the entire continuous random function on the unit interval. -/
theorem continuous_gaussian_law (B : Ω → C(I, ℝ))
    (hg : IsGaussianProcess (fun t ω => B ω t) P)
    (hm : ∀ t, (∫ ω, B ω t ∂P) = 0) : HasGaussianLaw B P := by
  let A (n : ℕ) := fun ω => bernsteinApproximation n (B ω)
  have rep (n : ℕ) (ω : Ω) : A n ω = synthesis n (fun k => B ω (bernstein.z k)) :=
    (synthesis_eq n (B ω)).symm
  have ga (n : ℕ) : HasGaussianLaw (A n) P := by
    let Y := fun (k : Fin (n+1)) ω => B ω (bernstein.z k)
    have hY := hg.comp_right (@bernstein.z n)
    have H := hY.hasGaussianLaw Finset.univ
    let F : (↥(Finset.univ : Finset (Fin (n+1))) → ℝ) →L[ℝ] C(I, ℝ) :=
      (synthesis n).comp (ContinuousLinearMap.pi fun k =>
        ContinuousLinearMap.proj (R := ℝ) ⟨k, Finset.mem_univ k⟩)
    exact (H.map F).congr (ae_of_all P fun ω => (rep n ω).symm)
  have ha (ω : Ω) : Tendsto (fun n => A n ω) atTop (𝓝 (B ω)) :=
    bernsteinApproximation_uniform _
  have hB := aemeasurable_of_tendsto_metrizable_ae' (fun n => (ga n).aemeasurable)
    (ae_of_all P ha)
  refine ⟨hB, isGaussian_of_map_eq_gaussianReal fun L => ?_⟩
  have hz (n : ℕ) : (∫ ω, L (A n ω) ∂P) = 0 := by
    simp_rw [rep, synthesis, sum_apply, ContinuousLinearMap.smulRight_apply,
      ContinuousLinearMap.proj_apply, map_sum, map_smul, smul_eq_mul]
    rw [integral_finsetSum]
    · simp [integral_mul_const, hm]
    · exact fun k _ => ((hg.hasGaussianLaw_eval (bernstein.z k)).integrable).mul_const _
  have h := tendstoInDistribution_of_ae_tendsto (fun n => (ga n).aemeasurable) hB (ae_of_all P ha)
  obtain ⟨w, hw⟩ := centered_closed (h.continuous_comp L.continuous)
    (fun n => (Var[L ∘ A n; P]).toNNReal) (fun n => by
      rw [((ga n).map L).map_eq_gaussianReal]
      simp only [Function.comp_def, hz])
  exact ⟨0, w, (AEMeasurable.map_map_of_aemeasurable L.continuous.aemeasurable hB).trans hw⟩

end PITW
