#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
config_dir="${XDG_CONFIG_HOME:-$HOME/.config}/nvim"
profile="${ZDOTDIR:-$HOME}/.zprofile"
dry_run=false
backup_existing=false

log() { printf '%s\n' "$*"; }
fail() { printf 'Error: %s\n' "$*" >&2; exit 1; }
run() {
  if "$dry_run"; then
    printf '[dry-run]'
    printf ' %q' "$@"
    printf '\n'
  else
    "$@"
  fi
}

for arg in "$@"; do
  case "$arg" in
    --dry-run) dry_run=true ;;
    --backup-existing) backup_existing=true ;;
    --help|-h)
      log 'Usage: bash setup.sh [--dry-run] [--backup-existing]'
      log 'macOS用。Homebrew・開発ツール・Ghostty・Nerd Fontを導入し、Neovim設定を配置します。'
      log '--dry-run: インストールやファイル変更をせず、実行予定を表示します。'
      log '--backup-existing: 別のNeovim設定がある場合、日時付きで退避して切り替えます。'
      exit 0 ;;
    *) fail "Unknown option: $arg" ;;
  esac
done

[[ "$(uname -s)" == Darwin ]] || fail 'このスクリプトはmacOS用です。'
[[ -f "$repo_dir/init.lua" && -d "$repo_dir/lua" ]] || fail 'リポジトリ内のsetup.shを実行してください。'

# Check the destination before installing anything or moving existing settings.
config_in_place=false
if [[ -d "$config_dir" ]]; then
  existing_dir="$(cd "$config_dir" && pwd -P)"
  if [[ "$existing_dir" == "$repo_dir" ]]; then
    config_in_place=true
  else
    case "$repo_dir/" in
      "$existing_dir/"*) fail '設定フォルダの内部からは切り替えできません。リポジトリを別の場所に置いてください。' ;;
    esac
  fi
fi
if ! "$config_in_place" && [[ -e "$config_dir" || -L "$config_dir" ]] && ! "$backup_existing"; then
  fail "$config_dir に既存設定があります。退避して切り替える場合は --backup-existing を付けてください。"
fi

brew_bin="$(command -v brew || true)"
if [[ -z "$brew_bin" ]]; then
  for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
    if [[ -x "$candidate" ]]; then brew_bin="$candidate"; break; fi
  done
fi
if [[ -z "$brew_bin" ]]; then
  log 'Homebrewを公式インストーラーで導入します。画面の案内に従ってください。'
  if "$dry_run"; then
    log '[dry-run] https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh を取得して実行'
    if [[ "$(uname -m)" == arm64 ]]; then
      brew_bin=/opt/homebrew/bin/brew
    else
      brew_bin=/usr/local/bin/brew
    fi
  else
    installer="$(mktemp "${TMPDIR:-/tmp}/nvim-homebrew.XXXXXX")"
    trap 'rm -f "$installer"' EXIT
    curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh -o "$installer"
    /bin/bash "$installer"
    rm -f "$installer"
    trap - EXIT
    for candidate in /opt/homebrew/bin/brew /usr/local/bin/brew; do
      if [[ -x "$candidate" ]]; then brew_bin="$candidate"; break; fi
    done
    [[ -n "$brew_bin" ]] || fail 'Homebrewの導入を完了できませんでした。'
  fi
fi
if ! "$dry_run"; then
  eval "$("$brew_bin" shellenv)"
fi

# Install missing dependencies without upgrading existing packages.
export HOMEBREW_NO_AUTO_UPDATE=1
export HOMEBREW_NO_INSTALL_UPGRADE=1
formulae=(neovim git ripgrep fd lazygit go node imagemagick pngpaste)
missing_formulae=()
for formula in "${formulae[@]}"; do
  if [[ -x "$brew_bin" ]] && "$brew_bin" list --formula "$formula" >/dev/null 2>&1; then
    log "導入済み: $formula"
  else
    missing_formulae+=("$formula")
  fi
done
if [[ ${#missing_formulae[@]} -gt 0 ]]; then
  run "$brew_bin" install "${missing_formulae[@]}"
fi
missing_casks=()
for cask in ghostty font-jetbrains-mono-nerd-font; do
  # Respect Ghostty installed outside Homebrew as well.
  if [[ "$cask" == ghostty ]] && [[ -d /Applications/Ghostty.app || -d "$HOME/Applications/Ghostty.app" ]]; then
    log '導入済み: Ghostty'
  elif [[ -x "$brew_bin" ]] && "$brew_bin" list --cask "$cask" >/dev/null 2>&1; then
    log "導入済み: $cask"
  else
    missing_casks+=("$cask")
  fi
done
if [[ ${#missing_casks[@]} -gt 0 ]]; then
  run "$brew_bin" install --cask "${missing_casks[@]}"
fi

# Make Homebrew available in future macOS zsh login shells.
printf -v shellenv_line 'eval "$(%q shellenv)"' "$brew_bin"
if [[ -f "$profile" ]] && grep -Fqx "$shellenv_line" "$profile"; then
  log 'HomebrewのPATH設定は導入済みです。'
else
  run mkdir -p "$(dirname "$profile")"
  if "$dry_run"; then
    log "[dry-run] $profile に追加: ${shellenv_line}（既存ファイルは変更前にバックアップ）"
  else
    if [[ -e "$profile" ]]; then
      profile_backup="$profile.before-nvim-setup-$(date +%Y%m%d-%H%M%S)-$$"
      cp -p "$profile" "$profile_backup"
      log "シェル設定のバックアップ: $profile_backup"
    fi
    printf '\n%s\n' "$shellenv_line" >> "$profile"
  fi
fi

if "$config_in_place"; then
  log "Neovim設定は配置済みです: $config_dir"
else
  run mkdir -p "$(dirname "$config_dir")"
  if [[ -e "$config_dir" || -L "$config_dir" ]]; then
    config_backup="$config_dir.backup-$(date +%Y%m%d-%H%M%S)-$$"
    run mv "$config_dir" "$config_backup"
    log "既存設定のバックアップ先: $config_backup"
  fi
  run ln -s "$repo_dir" "$config_dir"
fi

if "$dry_run"; then
  log '確認のみ完了しました。インストールやファイル変更はしていません。'
else
  log 'セットアップ完了。新しいGhosttyのウィンドウを開いて nvim を実行してください。'
  log '初回起動でプラグインが入り、Go・Markdownファイルを開くと各言語の設定が読み込まれます。'
fi
