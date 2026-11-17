---
class: task
id: citation-keys-do-not-match-refs-bib.md
title: Synchronize loom citeKeys with generated refs.bib
status: done
kind: issue
priority: high
touches:
- paper:main.tex
- paper:refs.bib
---
Pre-existing, found while reviewing the Zotero collection. Nothing in `vignettes/main/main.tex` resolves against `vignettes/main/refs.bib`:

* `main.tex` cites nine keys in a lowercase scheme — `anderson1996`, `bosse2023`, `bosse2024`, `brocker2008`, `brockwell2007`, `david1948`, `gneiting2007`, `hamill2001`, `panaretos2019` — inherited from the R_t paper.
* `refs.bib` holds Zotero-style keys only (`Brockwell_2007`, `Hamill_2001`, `Gneiting_Balabdaoui_Raftery_2007`, …), so every `\\cite` is unresolved.
* Four of the cited keys have no entry in `refs.bib` at all: `anderson1996`, `bosse2023`, `brocker2008`, `david1948`.
* Separately, `vignettes/main/main.blg` reports `I couldn't open style file unsrturl.bst`, and `main.bbl` is 0 bytes — the bibliography is not being built even before the key mismatch bites.

Suggested fix: settle on the Zotero key scheme (it is what the `reference` instances record in `citeKey`), rewrite the `\\cite` commands in `main.tex`, add the four missing works to `refs.bib` via Zotero, and either install `unsrturl.bst` or switch `\\bibliographystyle` to one TeX Live ships.


## Update 2026-11-13

installed `unsrturl`

```
sudo apt install texlive-bibtex-extra
kpsewhich unsrturl.bst
/usr/share/texlive/texmf-dist/bibtex/bst/urlbst/unsrturl.bst
```


## Resolution 2026-11-16

The user regenerated `refs.bib` with Better BibTeX using lowercase
first-author + year keys. The nine `main.tex` citations now all resolve, and
`main.bbl` is non-empty (3511 bytes); `unsrturl.bst` is installed. All 21
loom reference records now use keys that exactly match entries in the
regenerated bibliography. Four older bibliography entries (`anderson1996`,
`bosse2023`, `brocker2008`, `david1948`) do not have loom reference records;
they were not part of this key-synchronisation request.

This task is complete for cite-key resolution and bibliography generation.
A separate issue was filed for the remaining BibTeX/Better BibTeX field
compatibility warnings: `date` and `journaltitle` are not recognised by the
current BibTeX style, so years and journal names are omitted from the rendered
bibliography. The generated `refs.bib` must be corrected at its Zotero /
Better BibTeX source, not hand-edited.
