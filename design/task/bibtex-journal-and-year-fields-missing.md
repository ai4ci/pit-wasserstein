---
class: task
id: bibtex-journal-and-year-fields-missing.md
title: Better BibTeX fields are omitted by the paper bibliography style
status: done
kind: issue
priority: high
touches:
- paper:refs.bib
- paper:main.tex
---
The regenerated Better BibTeX `refs.bib` now has matching lowercase
first-author + year citation keys, and `main.bbl` is non-empty. However,
`main.blg` reports `empty journal` and `empty year` for the cited article
entries, and the rendered `.bbl` confirms that journal names and publication
years are omitted. The generated entries use BibLaTeX fields such as
`journaltitle` and `date`, while the paper currently uses a BibTeX style
(`unsrturl`) that expects `journal` and `year`.

Resolve this at the Zotero / Better BibTeX export configuration or by selecting
a compatible bibliography toolchain. Do not patch `refs.bib` directly: it is
generated and such edits will be overwritten.

Verified 2026-11-16: all `main.tex` citation keys resolve; the remaining
problem is displayed reference metadata, not missing citations or a failed
`.bbl` build.


## Update 2026-11-18

This should be fixed with a BetterBibtex BibTeX export.
