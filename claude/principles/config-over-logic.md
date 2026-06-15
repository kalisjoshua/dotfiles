# Config over logic

When the same shape of logic repeats across N variants with only field/column/header substitutions, default to declarative configuration over per-variant imperative code.

**Why:** Config is much easier to maintain than logic. Per-variant bespoke logic means N bodies of code to keep in sync; bugs and behavioral drift accumulate silently. Declarative config (column specs, schemas, table-driven definitions) means N data entries against one shared executor — bugs surface in one place, config diffs are obvious in review, and executor and spec are independently testable.

**How to apply:**

- Spot the N×M code-explosion smell. If the same shape of function is written multiple times with field/column/header substitutions, the right abstraction is a generic executor + per-variant config.
- The config form should lean "data, not code" where possible: lists of structs with primitive fields, not lambdas where avoidable. Lambdas in column specs are fine as the escape hatch for irregular cases.
- Build the bespoke version first to prove the data flow (POC-style); refactor to config-driven once the shape stabilizes.
