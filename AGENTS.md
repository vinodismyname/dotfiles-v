# Repository Guidelines

## Project Structure & Module Organization

This repository is a macOS-only Dotbot-based dotfiles setup. The main entrypoints are `installer` for a fresh clone/install flow and `main/install` for local setup. Dotbot link rules live in `main/install.conf.yaml`.

- `dot_zsh/` contains Zsh startup files, `_zsh/config/`, `_zsh/functions/`, and plugin submodules.
- `dot_config/` mirrors files linked into `~/.config/`, including `ada/`, `atuin/`, `btop/`, `lazydocker/`, and `zellij/`.
- `dependencies/` stores the macOS Homebrew bundle manifest: `mac.Brewfile`.
- `scripts/` contains macOS and optional setup helpers.
- `dotbot/` is a vendored submodule; avoid changing it unless intentionally updating upstream Dotbot.

## Build, Test, and Development Commands

- `git submodule update --init --recursive` fetches Dotbot and shell plugin submodules.
- `./main/install dry-run` previews the interactive setup without linking or installing.
- `./main/install verbose` runs setup with verbose Dotbot output.
- `brew bundle --file=dependencies/mac.Brewfile` installs macOS Homebrew packages.
- `./installer` performs the full bootstrap flow, including cloning this repo into `$HOME/_dotfiles`.

## Coding Style & Naming Conventions

Use Bash with `#!/usr/bin/env bash`, `set -euo pipefail`, quoted variables, and small helper functions. Shell functions use `snake_case`, for example `confirm_action`. Use two-space indentation in shell, YAML, TOML, and KDL config. Helix is the default terminal editor and should be referenced as `hx` in shell/editor settings.

## Testing Guidelines

There is no dedicated test suite for the local dotfiles. Before opening a PR, run `bash -n installer main/install scripts/*.sh`, `zsh -n dot_zsh/.zshenv dot_zsh/.zshrc dot_zsh/_zsh/config/*.zsh dot_zsh/_zsh/functions/*.zsh`, `ruby -c dependencies/mac.Brewfile`, and `git diff --check`. For link changes, run `./main/install dry-run` first, then test on macOS. Dotbot's own tests live under `dotbot/tests/` and can be run from `dotbot/` with `hatch test` when changing the submodule.

## Commit & Pull Request Guidelines

Recent history uses short, direct commit subjects such as `Sync mac dotfiles`. Keep commits imperative and scoped, for example `Update zellij layout`. PRs should describe the platform affected, list manual validation commands, and include screenshots only for visible terminal, editor, or window-manager changes.

## Security & Configuration Tips

Do not commit secrets or machine-local overrides. `dot_zsh/.zshrc.local` is intentionally ignored and sourced by local shell config. Review AWS/ADA profile changes carefully before sharing logs or credentials.
