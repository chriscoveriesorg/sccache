# Sccache's proposed quick/full conversion

This is a draft-only source proposal for the fork's `ci.yml`. Keep the PR
draft until independent review and the signed activation gates are ready.
This source does not edit live configuration, cron, capacity or caches, and
it does not post anything upstream.

The fork owns its CI layer — `.github/` was authored in fork commit
`61dedf7` and the fork carries local patches on top of upstream — so the
conversion stays inside fork-owned CI. This is a public repository: every
runner label is unchanged (`ubuntu-latest`, `macos-*`, `windows-*`, the
FreeBSD VM leg). No Cifast/GARM labels are introduced.

The caller uses a local byte-exact copy of Cifast's tier action from
reviewed commit `f108f046392578027d957a15175edee3542d34f4`.

Trigger boundary: `pull_request` runs the quick tier; `push` to canonical
`batch/**` branches runs full; `push` of `v*` tags is preserved so the
`release` job (tag-gated, `needs: [build, lint, test]`) keeps its artifact
pipeline. On tag pushes the tier step is skipped by its event guard and the
jobs run exactly the steps they run today. Branch pushes outside `batch/**`
no longer trigger CI — the same trade every Option C conversion makes.

Quick tier on a PR: `lint` (full OS×component matrix — clippy/rustfmt are
already bounded), `check_features` (7 storage backends), `toml_format`, and
the new `quick-test` job (`cargo test --locked --lib --bins` on
`ubuntu-latest`, `CARGO_INCREMENTAL=0`, 20-minute bound). The heavy legs —
`test` (OS×rustc×CUDA matrix with coverage), `build` (cross-compile matrix),
`test_freebsd` (70-minute VM leg) — are `push`-only and run unchanged on
batch and tag pushes. `release` is untouched.

Every existing job name, matrix, timeout and step is preserved; the only
additions are the `pinned tier setup` step, job-level `if:` guards, the
`quick-test` job, and the trigger narrowing. Per repository AGENTS.md the
agent keeps PR descriptions short and in the repository's own words.

`profiles/sccache-batch.toml` is a concrete proposed enrollment, not an
installed profile. It binds the caller's exact full job/steps (the six
push-running jobs; `quick-test` is PR-only and `release` is tag-only, so
neither appears in a batch run) and all local action/setup entrypoints.

Before activation retain independent review and a complete first-attempt
full proof of an exact current-base bootstrap tip — note the full tier is
the entire upstream matrix and will take hours on hosted runners.
