---
name: pull-request
description: コミット / PR スタイルに従って GitHub の pull request を作成する。
argument-hint: "[message-only]"
---

`${CLAUDE_PLUGIN_ROOT}/skills/commit/commit-style.md` を読み込み、その規約を PR のタイトルと説明に適用すること。

## 手順

$ARGUMENTS

### ステップ 1: ブランチを分析する

1. 現在のブランチ名とベースブランチ（main / master）を特定する。
2. 現在のブランチがプライマリブランチ（main または master）の場合は即座に停止し、どうするかユーザーに尋ねる。
3. `git log <base>..HEAD` と `git diff <base>...HEAD` を実行し、このブランチの全コミットを把握する。

### ステップ 2: タイトルと説明を作成する

タイトル: コミット subject 行と同じ規約に従う — 短く（70 文字未満）、小文字・命令形の動詞、文脈を伴う動詞、任意で `prefix:` パターン。末尾にピリオドを付けない。

説明:

- 単一コミットのブランチの場合: コミット subject をタイトルに、コミット body を説明に使う。コミットに body が無ければ、説明は空でも一文でもよい。
  - コミット body を PR 説明に取り込む際は、各段落内のハードラップされた行をつないで 1 行にする。コミットメッセージは約 72 文字で折り返されるが、GitHub は埋め込まれた改行を `<br>` として描画し、読みにくい段落になる。段落の区切り（空行）は残しつつ、連続する非空行はスペースで連結する。
- 複数コミットのブランチの場合: 簡潔な要約タイトルを書き、説明では個々のコミットを見出しや箇条書きで説明する。Markdown を自然に使う。

決して含めない:
- テスト手順、テスト計画、QA チェックリスト
- タスクリスト、TODO チェックボックス
- 「テスト方法」セクション
- 定型フッター（該当する場合の Co-Authored-By trailer は除く）

### ステップ 3: 作成または出力する

引数に "message-only" が含まれる場合:

作成したタイトルと説明を Markdown のフェンス付きコードブロックで出力して停止する。push も PR 作成もしない。

````
```markdown
Title: ...

---

Description body here...
```
````

それ以外の場合:

1. `git push -u origin HEAD` でブランチを origin に push する。
2. `gh pr create --title "..." --body "..."` で PR を作成する。body には HEREDOC を使う。
3. PR の URL を返す。
