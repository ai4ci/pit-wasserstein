# Active issues

Pre-existing issues found during the layout/dependency rework. **Not fixed** —
each needs a decision from the author. Suggested fixes are indicative only.

## 1. Sample size of the validation simulation: paper says 10000, code uses 1000

`main.tex` (Validation) states the 1000 random configurations were each assessed
"based on 10000 simulated true value and probabilistic prediction pairs". The
two `run_scenario()` calls that produce Fig 3 and Fig 4 pass `true_value`, the
1000-element vector defined near the top of `analysis.R`; only the Fig 2
scenario grid uses the 10000-element `true_values`.

Pick one and make it agree:

- if the intention is 10000 pairs, pass `true_values` to both calls (and change
  the `n` in the `unbiased_percent_50_ci` beta adjustment, which currently
  silently uses the global `n = 1000`); or
- if 1000 is intended, change the two numbers in the Validation text.

Note this is what let the CRPS recycling bug stay invisible: with `true_values`
(10000) in scope, `crps_norm()` silently recycled the 1000-element estimate
vectors 10x and returned an inflated mean CRPS (~80% too high in a spot check).

## 2. Figures are not reproducible

`analysis.R` draws every scenario from `rnorm()`/`rlnorm()`/`runif()` with no
`set.seed()`, so re-running replaces published figures with a different draw.
Suggested fix: one `set.seed()` at the top of the script.

## 3. Sorting is implicit in the definition of $D^*_{pit}$

`eq:pit2` writes $D^*_{pit} = \frac{1}{n}\sum_i |rank_i - u_{i,adj}|$ where
$rank_i$ is ordered but $u_{i,adj} = F_i(X_{i,adj})$ is not stated to be sorted;
the code uses `sort(u)`. The earlier "assume $X_i$ ascending" convention only
implies sorted PIT values if the predictions are also ordered. Suggested fix:
write $u_{(i),adj}$ (order statistic notation) in `eq:pit2` and `eq:pit3`.

## 4. `tab1-params.pdf` cannot be faithfully re-rendered outside the author's machine

`.hux_save_as()` renders the table via HTML -> Chromium -> PDF. On this sandbox
that produced a table 20pt taller than the committed one, embedding Noto Sans
and Times New Roman as fallbacks next to Roboto, so the committed PDF was kept
unchanged (its content does not depend on the CRPS fix). Re-render it with your
own Chrome to be sure it is current.

## 5. No usable LaTeX in the scoder sandbox

`/usr/bin/pdflatex` exists but is a bare `pdftex` symlink: `dpkg -l texlive*`
returns nothing, `fmtutil.cnf` has no `pdflatex` entry, no `*.fmt` exists, and
`kpsewhich latex.ltx` fails even though the file is on disk (no `ls-R`).
`main.pdf` therefore still needs compiling on a machine with TeX Live, or here
via something like

```sh
sudo apt-get install texlive-latex-base texlive-latex-recommended \
     texlive-latex-extra texlive-fonts-recommended
```

Note `.gitignore` is read-only in this sandbox (listed in `.agentreadonly`), so
`Rplots.pdf` — created whenever `analysis.R` runs, because `.gg_save_as()` prints
a summary of each plot it saves — has to be ignored by hand.

## 6. Roboto is not installed system-wide in the sandbox

`systemfonts`/fontconfig find no Roboto, which makes every figure fail with
`invalid font type`. Roboto *is* bundled twice on the box; copying it to the
ephemeral user font dir is enough to render, and is what was done here
(`/home/scoder/.local/share/fonts/roboto` + `fc-cache -f`):

```sh
cp /usr/lib/R/site-library/rmarkdown/rmd/h/bootstrap/css/fonts/Roboto*.ttf \
   ~/.local/share/fonts/roboto/ && fc-cache -f ~/.local/share/fonts/roboto
```

## 7. patchwork 1.3.2 is incompatible with ggplot2 4.x

`ggplot + ggplot` now aborts with "Can't add `b` to a ggplot object" under
ggplot2 4.0.3, so the Fig 3/Fig 4 compositions were rewritten to use
`patchwork::wrap_plots(...)` instead of `+ plot_layout(...)`. `wrap_plots()`
works on both old and new patchwork, but if you would rather keep the `+`
style, install patchwork >= 1.4 or pin ggplot2 3.5.x.
