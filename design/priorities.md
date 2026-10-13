# Priorities

Working list for the standalone paper. Moved out of `README.md` when `main/`
became the paper directory.

## Now

- [x] Re-run `analysis.R` — `fig1`–`fig4` regenerated with the CRPS fix
      (`fig3`/`fig4` panel A were plotting an inflated CRPS). `tab1-params.pdf`
      deliberately left as the author's render, see `design/active-issues.md`.
- [ ] Recompile `main/main.pdf` (no working LaTeX here yet; `main.bbl` was
      carried over from the supplementary build, re-run bibtex after editing
      citations).
- [ ] `refs.bib` has no entry for the companion estimator paper, but the text
      still says "the main paper" in four places (intro, bias, sharpness,
      conclusion). Either cite it or reword those sentences.
- [ ] Paper has no abstract — a standalone short paper needs one.

## Next

- [ ] Small-sample characterisation ($n = 50, 100, 500, 1000$).
- [ ] Non-normal prediction distributions (log-normal, gamma).
- [ ] Temporal autocorrelation effects.
- [ ] Bootstrap uncertainty bands on $D^*_{pit}$.
- [ ] Comparison with PCE, MCB, and coverage probability.
- [ ] Real data example.

## Later

- [ ] Caveat the bias-adjustment circularity: bias is estimated from the same
      data used to compute $D^*_{pit}$, which needs a note for small $n$.
- [ ] Soften the "proper scoring rule" claim for $D^*_{pit}$ — it is observed,
      not proven.
- [ ] Identify thresholds for significance of $D^*_{pit}$.
- [ ] `R/import-standalone-mixture-distributions.R` is unused by the script —
      delete it unless the paper ends up needing mixture predictions.

## Resolved

- [x] Sign error in the $U^*_{pit}$ prose — over-confidence is $+0.25$,
      excessive uncertainty is $-0.25$ (verified numerically).
- [x] `eq:bias` used $g'$ where $g^{-1}$ (inverse link) was meant.
- [x] Sentence fragment about universal residuals.
- [x] `ggoutbreak` dependency — `R/` standalones are `source()`d instead.
- [x] `ggpp` dependency — its single `geom_label_npc()` call replaced with
      `geom_label(x = 0.02, y = Inf)`.
- [x] CRPS recycling bug in `run_scenario()` (`true_values` → `true_value`).
- [x] Layout: paper in `main/`, literature in `references/`, script at root.
- [x] `patchwork::wrap_plots()` instead of `+ plot_layout()` for the Fig 3/4
      grids, so the script works with ggplot2 4.x as well as 3.x.
- [x] No top-level plot auto-prints any more, so a headless run no longer dies
      on the default pdf device.
