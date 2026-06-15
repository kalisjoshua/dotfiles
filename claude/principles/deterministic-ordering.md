# Deterministic code ordering

In React-style components, destructure props/state at the top of the component body, above the hooks — it is foundational parameter-unpacking, not a "derived value" to push below the hooks.

**Why:** Demoting destructuring below hooks is unidiomatic and can cause use-before-declare — e.g. a `useMemo` that consumes the destructured `tree`/`state` would reference it before the line that defines it.

**How to apply:**

- Keep destructuring as the first internal-layout section.
- When a component's props list is long enough to wrap the function declaration line, destructure off a single `props` param on the first body line rather than in the signature.
- The full rules live in `~/.claude/skills/deterministic-ordering/SKILL.md`.
