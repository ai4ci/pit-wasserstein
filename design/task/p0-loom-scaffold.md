---
class: task
title: "P0 loom scaffold"
status: done
priority: high
phase: P0
tags: [meta, loom]
---

# Goal

Govern the design records with loom: a document model, index pages that render
the live state, and the existing prose converted into instances so nothing is
lost.

Done: `design/document-model.mmd`, `design/doc/INDEX.md`, `design/doc/scope.md`,
`design/doc/priorities.md`, `design/doc/active-issues.md`, two ADRs, five
roadmap tasks (P0–P4), seven `issue` instances, and empty `design/metric/`,
`design/figure/`, `design/resource/` roots. `README.md` and `AGENTS.md` are
re-pointed.

`loom model check` → 0 errors, 0 warnings. `loom validate` → 18 instances, 0
errors. `loom render` → all five views populated.

# Remaining

1. Commit, so the repo-level link store records these URIs before any branch
   switch.
2. Decide whether `metric`/`figure` should be seeded now rather than in P3 — the
   two views render `_(no results)_` until they are.

Resolved while finishing: `design/VALIDATION.md` and `Rplots.pdf` are now
ignored. `design/.loom/namespaces.ttl` turns out to be **meant** to be committed
(`LOOM_IGNORED = ["db/", "VALIDATION.md"]` — only the derived databases are
excluded, so generated state that must agree with the model travels with the
branch), so nothing else to ignore.

# Things the engine corrected during this pass

Recorded because they contradict a plausible-looking model and would silently
produce a broken scaffold:

- `%% @view NAME` SQL must be on `%%` continuation lines. Bare indented SQL is
  parsed as mermaid (`model/syntax`, 48 errors).
- View names match `[A-Za-z_][A-Za-z0-9_]*` — `open-issues` renders as
  `Unknown view` rather than erroring, so the mistake is invisible until you read
  the output.
- Markdown is attributed to the **first** class root that contains it, so a `doc`
  root at `design/` swallowed `adr/`, `task/` and `issue/`
  (`instance/class-mismatch` + `instance/unknown-key` × 66). Hence `design/doc/`.
- mermaid `A <|-- B` makes **B** the child. `rcode <|-- src` made `src` inherit
  from `rcode`.
- Reserved-family classes (`src`, `resource`) forbid attributes
  (`model/reserved-has-attributes`), so a code subclass can never satisfy
  `model/no-title-attribute`. Target `src` itself.
