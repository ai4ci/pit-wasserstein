---
class: task
id: integrate-jmlr-latex-style.md
title: Integrate JMLR LaTeX style file for the paper
status: todo
kind: paperFix
priority: high
touches:
- paper:main.tex
- paper:refs.bib
---
The JMLR template file `jmlr2e.sty` is already present in `vignettes/main/`. It uses `natbib` with the `plainnat` / `abbrvnat` bibliography styles, both of which require `journal` and `year` fields.

The current `refs.bib` uses these standard BibTeX fields (confirmed 26 entries with `year`, 0 with BibLaTeX `journaltitle` or bare `date`). The field mismatch from the previous `unsrturl.bst` export is resolved.

## Steps

1. **Switch from `unsrturl.bst` to the JMLR style in `main.tex`:**
   - Replace `\usepackage[numbers]{natplain}` + `\bibliographystyle{unsrturl}` with `\usepackage{jmlr2e}`
   - Keep `\bibliography{refs}`
   - Verify the title/author/abstract block matches JMLR conventions (the .sty provides the template)
2. **Compile and verify** — `pdflatex main` → `bibtex main` → `pdflatex main` → `pdflatex main` should produce a clean PDF with no BibTeX warnings.
