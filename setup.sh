#!/usr/bin/env bash
#
# ellipsis -- bootstrap a Mac.
#
#   ./setup.sh                      interactive, asks about each step
#   ./setup.sh --all                everything except the heavy/wm tiers
#   ./setup.sh --brew core,work     just those Brewfile tiers
#   ./setup.sh --dotfiles           just the symlinks
#   ./setup.sh --macos --keyboard   system defaults + Caps Lock/Control swap
#   ./setup.sh --dry-run --all      print what would happen, change nothing
#   ./setup.sh --help
#
# Safe to re-run. Every step checks before it acts, and anything already at
# the target state is skipped. Real files in the way of a symlink are moved to
# ~/.ellipsis-backup/<timestamp>/ rather than deleted.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
BACKUP_DIR="$HOME/.ellipsis-backup/$(date +%Y%m%d-%H%M%S)"
DRY_RUN=0

# ---------------------------------------------------------------- plumbing --

c_reset=$'\033[0m'; c_blue=$'\033[34m'; c_green=$'\033[32m'
c_yellow=$'\033[33m'; c_red=$'\033[31m'; c_dim=$'\033[2m'

step() { printf '\n%s==>%s %s\n' "$c_blue" "$c_reset" "$*"; }
ok()   { printf '  %s✓%s %s\n' "$c_green" "$c_reset" "$*"; }
skip() { printf '  %s·%s %s\n' "$c_dim" "$c_reset" "$*"; }
warn() { printf '  %s!%s %s\n' "$c_yellow" "$c_reset" "$*"; }
die()  { printf '\n%serror:%s %s\n' "$c_red" "$c_reset" "$*" >&2; exit 1; }

run() {
  if [[ $DRY_RUN -eq 1 ]]; then
    printf '  %swould run:%s %s\n' "$c_dim" "$c_reset" "$*"
  else
    "$@"
  fi
}

have() { command -v "$1" >/dev/null 2>&1; }

ask() {
  # ask "question" -> 0 for yes. Non-interactive defaults to no.
  [[ -t 0 ]] || return 1
  local reply
  read -r -p "  $1 [y/N] " reply
  [[ $reply =~ ^[Yy]$ ]]
}

# link SRC DST -- symlink, backing up anything real already sitting at DST.
link() {
  local src="$DIR/$1" dst="$2"
  [[ -e $src ]] || { warn "missing in repo: $1"; return 0; }

  if [[ -L $dst && "$(readlink "$dst")" == "$src" ]]; then
    skip "$dst"
    return 0
  fi

  [[ -d "$(dirname "$dst")" ]] || run mkdir -p "$(dirname "$dst")"

  if [[ -e $dst || -L $dst ]]; then
    run mkdir -p "$BACKUP_DIR"
    run mv "$dst" "$BACKUP_DIR/$(basename "$dst")"
    warn "backed up existing $dst"
  fi

  run ln -sfn "$src" "$dst"
  ok "$dst -> $1"
}

# ------------------------------------------------------------------- steps --

preflight() {
  step "Preflight"
  [[ "$(uname -s)" == "Darwin" ]] || die "this script is macOS only"
  ok "macOS $(sw_vers -productVersion) on $(uname -m)"

  if ! xcode-select -p >/dev/null 2>&1; then
    warn "Xcode command line tools missing; launching the installer"
    run xcode-select --install
    echo "  Finish the Xcode CLT install in the GUI, then re-run this script."
    exit 0
  fi
  ok "Xcode command line tools"
}

install_homebrew() {
  step "Homebrew"

  # On Apple Silicon the installer handles /opt/homebrew natively. The old
  # version of this script untarred brew by hand and also installed an x86
  # copy under Rosetta; neither is needed any more.
  if ! have brew; then
    run /bin/bash -c \
      "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  else
    ok "already installed"
  fi

  local prefix
  if [[ "$(uname -m)" == "arm64" ]]; then prefix=/opt/homebrew; else prefix=/usr/local; fi
  if [[ -x "$prefix/bin/brew" ]]; then
    eval "$("$prefix/bin/brew" shellenv)"
    ok "brew at $prefix"
  elif [[ $DRY_RUN -eq 0 ]]; then
    die "brew not found at $prefix after install"
  fi
}

brew_tier() {
  local tier="$1" file="$DIR/brew/Brewfile.$1"
  [[ -f $file ]] || { warn "no Brewfile for tier '$tier'"; return 0; }
  step "Brewfile: $tier"
  run brew bundle --file="$file" || warn "some $tier packages failed; see above"
}

link_dotfiles() {
  step "Dotfiles"

  link git/gitconfig                "$HOME/.gitconfig"
  link git/gitignore                "$HOME/.config/git/ignore"

  link zshrc                        "$HOME/.zshrc"
  link zsh                          "$HOME/.zsh"

  link bash/bash_profile            "$HOME/.bash_profile"
  link bash/bashrc                  "$HOME/.bashrc"
  link bash/inputrc                 "$HOME/.inputrc"

  link tmux/tmux.conf               "$HOME/.tmux.conf"
  link kitty                        "$HOME/.config/kitty"
  link nvim                         "$HOME/.config/nvim"
  link bin                          "$HOME/.bin"

  link python/ipython_config.py     "$HOME/.ipython/profile_default/ipython_config.py"
  link conda/.condarc               "$HOME/.condarc"

  # Emacs bindings in Cocoa text fields. Only affects apps launched after.
  link macos/KeyBindings/DefaultKeyBinding.dict \
       "$HOME/Library/KeyBindings/DefaultKeyBinding.dict"
}

link_wm() {
  step "Window manager configs"
  link wm/yabairc "$HOME/.config/yabai/yabairc"
  link wm/skhdrc  "$HOME/.config/skhd/skhdrc"
  warn "start them with: yabai --start-service && skhd --start-service"
}

install_zinit() {
  step "zinit (zsh plugin manager)"
  local home="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
  if [[ -d $home ]]; then
    skip "already at $home"
    return 0
  fi
  # The old git.io/zinit-install short link still redirects, but git.io has
  # been frozen since 2022. Clone directly instead.
  run mkdir -p "$(dirname "$home")"
  run git clone --depth=1 https://github.com/zdharma-continuum/zinit.git "$home"
  ok "installed"
}

install_tpm() {
  step "tpm (tmux plugin manager)"
  # tmux/tmux.conf hardcodes this path and will error on launch without it.
  local tpm="$HOME/.tmux/plugins/tpm"
  if [[ -d $tpm ]]; then
    skip "already at $tpm"
    return 0
  fi
  run git clone --depth=1 https://github.com/tmux-plugins/tpm "$tpm"
  ok "installed -- press prefix + I inside tmux to fetch the plugins"
}

install_neovim_plugins() {
  step "Neovim plugins (LazyVim)"
  have nvim || { warn "nvim not installed yet, skipping"; return 0; }
  run nvim --headless "+Lazy! sync" +qa
  ok "synced"
}

install_node() {
  step "Node (nvm)"
  # zshrc sets NVM_DIR to ~/.config/nvm, so install there. The old script
  # installed to the ~/.nvm default, which zshrc then never sourced.
  export NVM_DIR="$HOME/.config/nvm"
  if [[ -s "$NVM_DIR/nvm.sh" ]]; then
    skip "nvm already at $NVM_DIR"
  else
    run mkdir -p "$NVM_DIR"
    run bash -c "curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.8/install.sh | NVM_DIR='$NVM_DIR' PROFILE=/dev/null bash"
  fi
  if [[ $DRY_RUN -eq 0 && -s "$NVM_DIR/nvm.sh" ]]; then
    # shellcheck disable=SC1091
    . "$NVM_DIR/nvm.sh"
    nvm install --lts
    nvm alias default lts/*
    ok "node $(node --version)"
  fi
}

install_rust() {
  step "Rust"
  if have rustc; then
    skip "already installed ($(rustc --version))"
    return 0
  fi
  run bash -c "curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y --no-modify-path"
  ok "installed -- zshrc already has ~/.cargo/bin on PATH"
}

install_python_tools() {
  step "Python tooling"
  have uv || { warn "uv not installed (it's in Brewfile.work), skipping"; return 0; }
  run pipx ensurepath
  for pkg in jupyterlab jupytext radian; do
    if pipx list 2>/dev/null | grep -q "package $pkg "; then
      skip "$pkg"
    else
      run pipx install "$pkg"
    fi
  done
  ok "done"
}

install_miniforge() {
  step "Miniforge"
  # zshrc's conda block looks in ~/miniforge3. The Homebrew cask installs to
  # the Caskroom instead, so use the upstream installer to match.
  if [[ -d "$HOME/miniforge3" ]]; then
    skip "already at ~/miniforge3"
    return 0
  fi
  local arch installer
  arch="$(uname -m)"
  installer="/tmp/miniforge-$arch.sh"
  run curl -fsSL -o "$installer" \
    "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-MacOSX-${arch}.sh"
  run bash "$installer" -b -p "$HOME/miniforge3"
  run rm -f "$installer"
  ok "installed to ~/miniforge3"
}

setup_git_lfs() {
  step "git-lfs"
  have git-lfs || { warn "git-lfs not installed, skipping"; return 0; }
  run git lfs install
  ok "hooks registered"
}

setup_ssh() {
  step "SSH"
  # The old script copied keys out of ~/docs, which no longer exists. Generate
  # a fresh per-machine key instead -- copying a private key between machines
  # means you can't revoke one without revoking both.
  local key="$HOME/.ssh/id_ed25519"
  run mkdir -p "$HOME/.ssh"
  run chmod 700 "$HOME/.ssh"

  if [[ -f $key ]]; then
    skip "key already at $key"
  else
    run ssh-keygen -t ed25519 -C "dana@dcalacci.net ($(scutil --get ComputerName 2>/dev/null || hostname))" -f "$key" -N ""
    ok "generated $key"
  fi

  if [[ $DRY_RUN -eq 0 && -f "$key.pub" ]]; then
    cat >"$HOME/.ssh/config.ellipsis" <<'EOF'
Host *
  AddKeysToAgent yes
  UseKeychain yes
  IdentityFile ~/.ssh/id_ed25519
EOF
    if [[ ! -f "$HOME/.ssh/config" ]]; then
      mv "$HOME/.ssh/config.ellipsis" "$HOME/.ssh/config"
      ok "wrote ~/.ssh/config"
    else
      warn "~/.ssh/config exists; suggested block left at ~/.ssh/config.ellipsis"
    fi
    chmod 600 "$HOME/.ssh/config" 2>/dev/null || true

    echo
    echo "  Public key:"
    sed 's/^/    /' "$key.pub"
    echo
    if have gh; then
      echo "  Add it to GitHub with:  gh auth login && gh ssh-key add $key.pub"
    fi
    echo "  Tailscale, Proton, and 1Password-style secrets are not handled here."
  fi
}

apply_macos_defaults() {
  step "macOS defaults"
  run bash "$DIR/macos/defaults.sh"
}

remap_keyboard() {
  step "Keyboard: swap Caps Lock and Control"
  run bash "$DIR/macos/keyboard-remap.sh"
}

final_notes() {
  cat <<EOF

$(printf '%s' "$c_green")Done.$(printf '%s' "$c_reset") Left to do by hand:

  * Sign in: Proton (Mail/Drive/Pass), Tailscale, Slack, Linear, Zotero, Obsidian.
  * Proton Drive needs to finish syncing before the Obsidian vault at
    "01 Notes/_vault" will open.
  * Sign in to the App Store BEFORE the brew step, or the \`mas\` entries
    (Magnet) fail. Other MAS apps you had: Bear, Goodnotes. Get their ids with
    \`mas list\` on the old machine and add them to brew/Brewfile.core.
  * Not on brew: OneTagger, Lexicon, Meeting Owl.
  * Free Cmd-Space for Alfred: System Settings -> Keyboard -> Keyboard
    Shortcuts -> Spotlight, untick "Show Spotlight search".
  * Turn on FileVault and point Time Machine somewhere. muriel has FileVault
    on but no Time Machine destination configured; a laptop wants both.
  * Open tmux and press prefix (C-]) then I to install the tmux plugins.
  * Set kitty as the default terminal and check the font renders:
    kitty +list-fonts | grep -i blex
  * Restore the GPG/age keys for bin/crypt if you still use it.

EOF
  if [[ -d $BACKUP_DIR ]]; then
    echo "  Files that were in the way are in $BACKUP_DIR"
    echo
  fi
}

# -------------------------------------------------------------------- main --

usage() {
  # print the header comment block, stopping at the first non-comment line
  awk 'NR>1 { if (!/^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"
  exit 0
}

DO_BREW_TIERS=""
DO_DOTFILES=0 DO_SHELL=0 DO_NVIM=0 DO_LANGS=0 DO_SSH=0 DO_MACOS=0 DO_WM=0 DO_KEYBOARD=0
INTERACTIVE=1

while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)
      DO_BREW_TIERS="core,work,media"
      DO_DOTFILES=1; DO_SHELL=1; DO_NVIM=1; DO_LANGS=1; DO_SSH=1
      INTERACTIVE=0
      ;;
    --brew)      DO_BREW_TIERS="$2"; INTERACTIVE=0; shift ;;
    --brew=*)    DO_BREW_TIERS="${1#*=}"; INTERACTIVE=0 ;;
    --dotfiles)  DO_DOTFILES=1; INTERACTIVE=0 ;;
    --shell)     DO_SHELL=1; INTERACTIVE=0 ;;
    --nvim)      DO_NVIM=1; INTERACTIVE=0 ;;
    --langs)     DO_LANGS=1; INTERACTIVE=0 ;;
    --ssh)       DO_SSH=1; INTERACTIVE=0 ;;
    --macos)     DO_MACOS=1; INTERACTIVE=0 ;;
    --keyboard)  DO_KEYBOARD=1; INTERACTIVE=0 ;;
    --wm)        DO_WM=1; INTERACTIVE=0 ;;
    --dry-run)   DRY_RUN=1 ;;
    -h|--help)   usage ;;
    *)           die "unknown option: $1 (try --help)" ;;
  esac
  shift
done

preflight
[[ $DRY_RUN -eq 1 ]] && warn "dry run: nothing will be changed"

if [[ $INTERACTIVE -eq 1 ]]; then
  echo
  echo "Nothing selected. Pick the steps to run (or re-run with --all)."
  echo
  ask "Install/update Homebrew packages?"      && DO_BREW_TIERS="core,work,media"
  ask "  ...also the heavy tier (Adobe, Android Studio, ~20GB)?" \
    && DO_BREW_TIERS="$DO_BREW_TIERS,heavy"
  ask "Link dotfiles?"                         && DO_DOTFILES=1
  ask "Install zinit + tpm?"                   && DO_SHELL=1
  ask "Install neovim plugins?"                && DO_NVIM=1
  ask "Install node / rust / python / conda?"  && DO_LANGS=1
  ask "Generate an SSH key?"                   && DO_SSH=1
  ask "Apply macOS system defaults?"           && DO_MACOS=1
  ask "Swap Caps Lock and Control?"            && DO_KEYBOARD=1
  ask "Install the yabai/skhd window manager?" && DO_WM=1
fi

if [[ -n $DO_BREW_TIERS ]]; then
  install_homebrew
  # bash 3.2: no readarray, so split on commas the old way
  old_ifs="$IFS"; IFS=','
  for tier in $DO_BREW_TIERS; do
    IFS="$old_ifs"
    brew_tier "$tier"
    IFS=','
  done
  IFS="$old_ifs"
fi

[[ $DO_DOTFILES -eq 1 ]] && link_dotfiles
[[ $DO_SHELL    -eq 1 ]] && { install_zinit; install_tpm; }
[[ $DO_NVIM     -eq 1 ]] && install_neovim_plugins
[[ $DO_LANGS    -eq 1 ]] && { install_node; install_rust; install_python_tools; install_miniforge; setup_git_lfs; }
[[ $DO_SSH      -eq 1 ]] && setup_ssh
[[ $DO_WM       -eq 1 ]] && { brew_tier wm; link_wm; }
[[ $DO_MACOS    -eq 1 ]] && apply_macos_defaults
[[ $DO_KEYBOARD -eq 1 ]] && remap_keyboard

final_notes
