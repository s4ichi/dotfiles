# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this directory.

この cookbook は、この dotfiles リポジトリを Claude Code のローカル plugin marketplace（名前 `s4ichi`）としてホストする。使い方・追加手順・開発ループの詳細は [README.md](./README.md) を参照。ここでは編集時に守る規約を示す。

## 構造と名前

- marketplace 名 = `s4ichi`。plugin は `files/plugins/<name>/`（各 `.claude-plugin/plugin.json` を持つ）。skill は `files/plugins/<name>/skills/<skill>/SKILL.md`。
- 呼び出し名: plugin 完全修飾は `<plugin>@s4ichi`、skill は `/<plugin>:<skill>`（例: `/s4ichi:commit`）。
- `.claude-plugin/` にはマニフェスト（marketplace.json / plugin.json）だけを置く。`skills/` 等は plugin root 直下。

## 必ず守ること

- **2 つの marketplace.json を同期させる**。github 直インストール用の repo ルート `.claude-plugin/marketplace.json` と、ローカルパス登録用の `files/.claude-plugin/marketplace.json` は、`plugins[]` の内容を一致させる。**唯一の差は plugin の `source` 相対パス**（ルート用 `./cookbooks/claude-marketplace/files/plugins/<name>`、files 用 `./plugins/<name>`）。plugin を増減したら両方を更新する。
- **version は書かない**（plugin.json / marketplace entry とも）。git SHA / ライブ参照ベースで更新検出させる方針。明示リリースが要るまで入れない。
- **plugin は self-contained に保つ**。`../` で plugin ディレクトリ外を参照しない（install 時に cache へ copy されると壊れる）。skill 間で共有する参照ドキュメントは `${CLAUDE_PLUGIN_ROOT}/...` の絶対参照で読み込む（例: `commit` と `pull-request` はともに `${CLAUDE_PLUGIN_ROOT}/skills/commit/commit-style.md` を読む）。

## SKILL.md の言語規約

- frontmatter の `description` と本文は**日本語**で書く。`argument-hint` は、リテラルな引数トークンならそのまま（例 `[split]` `[message-only]`）、文なら日本語にする。
- `name` は識別子なので**英語のまま**（呼び出し名になる）。
- 次のものは翻訳せず**原文のまま維持**する: git / gh などのコマンド、コミットメッセージの例・prefix・動詞キーワード（`fix` `avoid` `extract` など）、技術識別子、コードブロック、`$ARGUMENTS` や `Co-Authored-By` 等のリテラル。
  - 要するに「Claude への指示は日本語、成果物として出力される英語（コミット文面など）は英語」。

## plugin / skill を足すとき

- **skill 追加のみ**なら `files/plugins/<plugin>/skills/<skill>/SKILL.md` を作るだけ。マニフェスト変更は不要。
- **plugin 新設**なら `files/plugins/<name>/.claude-plugin/plugin.json` を作り、**両 marketplace.json** の `plugins[]` と `default.rb` の `node[:claude_marketplace][:plugins]` に追加する。
- 変更後は開発ループで確認: `claude --plugin-dir cookbooks/claude-marketplace/files/plugins/<name>` → `/reload-plugins`。

## レシピ（default.rb）の注意

- mitamae の `execute` は `environment` メソッドを持たない。環境変数はコマンド文字列にインラインで渡す（`HOME='#{home}' claude ...`）。`user` は使用可。
- `claude` CLI をユーザー権限で実行し、冪等性は `known_marketplaces.json` / `installed_plugins.json` の grep（`not_if`）で担保。`only_if "command -v claude"` で未導入マシンは skip。
