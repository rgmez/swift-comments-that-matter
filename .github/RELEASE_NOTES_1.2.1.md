## Summary

- Polishes WWDC26 coverage added in v1.2.0 without changing install paths or adapter entrypoints.
- Adds `Observation:` as an explicit comment signal, matching the examples already introduced for implicit framework dependency reads.
- Expands modern examples for compiler-enforced isolation, ownership/lifetime, compatibility fallbacks, and diagnostic exceptions with removal conditions.
- No breaking changes.

## Why this release

- v1.2.0 added the larger modern Swift taxonomy; this patch tightens the edges so every new concept is easier to discover and apply during Swift reviews.
- The update makes the "compiler/tests before comments" rule more concrete by showing when prose should defer to actor isolation, ownership/lifetime boundaries, and scoped compatibility exceptions.

## Compatibility notes

- No breaking changes.
- Existing install paths, adapters, standard paths, and portable `SKILL.md` package layout remain valid.
- Existing v1.2.0 guidance remains valid; this release adds coverage polish and additional examples.

## Test plan

- [x] Validate standard references resolve
- [x] Type-check `modern-contracts.swift`
- [x] Validate mirrored `standards/` and `skills/` docs/examples remain in sync
- [x] Run markdownlint with the repository config
- [x] Run `git diff --check`
