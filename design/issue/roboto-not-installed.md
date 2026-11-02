---
class: issue
title: "Roboto is not installed system-wide in the sandbox"
status: open
severity: cosmetic
ownership: preExisting
raised: 2026-09-11
tags: [environment, fonts]
---

# Symptom

`systemfonts`/fontconfig find no Roboto, which makes every figure fail with
`invalid font type`.

# Status

Mitigated in this session: `$HOME/.local/share/fonts` is now granted by
`.sandbox/readonly` and `fc-list | grep -ci roboto` returns 18, so figures render
in the sandbox. The underlying gap remains — the grant covers the user font dir,
not a system-wide install, and the copied TTFs live at `~/.local/share/fonts/`
rather than being packaged.

# Suggested fix

Install Roboto system-wide, or have the figures declare a font that is
guaranteed present (and fail loudly with a named font rather than
`invalid font type`). `.gg_fonts_missing()` in
`src:R/import-standalone-ggplot-utils.R` (`.gg_fonts_missing`, line 317) already exists to check for this;
`analysis.R` does not call it.
