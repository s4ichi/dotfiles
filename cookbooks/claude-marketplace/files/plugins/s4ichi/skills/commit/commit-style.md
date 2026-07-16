# Git コミットスタイル

git コミットメッセージと pull request 説明を書くための規約。プロジェクト固有の規約が常に優先される。

## Subject 行

- 合計 50 文字未満に収めるよう努める
- 末尾にピリオドを付けない
- 小文字・命令形の動詞を使う: `fix`, `add`, `remove`, `use`, `avoid`, `ensure`, `adjust`, `allow`, `enable`, `extract`, `introduce`, `show`, `move`, `roll`
- 固有名詞やクラス名で始まる場合のみ大文字にする — 動詞は決して大文字にしない
- 可能な限り「なぜ」を直接埋め込む: `avoid enlarging small images`, `avoid double-save on archive`
- 技術的な識別子はそのまま維持する: `config.x.avatar_uploadable`, `signup_open?`
- リネームは矢印記法: `ops-lb: legacy-net -> core-net`

### 50 文字未満に収める

subject が長くなるときのテクニック:

- subject が主要な新規物を既に示しているなら `add` を落とす: `audit-logs: AuditLog model`（`… add AuditLog model` ではない）— 既存コードを補う場合（spec、logging）は `add` を残す
- 主要な成果物が明確なら副次的な成果物は省く: `audit-logs: AuditLogExport service`（`… service and background jobs` ではない）— 省いた部分は body で触れる
- `and` より `&`: `AuditLog & User changes`
- prefix が既に与えている限定は落とす: `audit-logs: AuditLog & User changes`（`… for audit logs` ではない）

### 文脈を伴う動詞

汎用的な動詞より具体的な動詞を優先する:

- 予防的な変更では `fix` より `avoid` / `address`
- 関心事 / クラスを抜き出すときは `refactor` より `extract`
- 新しい概念 / 抽象を作るときは `add` より `introduce`
- 外部状態への同期は `update` より `reflect`
- 新しい能力には `gains`（コンポーネントを主語に）: `UserProfile: gains avatar upload`
- 新しいオプション / パラメータには `learns`: `PaymentsApi: learns v2 pagination`
- 挙動の削除には `no longer`: `signup_open? no longer gates profile edits`
- 依存更新や参照する image / git tag の更新には `roll`、リリースエンジニアリングには `releng`、CI / build トリガーには `trigger`

## Prefix パターン

形式: `prefix: rest of subject` — コミットが特定のコンポーネントを対象とする場合に使う。

prefix の種類は変更対象によって変わる:
- クラス / モジュール名（PascalCase、実際の名前と一致。短く grep しやすく一貫させる — 小文字の説明的な形式より優先）: `UserAvatarsController: fix set_avatar authorization`, `SessionRenewal: just propagate errors`
- メソッド参照（Class#method）: `ArticlesController#destroy: avoid double-save on archive`
- View / route パス: `broadcasts/show: sort recipients alphabetically`
- 機能 / epic 名（ハイフン区切り、スペースなし — 一連の変更で一貫させる）: `user-avatars: begin validation`, `audit-logs: AuditLog model`
- ファイル / ディレクトリ: `Dockerfile: build minimal libvips`, `CI: install libvips-tools`
- サブシステム / インフラ名: `tf/k8s: ...`, `dns: ...`, `grafana: ...`

prefix を省略する場合:
- subject が既に対象を示している: `Extract SlackNotifier from DailyReportJob`
- プロジェクト全体、または文脈が自明な変更: `roll latest dependencies`, `trigger build for 3.2.10`
- 短いコミット: `typo`, `wip`, `oops`

## Body

body の最も重要な役割は、diff からは自明でない背景と文脈を説明すること。diff は何が変わったかを示す。body はなぜ変えたのか、どの問題を解決するのか、どの自明でない挙動が変更の動機になったのかを説明する。

- diff が既に語っていることを繰り返さない — コードだけからは読み取れないことに集中する
- 冒頭の一文または段落: 背景・根拠・問題
- 複数の具体点を列挙するときは `- ` の箇条書き
- 行は約 72 文字で折り返す
- issue 参照: `Closes #N`
- subject + diff で自明なら body はまるごと省く

例:

```
user_profiles: wrap avatar update in transaction

Prevent data loss when replacing an avatar and the subsequent
update fails validation. The old avatar destroy is now rolled
back if the profile update doesn't succeed.
```

```
ArticlesController#destroy: avoid double-save on archive

archived! saves immediately, creating one editing history record,
then save! creates a second one with no meaningful diff. The job
was enqueued with the second history, missing the status change
and skipping search index updates.
```

## Pull Request のタイトルと説明

同じ subject 行の規約を PR タイトルにも適用する（70 文字未満）。

- 単一コミットのブランチ: コミット subject をタイトルに、コミット body を説明に使う
- 複数コミットのブランチ: 簡潔な要約タイトルを書き、個々のコミットを Markdown の見出しや箇条書きで説明する

PR 説明にテスト手順、テスト計画、QA チェックリスト、タスクリスト、TODO チェックボックスを決して含めない。

## git コマンドの使い方

- `git -C <path>` を決して使わない — Claude Code の事前承認済み権限を無効化するため。常に対象ディレクトリへ `cd` してから git コマンドを実行する。
