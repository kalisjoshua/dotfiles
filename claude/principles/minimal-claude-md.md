# Minimal CLAUDE.md

The ruleset for editing and reviewing CLAUDE.md itself. Treat CLAUDE.md as always-on context with a high bar for entry: it holds only durable, cross-project principles, each a title, one short sentence, and a markdown link to its detail file — nothing more.

**Why:** Every line of CLAUDE.md is injected into every session, in every project. It is a standing tax on the context window, so verbosity here is paid for continuously and forever. A terse index keeps the always-loaded cost near-zero while the depth stays one click away, loaded only when a task makes it relevant.

**How to apply:**

- One line per principle: `- **[Title](principles/slug.md)** — single sentence.` Push all explanation (Why / How to apply) into the linked detail file.
- Use markdown links `[text](path)`, never the `@path` import syntax — `@` auto-inlines the target into context every session, defeating the point.
- Raise the bar for what earns a CLAUDE.md entry: only durable, cross-project principles. Project-specific facts belong in per-project `memory/`, not here.
- When an entry's sentence starts growing or sprouts caveats, that is the signal to move the nuance into its detail file and shrink the line back down.
