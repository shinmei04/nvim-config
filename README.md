# nvim-config

Ghostty上で使う個人用の[LazyVim](https://www.lazyvim.org/)設定。
Go・Markdown開発に対応。起動時のダッシュボードと常設ファイルツリーは使わず、ファイル移動にはSnacks Pickerを使います。

## 新しいMacでのセットアップ

リポジトリを好きな場所にcloneし、その中で実行します。

```sh
git clone https://github.com/shinmei04/nvim-config.git ~/nvim-config
cd ~/nvim-config
bash setup.sh
```

Gitがまだ使えないMacでは、GitHubの「Code → Download ZIP」で取得して展開し、展開したフォルダで `bash setup.sh` を実行してください。
最初にAppleのコマンドラインツールの案内が出た場合は、その導入を済ませます。

スクリプトは次を行います。

- Homebrewがなければ[公式インストーラー](https://brew.sh/)で導入。管理者パスワードや確認操作は画面の案内に従います。
- Neovim・Git・ripgrep・fd・lazygit・Go・Node.js・ImageMagick・pngpasteを導入。
- Ghostty・JetBrainsMono Nerd Fontを導入。導入済みのものは再インストールせず、既存パッケージの更新もしません。
- HomebrewのPATH設定を `.zprofile` に追加。変更する既存ファイルは日時付きでバックアップします。
- このリポジトリを `~/.config/nvim` にリンク。`XDG_CONFIG_HOME` を指定している場合はその配下を使います。

設定をリンクするため、clone・展開したフォルダは移動・削除しないでください。
macOS用です。Homebrewの[対応OS・環境](https://docs.brew.sh/Installation)を確認してください。

インストールせずに実行予定だけ確認する場合:

```sh
bash setup.sh --dry-run
```

別のNeovim設定が既にある場合は、通常は上書きせず停止します。日時付きで退避して切り替える場合:

```sh
bash setup.sh --backup-existing
```

完了後は、新しいGhosttyのウィンドウで `nvim` を起動します。
初回起動でプラグインが自動インストールされます。Go・Markdownファイルを開き、Masonなどの追加ツールの導入が終わるまで待ってください。
Ghosttyの個別設定はこのリポジトリに含みません。フォントを指定する場合はGhosttyの設定に `font-family = JetBrainsMono Nerd Font Mono` を追加します。

## 主な操作

Spaceがリーダーキーです。キーは順番に押します。

| 操作 | キー |
| --- | --- |
| ファイル検索 | `Space Space` |
| プロジェクト内検索 | `Space /` |
| バッファ検索 | `Space ,` |
| 最近開いたファイル | `Space f r` |
| Explorerの開閉 | `Space e` |
| Oilで親ディレクトリ・ファイル操作 | `-` |
| ターミナルの開閉 | `Ctrl-/` または `F7` |
| 左・下・上・右のウィンドウへ | `Ctrl-h`・`Ctrl-j`・`Ctrl-k`・`Ctrl-l` |
| Markdownのブラウザプレビュー開閉 | `Space b m` |
| クリップボードの画像を貼り付け | `Space i p` |
| 入力モードを抜ける | `Esc` または `jj` |
| 保存 | `:w` → Enter |
| プラグイン一覧 | `:Lazy` → Enter |

## 設定を更新してpush

```sh
cd ~/.config/nvim
git add init.lua lua lazyvim.json lazy-lock.json setup.sh README.md
git commit -m "Update Neovim setup"
git push
```

`lazy-lock.json` はプラグインのバージョン指定です。インストール済みプラグインやキャッシュのコピーは不要です。
この設定はLazyVim公式Starterを基にしています。
