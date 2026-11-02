---
class: adr
title: "Design records are loom instances"
status: accepted
decided: 2026-11-02
tags: [meta, loom]
mandates: [task:p0-loom-scaffold.md]
---

# Context

`AGENTS.md` mandated `design/adr.md`, `design/scope.md` and
`design/active-issues.md`, and `README.md` pointed at `design/priorities.md` and
`design/active-issues.md`. Those four files mixed three kinds of thing in prose:
decisions, a roadmap checklist, and a numbered bug list. Nothing could answer
"which issues are open and what blocks P2" without reading all of them, and the
checklists had no way to be checked.

# Decision

Design records are loom instances governed by `design/document-model.mmd`: one
file per decision, task, issue, metric and figure, under `design/`.

The paths `AGENTS.md` named do **not** survive — a markdown file is attributed to
the class whose root contains it, so prose cannot sit at `design/*.md` beside the
class directories, and a `doc` root covering `design/` would swallow every `adr/`,
`task/` and `issue/` file below it. The four files became:

| Was | Now |
|---|---|
| `design/adr.md` | `design/adr/` — one file per decision |
| `design/scope.md` | `design/doc/scope.md` |
| `design/active-issues.md` | `design/doc/active-issues.md`, its list rendered from the `openIssues` view |
| `design/priorities.md` | `design/doc/priorities.md`, deferring to the `backlog` view |
| (nothing) | `design/doc/INDEX.md` — the five views in one page |

Code is addressed, not documented: the `src` family is rooted at the repo root,
so `src:analysis.R#pitw` works today and `src:R/metric-pit.R` after P2, with no
`rcode` subclass and no frontmatter in the R files.

# Consequences

- `AGENTS.md` and `README.md` are re-pointed at the new paths; the old paths are
  gone and must not be recreated (`design/VALIDATION.md` is generated, and prose
  at `design/*.md` would be attributed to whichever class root matched first).
- `loom validate` after every design edit, then `loom render` to refresh the
  views (`--check` in CI).
- `loom render` rewrites **every markdown file in the repository**, not just
  `design/`, so a literal view marker anywhere else is treated as a view to
  expand. Documenting the marker syntax has to describe it without writing it
  (`AGENTS.md` was mangled this way on 2026-11-02).
- Loom links are populated at **repository** level, not branch level, so design
  changes must be committed before switching branches.
- `design/.loom/db/` and `design/VALIDATION.md` are generated and ignored
  (`design/.loom/.gitignore` carries `db/` and `VALIDATION.md`; the report is
  written to `design/VALIDATION.md`, outside that directory, so it needs a repo
  `.gitignore` entry as well).
- `design/.loom/namespaces.ttl` is **committed on purpose** — loom ignores only
  `db/`, so that generated state agreeing with the model travels with the branch.
- Names that become SQL identifiers — relation names, attribute names, **view
  names** — are camelCase. `open-issues` is not a valid view name and renders as
  `Unknown view`.
