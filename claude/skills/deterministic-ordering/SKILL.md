---
name: deterministic-ordering
description: Apply the deterministic code ordering to files in the current PR's diff.
---

# Code order

Apply this ordering to every source file modified in the current PR (`git diff @{u}`). Imports are tool-managed — do NOT touch them.

**Never add code comments that reference this skill, the ordering, or the reasoning for a declaration's placement** (e.g. no `// moved to root per ordering` or `// destructured above hooks to avoid use-before-declare`). The reordering should be invisible in the final code — leave only the code itself.

The rules below are language-agnostic in spirit. Some sections name TypeScript/React constructs (`interface`, JSX, hooks, Aphrodite) — **apply each section only where that construct exists in the language**, and map it to the nearest equivalent (e.g. a `type`/`interface` rule applies to a struct, class, or type alias; "object-literal keys" applies to dict/map/struct literals). Skip sections that have no equivalent. The core principle holds everywhere: declarations and keys go in alphabetical order **unless** ordering is semantic.

## Sort order

"Alpha by name" throughout this skill means **case-insensitive** alphabetical order: lowercase the name before comparing, so `hello` sorts before `HelloWorld` and `apiKey` before `Apple`. Case is ignored for the primary comparison; do not group all capitalized names ahead of all lowercase ones.

For ties that differ only in case, the tiebreak is **capitalized before lowercase** (e.g. `Hello` before `hello`). Apply this consistently every time — do not fall back to the original source order.

## Module-root order (after imports)

1. Type declarations (`interface`, `type`, and equivalents like structs/type aliases) — alpha by name.
2. Constant / top-level value declarations (`const` and equivalents) — alpha by name.
3. Function declarations — alpha by name.

Types belong at the module root, not nested inside functions or components. Hoist any `type`/`interface` declared inside a function body up to module scope and slot it into the alpha-ordered type block. **Exception:** a local type that references the enclosing function's generic type parameters (or other in-scope type variables) cannot be hoisted — leave it where it is.

## Object-literal keys

Alpha order:
- Aphrodite `StyleSheet.create({...})` keys.
- Interface / type members.
- Plain object literals **without spreads** (see "Do not reorder" below).

## JSX props

Alpha order on every component's attributes, **except** when a spread (`{...x}`) is present — preserve original order in that case.

## Component prop destructuring

If a component's props list is long enough to make the function declaration line wrap, do **not** destructure in the parameter signature. Instead take a single `props` parameter and destructure off it on the first line of the function body:

```tsx
// Avoid — wrapped destructuring in the signature:
function Foo({
    alpha,
    bravo,
    charlie,
}: Props) {

// Prefer — single param, destructure as the first body line:
function Foo(props: Props) {
    const {alpha, bravo, charlie} = props;
```

The destructured names follow the standard alpha order ("Sort order" above). When the props list is short enough to fit on one unwrapped line, signature destructuring is fine — leave it.

## Component-internal layout

Inside a function/component body, the sections appear in this order:

1. **Prop / state destructuring** — unpacking of `props` (and any `state`) at the very top of the body. This is foundational parameter-unpacking, **not** a derived value, so it stays above the hooks even when a hook consumes it — pushing it below would be unidiomatic and can cause use-before-declare (e.g. a `useMemo` that reads the destructured `tree`/`state`). Alpha by name.
2. **Hooks** — `useState`, `useReducer`, `useEffect`, `useMemo`, `useCallback`, custom hooks. Within a contiguous block, group by hook kind. Within a group, alpha by variable name **only if** no hook depends on a hook below it (React requires stable call order; reordering can break dependency chains).
3. **Derived values** — non-hook `const` lines. Alpha by name.
4. **Handlers** — local function/arrow declarations called from JSX. Alpha by name.
5. **Render** — the `return` block. Always last.

## Do not reorder

Reordering changes behavior in these cases. Leave the original order:

- Object literals with a spread (`{...defaults, override: true}`) — the spread's position matters.
- JSX with a spread prop — same rule.
- Hooks where a later hook's deps reference an earlier hook's result — re-ordering reorders the call sequence (illegal per React rules).
- Switch/if branches and `case` clauses — control flow.
- Array literals — order is semantic.

## Do not touch

Skip these files entirely — leave their ordering as-is:

- Test files — any extension matching `*.test.*`, `*.spec.*`, `*_test.*`, `test_*.*`, or anything under a `__tests__/`, `tests/`, or `test/` directory.
- Storybook files — `*.stories.*` and anything under `.storybook/`.

## Apply

1. Edit only files in `git diff @{u} --name-only`, excluding the test and Storybook files listed under "Do not touch".
2. After each file batch, run the project's format / lint / type-check commands and confirm they pass. Use whatever the repo defines (check `package.json` scripts, `Makefile`, `justfile`, etc.) — e.g. `pnpm fixc; pnpm linc; pnpm typecheck` for this project.
3. For stacked PRs: apply at the earliest branch in the stack that touches each file; later branches inherit via rebase.
