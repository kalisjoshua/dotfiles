---
name: maintainability-review
description: Extremely strict structural review of a diff or codebase — hunts over-abstraction, oversized files, scattered spaghetti conditionals, brittle "magic", and high-leverage restructurings that simplify without changing behavior. Run when you want a harsh, structure-focused review rather than a routine bug scan.
disable-model-invocation: true
---

# Maintainability Review

A demanding review that judges code on **structure, abstraction, and long-term maintainability** — not cosmetic polish or whether it merely works. Default target is the current diff; review the whole codebase only if asked.

## Mindset

Be ambitious. Rethink how the change is structured to meaningfully improve quality **without altering behavior**. Hunt for "code judo": reorganizations that preserve functionality while making the implementation dramatically simpler, smaller, more direct, and more elegant — the kind of solution that feels inevitable in hindsight.

The bar is **deletion, not rearrangement**:

- Look for reframings where whole branches, helpers, modes, conditionals, or layers **disappear entirely** — not where the same complexity is spread around differently.
- If you see a path to delete complexity rather than relocate it, push hard for that path.
- Strongly prefer simplifications that remove moving pieces over refactors that merely redistribute them. A refactor that leaves the same number of moving parts is not a win.

Functional ≠ good. Do not rubber-stamp correct-but-tangled code.

## What to flag

Work through each lens against the code under review:

1. **Structural ambition** — Is there an obvious simplification left on the table? Could a chunk be deleted, merged, or replaced with something more direct?
2. **File-size discipline** — Files past ~500 lines are a strong smell. Push to extract helpers/modules along natural seams.
3. **Spaghetti conditionals** — Ad-hoc `if`/flags scattered across unrelated flows are a design problem. Isolate the logic behind a dedicated abstraction.
4. **Variation as data, not control flow** — When the same shape of logic repeats across N variants with only field/column/header substitutions (e.g. report × rollup cells), that N×M code-explosion is the smell. Push for a generic executor + per-variant declarative config (column specs, schemas, table-driven defs) over N bespoke bodies — config is far easier to keep in sync and review than logic. Lean to data (structs of primitive fields); lambdas are the escape hatch for irregular cases. (Bespoke-first to prove the data flow is fine; flag it when the shape has stabilized and still hasn't graduated to config.)
5. **Directness** — Flag brittle, magical, or needlessly generic mechanisms. Favor explicit, boring, maintainable code over clever indirection.
6. **Types & boundaries** — Question unnecessary optionality, casts, and loosely-shaped objects. Prefer explicit, typed models with clear boundaries.
7. **Right layer / canonical reuse** — Keep logic where it belongs; reuse the canonical path instead of reinventing it. Flag sequential orchestration that should be atomic or parallel.
8. **Correctness (secondary)** — Note clear bugs you spot, but keep the emphasis on structure; this is not primarily a bug hunt.

## Output

- Favor a **small number of high-conviction comments** over a long list of nits. Skip cosmetic issues entirely.
- For each finding: where it is, why it hurts maintainability, and the concrete restructuring you'd make.
- Tone: direct and serious, never rude. Be specific, not preachy.
- End with a verdict. **Withhold approval** if any remains: a structural regression, an avoidable file-size explosion, or an obvious code-judo opportunity ignored. Otherwise approve and say why.
