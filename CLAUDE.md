# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles managed with [mitamae](https://github.com/itamae-kitchen/mitamae) (a standalone Ruby-less Itamae). Configuration is applied declaratively via recipes rather than a shell script that copies files. The actual dotfiles live under `config/` and are symlinked into `$HOME`; the recipes under `cookbooks/` and `roles/` describe how each tool is installed and linked.

## Commands

```sh
# Apply all recipes for the current platform
./bin/install

# Preview changes without applying them
./bin/install --dry-run

# Any extra args are forwarded to `mitamae local ... bootstrap.rb`,
# so mitamae flags work, e.g. verbose logging:
./bin/install --log-level=debug
```

`bin/install` runs `bin/setup` first (which downloads/verifies the pinned mitamae binary into `bin/`), then executes `bin/mitamae local bootstrap.rb` — with `sudo -E` on Linux, without sudo on macOS. There is no separate build/lint/test step; a `--dry-run` apply is the way to validate changes.

## Architecture

Execution flows: `bootstrap.rb` → role → cookbooks.

- **`bootstrap.rb`** — entry point. Defines the `include_cookbook` / `include_role` helpers (which resolve to `cookbooks/<name>/default.rb` and `roles/<name>/default.rb`), sets `node[:user]` and `node[:os]`, then `include_role node[:platform]` (`darwin` or `ubuntu`).
- **`roles/<platform>/default.rb`** — the per-OS manifest. Sets platform defaults via `node.reverse_merge!` and lists which cookbooks to include. `roles/base` is shared and pulls in `functions`. To enable/disable a tool on a platform, edit the `include_cookbook` list here.
- **`cookbooks/<tool>/default.rb`** — one recipe per tool: install the package/binary and link its config files.
- **`config/`** — the real dotfiles (`.zshrc`, `.gitconfig`, `.tmux.conf`, `.doom.d/`, etc.). Cookbooks symlink these into `$HOME`.

### Custom resource definitions (`cookbooks/functions/default.rb`)

Two project-specific mitamae `define`s are used throughout the cookbooks — read these before writing recipes:

- **`ln '.name'`** — symlinks `config/<source>` → `$HOME/<name>` (source defaults to name). This is the primary mechanism for installing a dotfile.
- **`github_binary 'cmd'`** — downloads a release archive from GitHub, extracts it (`.zip`/`.tar.gz`/`.tgz`), and installs the binary into `$HOME/bin`. Takes `repository`, `version`, `archive`, `binary_path`. Idempotent via `not_if "test -f <bin>"`.

### Conventions

- **Idempotency is manual.** Recipes guard side effects with `not_if`/`only_if` (e.g. checking a file exists, or comparing a stored sha). New recipes must do the same so re-running `./bin/install` is safe.
- **Node attributes** are set with `node.reverse_merge!` so defaults don't override values already set upstream (roles set them before including cookbooks). Pinned versions (e.g. fzf) live in these attribute blocks.
- **Machine-local, non-versioned config** is bootstrapped as empty/placeholder files with `not_if "test -e ..."` — e.g. `~/.gitconfig.local`, `~/.zsh/00-machine.zsh` — so per-machine secrets/overrides are never committed.
- **`bin/mitamae`** is a symlink to a checksum-pinned versioned binary managed by `bin/setup`; don't edit or commit changes to the downloaded binary.

### Notable cookbooks

- **`alfred-workflows`** (macOS) — zips each `<name>/` subdirectory into a `.alfredworkflow`, installs it via `open`, and skips rebuilds using a sha of the source files. Add a workflow by adding a subdirectory containing its `info.plist`.
- **`doom`** — links `config/.doom.d`; `bin/doom-install` bootstraps Doom Emacs itself.
- **`claude-marketplace`** — hosts this repo as a Claude Code plugin marketplace (name `s4ichi`). Plugins live under `cookbooks/claude-marketplace/files/plugins/<name>/` (each with `.claude-plugin/plugin.json`). Two catalogs list them, differing only in each plugin's relative `source`: the repo-root `.claude-plugin/marketplace.json` (for GitHub installs, `claude plugin marketplace add s4ichi/dotfiles`) and `cookbooks/claude-marketplace/files/.claude-plugin/marketplace.json` (for the local-path registration the recipe uses) — keep both `plugins[]` in sync. The recipe registers the local marketplace and installs plugins via the `claude` CLI (run as `node[:user]`, guarded by `command -v claude`). See its README for the layout and dev loop.
