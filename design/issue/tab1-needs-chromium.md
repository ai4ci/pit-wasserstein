---
class: issue
title: "tab1-params.pdf cannot be faithfully re-rendered outside the author's machine"
status: open
severity: minor
ownership: preExisting
raised: 2026-09-11
tags: [reproducibility, fonts]
---

# Symptom

`.hux_save_as()` renders the table HTML → Chromium → PDF. In the scoder sandbox
that produced a table 20pt taller than the committed one, embedding Noto Sans
and Times New Roman as fallbacks next to Roboto. The committed PDF was therefore
left untouched (its content does not depend on the CRPS fix).

# Suggested fix

Either commit the HTML/CSS source of the table and pin the fonts, or generate
the parameter table with LaTeX (`booktabs`, already loaded in `main.tex`) so it
does not depend on a browser at all. The latter also removes a Chromium
dependency from CI.
