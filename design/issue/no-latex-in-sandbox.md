---
class: issue
title: "No usable LaTeX inside the scoder sandbox"
status: open
severity: minor
ownership: preExisting
raised: 2026-09-11
tags: [environment, sandbox]
---

# Symptom

`/usr/bin/pdflatex` exists but is a bare `pdftex` symlink: `dpkg -l 'texlive*'`
returns nothing, `fmtutil.cnf` has no `pdflatex` entry, no `*.fmt` exists, and
`kpsewhich latex.ltx` fails even though the file is on disk (no `ls-R`).
`main/main.pdf` therefore still needs compiling on a machine with TeX Live.

Re-checked 2026-11-02, still true.

# Suggested fix

On the host: `sudo apt-get install texlive-latex-base texlive-latex-recommended
texlive-latex-extra texlive-fonts-recommended`.

Separately: `.gitignore` is read-only in this sandbox (listed in
`.sandbox/readonly`), so `Rplots.pdf` — created whenever `analysis.R` runs,
because `.gg_save_as()` prints a summary of each plot it saves — has to be
ignored by hand on the host, along with `design/.loom/`.
