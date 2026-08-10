<div align="center">

# maptic/tap

**Homebrew tap for [maptic](https://github.com/maptic) apps and tools.**

[![CI](https://github.com/maptic/homebrew-tap/actions/workflows/ci.yml/badge.svg)](https://github.com/maptic/homebrew-tap/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](./LICENSE)

</div>

## Install

```sh
brew tap maptic/tap
brew install --cask mounty
```

Or in one step, without tapping first:

```sh
brew install --cask maptic/tap/mounty
```

Upgrading follows the usual Homebrew flow:

```sh
brew upgrade --cask mounty
```

### Brewfile

```ruby
tap "maptic/tap"
cask "mounty"
```

> [!NOTE]
> Homebrew asks you to trust a third-party tap before it loads anything from it. In a script or CI
> run, where there is nobody to answer the prompt, trust it up front:
>
> ```sh
> brew trust --tap maptic/tap
> ```

## What's in here

| Cask                            | Description                                                        |
| ------------------------------- | ------------------------------------------------------------------ |
| [`mounty`](./Casks/mounty.rb)   | macOS menu-bar app that keeps SMB network shares mounted — [source](https://github.com/maptic/mounty) |

## How releases land here

Casks are **never bumped by hand**. Each source repository releases through
[release-please](https://github.com/googleapis/release-please); when its release workflow has
uploaded the artifacts it sends a `cask-release` [`repository_dispatch`](https://docs.github.com/en/rest/repos/repos#create-a-repository-dispatch-event)
to this tap. The [Update cask](./.github/workflows/update-cask.yml) workflow then renders the
download URL from the cask itself, downloads the asset, computes its `sha256`, and commits the
bump to `main`.

```
maptic/mounty                                   maptic/homebrew-tap
─────────────                                   ───────────────────
conventional commits
      │
      ▼
release-please ──► GitHub Release (X.Y.Z)
      │
      ▼
release build ──► signed DMG + sha256 asset
      │
      └── repository_dispatch: cask-release ──► update-cask ──► chore(mounty): update cask to X.Y.Z
                                                                        │
                                                                        ▼
                                                                    CI: brew style + audit
```

The checksum is deliberately recomputed here rather than trusted from the dispatch payload, so the
tap always attests the bytes it actually publishes.

## Contributing

Commit conventions, layout, and local validation commands are documented in
[`AGENTS.md`](./AGENTS.md). Run the hooks installer once after cloning:

```sh
./scripts/install-hooks.sh
```

## License

[MIT](./LICENSE) © Merlin Unterfinger / maptic
