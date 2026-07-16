# claude-marketplace

この dotfiles リポジトリを **Claude Code のローカル marketplace** としてホストする cookbook。
`files/` 配下に plugin を置き、`default.rb`（mitamae レシピ）が `claude` CLI 経由で
marketplace を登録し plugin を有効化する。`./bin/install` を流すだけで、任意のマシンで
`/plugin`・CLI から自分の skill/plugin が参照できる状態を再現する。

## 構成

```
cookbooks/claude-marketplace/
├── default.rb                       # marketplace 登録 + plugin install（レシピ）
├── README.md
└── files/                           # ← marketplace root（CLI がこの絶対パスを参照）
    ├── .claude-plugin/
    │   └── marketplace.json         # カタログ: plugins[] が ./plugins/* を列挙
    └── plugins/
        └── s4ichi/           # plugin の実体
            ├── .claude-plugin/
            │   └── plugin.json      # plugin manifest（version なし）
            └── skills/
                └── handoff/
                    └── SKILL.md     # skill 例: 会話を引き継ぎドキュメントに要約
```

- **marketplace** = カタログ（どの plugin があるか）。`files/.claude-plugin/marketplace.json`。
- **plugin** = 実体。`files/plugins/<name>/`。`skills/` の他に将来 `agents/` `hooks/` `.mcp.json` `bin/` `scripts/` を足せる。
- `.claude-plugin/` にはマニフェスト（marketplace.json / plugin.json）だけを置く。`skills/` 等は plugin root 直下（`.claude-plugin/` の兄弟）。

## plugin / skill を追加する

1. skill を足す: `files/plugins/<plugin>/skills/<skill>/SKILL.md` を作る（`handoff/SKILL.md` を参考に）。
   frontmatter は `name` と `description`（必須）。任意で `argument-hint` `disable-model-invocation` など。
2. plugin を新設する場合: `files/plugins/<name>/.claude-plugin/plugin.json` を作り、
   `files/.claude-plugin/marketplace.json` の `plugins[]` に `{ "name": "<name>", "source": "./plugins/<name>" }` を追記。
3. install 対象にする: `default.rb` の `node[:claude_marketplace][:plugins]` に `<name>` を追加。
4. `./bin/install` を流す。

## 開発ループ

install 版は cache に copy されるため、編集をすぐ試すなら install せず `--plugin-dir` で読み込むのが速い。

```sh
# ライブ読込で起動（install 不要）
claude --plugin-dir cookbooks/claude-marketplace/files/plugins/s4ichi

# セッション中に再読込（skills / agents / hooks / MCP / LSP）
/reload-plugins
```

install 済みの plugin を編集後に反映する場合:

```sh
claude plugin update s4ichi@s4ichi
```

## 手動登録（レシピを使わない場合）

ローカルの clone を参照（dotfiles 用・レシピもこれ）:

```sh
claude plugin marketplace add <repo>/cookbooks/claude-marketplace/files
claude plugin install s4ichi@s4ichi --scope user
# もしくは Claude Code 内で /plugin
```

GitHub から直接（clone 不要・任意マシン）:

```sh
claude plugin marketplace add s4ichi/dotfiles
claude plugin install s4ichi@s4ichi --scope user
```

## 2 つの marketplace.json（同期に注意）

github shorthand（`s4ichi/dotfiles`）は **repo ルートの** `.claude-plugin/marketplace.json` を見るため、
カタログを 2 箇所に置いている。どちらも `name: s4ichi` で、違いは plugin の `source` 相対パスだけ:

- `.claude-plugin/marketplace.json`（repo ルート／GitHub 用）
  `source: ./cookbooks/claude-marketplace/files/plugins/<name>`
- `cookbooks/claude-marketplace/files/.claude-plugin/marketplace.json`（ローカルパス登録／レシピ用）
  `source: ./plugins/<name>`

plugin を増減したら **両方の `plugins[]` を更新する**こと（`source` の相対パスだけ書き分ける）。
ローカルと GitHub のどちらか一方を登録して使う（同名 `s4ichi` なので併用はしない）。

## ベストプラクティス指針

- **version-less で active development**: plugin.json / marketplace entry に `version` を書かない。
  git commit SHA / ライブ参照ベースで更新検出される。明示リリースが要る段階で初めて version を入れる
  （入れた瞬間、release ごとに bump が必要になる）。
- **self-contained に保つ**: plugin は cache に copy される前提。`../` で plugin ディレクトリ外を参照しない。
  bundled ファイル参照は `${CLAUDE_PLUGIN_ROOT}`、update を跨いで残す永続データ（依存キャッシュ等）は `${CLAUDE_PLUGIN_DATA}`。
- **runtime パッケージとして設計**: skill=手順 / agent=専門role / hooks=runtime policy / MCP=外部情報 / bin・scripts=決定的ヘルパー。
  SKILL.md は短く保ち、repo 固有ロジックは `bin/` の CLI に逃がす。
- **hooks は warn-only / read-only から**始める。強くしすぎると hook failure に Claude の挙動が引きずられる。
- **security**: plugin は hooks / MCP / bin を通じて任意コード実行に近い力を持つ。review 対象は prompt だけでなく
  `hooks/` `.mcp.json` `bin/` `scripts/` と SessionStart 副作用も含める。

## レシピ（default.rb）メモ

- リポジトリ絶対パスは `File.expand_path` で算出（マシンごとの clone 先差異に追従）。
- `claude` CLI をユーザー権限（`user node[:user]` + `HOME`）で実行。Linux の `sudo -E` 実行下でも
  ユーザーの `~/.claude` に登録される。
- `only_if "command -v claude"` で claude 未導入マシンでは skip。
- 冪等性は `known_marketplaces.json` / `installed_plugins.json` の grep（`not_if`）で担保。
- 更新を provision で自動化したくなったら、`node[:claude_marketplace]` に `auto_update` 属性を足し、
  有効時のみ `claude plugin update <plugin>@<name>` を回す execute を追加する（既定はオフ / 冪等優先）。
