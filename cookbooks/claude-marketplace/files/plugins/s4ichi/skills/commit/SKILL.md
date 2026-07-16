---
name: commit
description: コミットスタイル規約に従って git コミットを作成する。
argument-hint: "[split]"
---

`${CLAUDE_PLUGIN_ROOT}/skills/commit/commit-style.md` を読み込み、その規約に正確に従うこと — subject 行のスタイル、prefix パターン、文脈を伴う動詞、小文字の命令形、body のガイドライン。

## 手順

staged / unstaged の全変更を確認し、git コミットを作成する。

$ARGUMENTS

### 引数に "split" が含まれる場合

変更を論理的で粒度の細かい単位に分けてコミットする。各コミットは単一のタスクまたは機能単位を表すこと。どのコミット時点でもコードベースが安定してエラーなく動作する状態を保ち、壊れている・実行に失敗するコードはコミットしない。

コミット前に、分割案（どのファイル / hunk をどのコミットに入れるか、subject 行の下書き付き）を提示し、承認を待つこと。

### それ以外の場合

全変更をまとめて単一のコミットにする。

## GPG 署名エラー

git commit が `gpg: signing failed: Inappropriate ioctl for device` で失敗した場合は、署名鍵のロック解除をユーザーに依頼すること。GPG 署名をスキップ・無効化してはならない。
