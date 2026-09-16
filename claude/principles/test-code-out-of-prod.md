# Test code stays out of production output

Code that exists only for tests — mock/fake helpers, `Mock*`/`*ForTesting`
functions, test hooks, canned fixtures — must not live in a package that
production code imports.

## The rule

Put test-support code in a package outside the production import graph:
`testutil`, `footest`, `fake`. Production packages export only the minimal
legitimate surface tests need — a constant, an interface, a constructor —
never the test convenience built on it.

## Go mechanics

- `_test.go` files cannot be imported by other packages, so a helper shared
  across packages' tests must live in some normally-compiled package. That is
  an argument for a dedicated test-support package, not for parking the
  helper in the prod package.
- The stdlib models the idiom: `httptest`, `iotest`, `fstest` are separate
  packages beside the prod ones.
- Linker dead-code elimination usually strips unreferenced helpers from
  binaries, so the harm is API surface and hygiene, not bytes — the rule
  still holds.

## Precedent trap

An existing codebase may already park mocks in prod packages (precedent).
Match the fix to the moment: new code follows this rule even beside old
counterexamples; migrating the counterexamples is its own change, not a
rider.

Origin: Joshua, 2026-08-31, reviewing a `Mock*ForTesting` helper left in a
production `feature_flags` package; moved to `testutil` in a follow-up pass.
