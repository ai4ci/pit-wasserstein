/-
Copyright (c) 2026 pit-wasserstein authors. All rights reserved.
Released under the MIT license as described in the file LICENSE.md.
Authors: pit-wasserstein authors
-/
module

public import PITW.Tests

/-! Linearisation of the actual normal-scale sample median. We index sample sizes
by n + 1 so that both central ranks exist, including for a single observation. -/

public section
noncomputable section
open Filter MeasureTheory ProbabilityTheory Set
open scoped Topology unitInterval
namespace PITW

/-- Square-root scaling for a nonempty sample. -/
@[expose] def rankScale (n : ℕ) : ℝ := Real.sqrt (n + 1)

theorem rankScale_pos (n : ℕ) : 0 < rankScale n := by unfold rankScale; positivity

theorem rankScale_atTop : Tendsto rankScale atTop atTop :=
  Real.tendsto_sqrt_atTop.comp (tendsto_atTop_add_const_right _ 1 tendsto_natCast_atTop_atTop)

/-- A plotting position, as a point of the closed unit interval. -/
@[expose] def midUnit {n : ℕ} (i : Fin (n + 1)) : I := ⟨midpoint i, by
  have hi : (i : ℝ) ≤ n := by exact_mod_cast i.is_le
  simp only [midpoint, Nat.cast_add, Nat.cast_one]
  constructor
  · positivity
  · apply (div_le_one (by positivity)).2; linarith⟩

/-- Supremum error when the raw scaled ranks are coupled to a continuous path.
Each row has n + 1 entries in increasing order on the standard normal scale. -/
@[expose] def UniformRanks (z : (n : ℕ) → Fin (n + 1) → ℝ) (G : C(I, ℝ)) : Prop :=
  Tendsto (fun n => ‖fun i : Fin (n + 1) =>
    rankScale n * (midpoint i - Φ (z n i)) - G (midUnit i)‖) atTop (𝓝 0)

theorem uniformRanks_along {z : (n : ℕ) → Fin (n + 1) → ℝ} {G : C(I, ℝ)}
    (h : UniformRanks z G) (i : (n : ℕ) → Fin (n + 1)) {t : I}
    (ht : Tendsto (fun n => midpoint (i n)) atTop (𝓝 (t : ℝ))) :
    Tendsto (fun n => rankScale n * (midpoint (i n) - Φ (z n (i n)))) atTop (𝓝 (G t)) := by
  have herr : Tendsto (fun n => rankScale n * (midpoint (i n) - Φ (z n (i n))) -
      G (midUnit (i n))) atTop (𝓝 0) := by
    apply squeeze_zero_norm' _ h
    exact .of_forall fun n => norm_le_pi_norm (fun j =>
      rankScale n * (midpoint j - Φ (z n j)) - G (midUnit j)) (i n)
  have hc := G.continuous.continuousAt.tendsto.comp (tendsto_subtype_rng.mpr ht :
    Tendsto (fun n => midUnit (i n)) atTop (𝓝 t))
  simpa using herr.add hc

/-- Arithmetic mean of the central normal order statistics. For odd sample sizes
both indices select the same rank. -/
@[expose] def normalMedian (n : ℕ) (z : Fin (n + 1) → ℝ) : ℝ :=
  (z ⟨n / 2, by omega⟩ + z ⟨(n + 1) / 2, by omega⟩) / 2

/-- Median on the probability scale. -/
abbrev unitHalf : I := ⟨1 / 2, by constructor <;> norm_num⟩
private abbrev φ := gaussianPDFReal 0 1

theorem normal_tendsto_of_cdf {x : ℕ → ℝ} {a : ℝ}
    (h : Tendsto (fun n => Φ (x n)) atTop (𝓝 (Φ a))) : Tendsto x atTop (𝓝 a) := by
  apply tendsto_order.mpr
  exact ⟨fun b hb => ((tendsto_order.mp h).1 _ (normalCDF_strictMono hb)).mono
    (fun n hn => normalCDF_strictMono.lt_iff_lt.mp hn),
    fun b hb => ((tendsto_order.mp h).2 _ (normalCDF_strictMono hb)).mono
      (fun n hn => normalCDF_strictMono.lt_iff_lt.mp hn)⟩

private lemma unscale {x : ℕ → ℝ} {a : ℝ}
    (h : Tendsto (fun n => rankScale n * x n) atTop (𝓝 a)) : Tendsto x atTop (𝓝 0) := by
  simpa only [mul_div_cancel_left₀ _ (rankScale_pos _).ne'] using h.div_atTop rankScale_atTop

private lemma central_normal_limit {z : (n : ℕ) → Fin (n + 1) → ℝ} {G : C(I, ℝ)}
    (h : UniformRanks z G) (i : (n : ℕ) → Fin (n + 1))
    (hi : ∀ n, 2 * (i n : ℕ) ≤ n + 1 ∧ n ≤ 2 * (i n : ℕ) + 1) :
    Tendsto (fun n => rankScale n * z n (i n)) atTop (𝓝 (-G unitHalf / φ 0)) := by
  have hs (n : ℕ) : rankScale n ^ 2 = n + 1 := Real.sq_sqrt (by positivity)
  have hmid : Tendsto (fun n => rankScale n * (midpoint (i n) - 1 / 2)) atTop (𝓝 0) := by
    apply squeeze_zero_norm' _ (rankScale_atTop.const_div_atTop 1)
    apply Eventually.of_forall
    intro n
    have h₁ : 2 * (i n : ℝ) ≤ n + 1 := by exact_mod_cast (hi n).1
    have h₂ : (n : ℝ) ≤ 2 * (i n : ℝ) + 1 := by exact_mod_cast (hi n).2
    rw [Real.norm_eq_abs, abs_le]
    simp only [midpoint, Nat.cast_add, Nat.cast_one]
    constructor <;> field_simp [rankScale_pos, show (0:ℝ) < n + 1 by positivity] <;>
      nlinarith [hs n, rankScale_pos n]
  have ht : Tendsto (fun n => midpoint (i n)) atTop (𝓝 (1 / 2 : ℝ)) := by
    simpa using (unscale hmid).add_const (1 / 2 : ℝ)
  have raw := uniformRanks_along h i (t := unitHalf) ht
  have pit : Tendsto (fun n => rankScale n * (Φ (z n (i n)) - Φ 0)) atTop (𝓝 (-G unitHalf)) := by
    convert hmid.sub raw using 1
    · funext n; rw [normalCDF_zero]; ring
    · simp
  have hz : Tendsto (fun n => z n (i n)) atTop (𝓝 0) :=
    normal_tendsto_of_cdf (by simpa using (unscale pit).add_const (Φ 0))
  let slope := Function.update (fun x => (Φ x - Φ 0) / (x - 0)) 0 (φ 0)
  have hd : Tendsto (fun n => slope (z n (i n))) atTop (𝓝 (φ 0)) := by
    simpa only [Function.update_self, slope, Function.comp_def, φ] using
      (normalCDF_deriv 0).continuousAt_div.tendsto.comp hz
  apply (pit.div hd (gaussianPDFReal_pos 0 _ _ one_ne_zero).ne').congr
  intro n
  by_cases hz0 : z n (i n) = 0
  · simp [hz0]
  · have hdiff : Φ (z n (i n)) - Φ 0 ≠ 0 := sub_ne_zero.mpr (normalCDF_strictMono.injective.ne hz0)
    change rankScale n * (Φ (z n (i n)) - Φ 0) / slope (z n (i n)) = _
    simp only [slope, Function.update_of_ne hz0, sub_zero]
    field_simp [hdiff, hz0]

/-- Jointly approximating the raw ranks fixes the scaled median, including the
even-sample convention. The minus sign corresponds to midpoint minus observed PIT. -/
theorem normalMedian_limit {z : (n : ℕ) → Fin (n + 1) → ℝ} {G : C(I, ℝ)}
    (h : UniformRanks z G) :
    Tendsto (fun n => rankScale n * normalMedian n (z n)) atTop
      (𝓝 (-G ⟨1 / 2, by constructor <;> norm_num⟩ / gaussianPDFReal 0 1 0)) := by
  have lo := central_normal_limit h (fun n => ⟨n / 2, by omega⟩) (by intro n; simp; omega)
  have hi := central_normal_limit h (fun n => ⟨(n + 1) / 2, by omega⟩) (by intro n; simp; omega)
  convert (lo.add hi).div_const 2 using 1
  · funext n; unfold normalMedian; ring
  · apply congrArg nhds
    change -G unitHalf / φ 0 = (-G unitHalf / φ 0 + -G unitHalf / φ 0) / 2
    ring

end PITW
