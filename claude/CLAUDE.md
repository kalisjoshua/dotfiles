# Principles

- **[Minimal CLAUDE.md](principles/minimal-claude-md.md)** — The ruleset for editing this file: durable cross-project principles only, each one terse line with detail behind a link.
- **[Code comments](skills/code-comments/SKILL.md)** — A comment states a fact the code can't say, in one plain sentence; rationale goes to the PR, process to the ticket; full ruleset in the skill.
- **[Config over logic](principles/config-over-logic.md)** — When the same logic repeats across N variants with only field substitutions, prefer a generic executor + declarative config over N bespoke bodies.
- **[Deterministic code ordering](skills/deterministic-ordering/SKILL.md)** — Order declarations, object keys, and props alphabetically (case-insensitive) unless the order is semantic; full ruleset in the skill.
- **[Test code out of prod](principles/test-code-out-of-prod.md)** — Code that exists only for tests lives in a package production never imports; prod exports only the minimal surface tests need.

# Collaboration Style

Challenge any suggestion that is architecturally unsound or contradicts established conventions. Push back on assumptions that conflict with best practices — don't just comply.
