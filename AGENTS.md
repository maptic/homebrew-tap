# AGENTS.md

> **Single source of truth for all AI coding agents** working on `maptic/homebrew-tap` — Claude,
> GPT/Copilot, Cursor, Gemini, and any other assistant. Tool-specific files (`CLAUDE.md`) are thin
> pointers to this file. Keep this file up to date; do not duplicate its content elsewhere.

## Repository overview

This is the Homebrew tap of the **maptic** organization: `brew tap maptic/tap`. It ships casks for
maptic's macOS apps. It contains **no application code** — only cask definitions and the automation
that keeps them current.

```
homebrew-tap/
├─ Casks/
│  └─ mounty.rb                      # one file per app, token == file name
├─ .github/workflows/
│  ├─ ci.yml                         # brew style + brew audit (offline & online)
│  └─ update-cask.yml                # repository_dispatch "cask-release" → version + sha256 bump
├─ .githooks/                        # conventional-commit + cask style hooks
└─ scripts/install-hooks.sh
```

## The golden rule: casks are not edited by hand

`version` and `sha256` are owned by [`update-cask.yml`](./.github/workflows/update-cask.yml).
A source repo (e.g. [`maptic/mounty`](https://github.com/maptic/mounty)) fires a
`repository_dispatch` after its release build has uploaded the artifacts:

```jsonc
{ "event_type": "cask-release", "client_payload": { "cask": "mounty", "version": "1.2.1" } }
```

The workflow renders the URL from the cask's own `url` stanza, downloads the asset, computes the
checksum, and pushes `chore(<cask>): update cask to <version>` to `main`. Never bump a version in a
PR — if a bump is missing, re-run the workflow instead:

```sh
gh workflow run update-cask.yml -R maptic/homebrew-tap -f cask=mounty -f version=1.2.1
```

Hand edits are for everything else: `desc`, `depends_on`, `zap`, `livecheck`, new casks.

## Adding a cask

1. Create `Casks/<token>.rb`. The token is lowercase, hyphenated, and matches the file name. Check
   `brew info --cask <token>` first: if `homebrew/cask` already owns that token, the tap's cask is
   only reachable fully qualified (`maptic/tap/<token>`), and every doc and Brewfile entry must say
   so — `mounty` is exactly this case.
2. Stanza order (rubocop-cask enforces it): `version`, `sha256`, `url`, `name`, `desc`, `homepage`,
   `livecheck`, `depends_on`, `app`, `uninstall`, `zap`.
3. The `url` **must** interpolate `#{version}` — the update workflow relies on that template.
4. `desc` is a sentence fragment: no leading article, no trailing period, ≤ 80 characters.
5. Add a `livecheck` block so `brew livecheck` and `brew bump-cask-pr` keep working as a fallback.
6. Give the source repo a dispatch step pointing at `event_type: cask-release`, and list the cask in
   the README table.

## Validate locally

```sh
brew style maptic/tap                                # rubocop-cask, matches CI
brew audit --cask --strict maptic/tap/<token>        # offline audit
brew audit --cask --online --strict maptic/tap/<token>  # also verifies URL + sha256
brew install --cask maptic/tap/<token> && brew uninstall --cask <token>
```

To work against your checkout instead of the published tap, symlink it into Homebrew:

```sh
ln -s "$PWD" "$(brew --repository)/Library/Taps/maptic/homebrew-tap"
```

## Commits (Conventional Commits)

Every commit and every PR title MUST follow
[Conventional Commits](https://www.conventionalcommits.org/): `<type>[(scope)][!]: <description>`.
Types: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
The scope is the cask token when a change targets one cask (`chore(mounty): …`). This tap is not
versioned or released — the convention exists for a readable history and shared tooling with the
app repositories.

### Mandatory model attribution for agent commits

Any commit you create as an AI agent MUST include a `Generated-by:` git trailer naming the exact
model id. This is the **only** attribution trailer needed — do **not** add `Co-Authored-By:` or
any similar trailer. The human user is the author; the model is a tool.

```
feat(mounty): add zap stanza for saved application state

Generated-by: claude-opus-5
```

Use your real model id (`claude-opus-5`, `gpt-5`, `gemini-2.5-pro`, …). This is provider-neutral.
The `commit-msg` hook validates the format when the trailer is present.

## Guardrails

- Keep changes scoped to the request; don't refactor unrelated casks.
- Never commit secrets or tokens. The cross-repo bump uses `HOMEBREW_TAP_TOKEN`, a fine-grained PAT
  stored **in the source repository's** secrets with `contents: write` on this repo only.
- Never weaken checksum verification (`sha256 :no_check`) to make a build pass.
- **Never include personal contact information** (email addresses, phone numbers, social handles)
  in any file you create or modify. If you need to attribute a maintainer, use their GitHub
  username, never a private email address.
