---
name: pit-wasserstein-methodology
description: Procedures, URIs, lifecycle rules and validation steps for the design graph of the pit-wasserstein repository (loom document model with plan, task, reference, release, doc). Use when planning work, raising or closing an issue or paper fix, recording a release, summarising a cited paper, linking design records to R code, vignettes, the paper or its figures, or when `loom validate` / `loom render --check` fails here.
---

# pit-wasserstein methodology

This repository is governed by `loom` (npm `@ai4ci/loom-cli`), model at
`design/document-model.mmd`. For general CLI syntax see the `using-loom-cli`
skill; this skill is only what is specific to this repository.

Work flows **plan → task → release**. A `plan` states an intent and the
rationale; the `task` instances it `spawns` are the checklist; a `release`
records which tasks shipped. `reference` instances are summaries of papers held
in the `pit-wasserstein` Zotero collection and cited from the paper's
bibliography.

## 1. Classes, URIs and locations

| URI | Location | What it is |
|-----|----------|------------|
| `plan:<slug>.md` | `design/plan/` | An intent, and the rationale for it, before tasks exist |
| `task:<slug>.md` | `design/task/` | A unit of work: issue, paper fix, feature or chore |
| `reference:<slug>.md` | `design/reference/` | Summary of one published paper, keyed to `refs.bib` |
| `release:<slug>.md` | `design/release/` | What changed between software or paper versions |
| `doc:<name>.md` | `design/doc/` | Prose, including the generated `doc:INDEX.md` |
| `src:<file>.R[#symbol]` | `R/` | Package code; R files expose function anchors |
| `vignette:<file>.Rmd` | `vignettes/` | Figure-generating vignettes (file level only) |
| `paper:main.tex`, `paper:refs.bib` | `vignettes/main/` | Paper source (file level only) |
| `resource:<file>.pdf` | `vignettes/main/fig/` | Generated figures and tables |

Attributes: `plan` has `status` (draft, active, done, dropped) and `rationale`;
`task` has `status` (todo, doing, blocked, done, dropped), `kind` (chore,
paperFix, feature, issue) and `priority` (low, medium, high, critical);
`reference` has `citeKey`, `year`, `doi`, `zoteroKey`; `release` has `version`,
`kind` (software, paper) and `released`. Every class also has `title` and
optional `tags`.

Relations: `plan spawns task`, `plan informedBy reference`, `task blocks task`,
`task touches src`, `task produces resource`, `reference citedIn paper`,
`release includes task`.

## 2. Common operations

```bash
# a plan and its tasks
loom create plan:paper-rewrite.md "title=..." "status=active" "rationale=..."
loom create task:fix-figure-2-axis.md "title=..." "status=todo" "kind=paperFix" "priority=high"
loom link plan:paper-rewrite.md spawns task:fix-figure-2-axis.md

# point a task at what it touches (any src subclass satisfies `touches`)
loom link task:fix-figure-2-axis.md touches src:scoring.R#pit_w
loom link task:fix-figure-2-axis.md touches vignette:figure-2.Rmd
loom link task:fix-figure-2-axis.md touches paper:main.tex
loom link task:fix-figure-2-axis.md produces resource:fig2-pit-histograms.pdf

# a reference, keyed to the bibliography entry it summarises
loom create reference:wilks-2018-enforcing-calibration.md \
  "title=Enforcing calibration in ensemble postprocessing" \
  "citeKey=Wilks_2018" "year=2018" "doi=10.1002/qj.3185"
loom link reference:wilks-2018-enforcing-calibration.md citedIn paper:refs.bib

# prose: never hand-edit frontmatter or the generated link block
loom body set task:fix-figure-2-axis.md --file /tmp/prose.md
loom body append task:fix-figure-2-axis.md "

## Suggested fix

..."
```

Find the R anchor to link to with `loom ls src:scoring.R`; find what already
points at a symbol with `loom refs src:scoring.R#pit_w`.

## 3. Lifecycle rules

- A `task` starts `todo`. Move to `doing` only when nothing it is blocked by is
  still open: `loom query "SELECT subject FROM edge WHERE relation = 'blocks'
  AND object = 'task:<slug>.md'"`, then check each subject's status.
- A task with `kind: issue` or `kind: paperFix` should carry at least one
  `touches` link before it reaches `done`, so the fix is addressable.
- Close with `loom set task:<slug>.md status=done`. Never delete a task:
  `dropped` is the tombstone, and deleting breaks `release includes task`.
- A `plan` goes `done` only when every task it `spawns` is `done` or `dropped`.
- Record a `release` when the package version in `DESCRIPTION` or the paper
  version changes, and `includes` the tasks that shipped in it.
- A `reference` is created when a paper is read, not when it is cited; add
  `citedIn paper:refs.bib` once its `citeKey` exists in the bibliography.

## 4. Pre-commit checklist

```bash
loom model check     # only after editing document-model.mmd
loom rebuild         # always after a model edit; validate can pass on a stale graph
loom validate
loom render          # refresh design/doc/INDEX.md
loom render --check  # CI-safe: non-zero if any marker would change
```

## 5. Traps specific to this repository

- **No latex or bibtex grammar.** `loom ls paper:refs.bib` returns no entries;
  `main.tex`, `refs.bib` and every `.Rmd` address at **file level only**
  (`.Rmd` reports `source/unsupported-language`). Only `.R` files give symbol
  anchors. Per-paper granularity lives in `reference.citeKey`, not in a link.
- **`src` is rooted at `R/`, not the repo root.** Rooting it at `repo:/` makes
  every anchor canonicalise to the reserved `repo:` scheme and links fail with
  `graph/non-canonical-uri`. Each subclass has its own `%% @prefix`, and no two
  classes may resolve to the same directory (`path/collision`).
- **`loom render` rewrites every markdown file in the repository.** Never write
  a literal view marker in prose outside `design/` — not in `AGENTS.md`, not in
  `README.md`.
- `model/no-title-attribute` on `paper` is expected and unfixable: reserved
  families (`src`, `resource`) forbid attributes.
- **Never add a second file named `document-model.mmd` to the repository.**
  Loom discovers the model by filename, and a copy (e.g. under
  `.agents/skills/.../references/`) silently becomes the root: every URI then
  resolves beside the copy and `loom body`/`loom show` report
  `changeset/not-found` for files that plainly exist. The archived copy here is
  `document-model.example.mmd` for that reason.
- An attribute value containing `": "` is parsed as YAML and becomes a map
  (`instance/type-mismatch`). Quote it inside the assignment:
  `loom create reference:x.md 'title="Universal residuals: A transformation"'`.
- Links are stored at repository level, so commit design changes before
  switching branches or they appear to vanish.
