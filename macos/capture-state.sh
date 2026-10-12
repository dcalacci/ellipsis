#!/usr/bin/env bash
#
# Dump the parts of a machine that aren't dotfiles into state/, so a new
# machine can replay them with macos/restore-state.sh.
#
# Run this on the OLD machine, commit the result, then pull on the new one.
#
#   ./macos/capture-state.sh
#
# Writes only lists and names. No keys, no tokens, no credentials.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
OUT="$DIR/state"
mkdir -p "$OUT"

have() { command -v "$1" >/dev/null 2>&1; }
note() { printf '  %-22s %s\n' "$1" "$2"; }

echo "Capturing state from $(scutil --get ComputerName 2>/dev/null || hostname) into state/"
printf '%s captured %s\n' "$(scutil --get ComputerName 2>/dev/null || hostname)" "$(date -u +%Y-%m-%dT%H:%M:%SZ)" >"$OUT/CAPTURED"

# Everything brew knows about, as an installable Brewfile. This is the
# ground truth to diff the curated brew/Brewfile.* tiers against.
if have brew; then
  brew bundle dump --force --file="$OUT/Brewfile.actual" >/dev/null 2>&1
  note "Brewfile.actual" "$(grep -c '^\(brew\|cask\|tap\|mas\|vscode\) ' "$OUT/Brewfile.actual" || echo 0) entries"
fi

# R packages. Note these are tied to an R major.minor; a new machine on a
# newer R will rebuild them from source, which is slow but correct.
if have Rscript; then
  Rscript -e 'ip <- installed.packages(); base <- rownames(installed.packages(priority="base")); writeLines(sort(setdiff(rownames(ip), base)))' \
    >"$OUT/r-packages.txt" 2>/dev/null || true
  Rscript -e 'cat(R.version.string, "\n")' >"$OUT/r-version.txt" 2>/dev/null || true
  note "r-packages.txt" "$(wc -l <"$OUT/r-packages.txt" | tr -d ' ') packages"
fi

# Editor extensions
if have code; then
  code --list-extensions >"$OUT/vscode-extensions.txt" 2>/dev/null || true
  note "vscode-extensions.txt" "$(wc -l <"$OUT/vscode-extensions.txt" | tr -d ' ')"
elif [[ -d "$HOME/.vscode/extensions" ]]; then
  # fall back to directory names when the `code` CLI isn't on PATH
  ls "$HOME/.vscode/extensions" | sed -E 's/-[0-9]+\.[0-9]+\.[0-9]+.*$//' | sort -u \
    >"$OUT/vscode-extensions.txt"
  note "vscode-extensions.txt" "$(wc -l <"$OUT/vscode-extensions.txt" | tr -d ' ') (from disk)"
fi
if have cursor; then
  cursor --list-extensions >"$OUT/cursor-extensions.txt" 2>/dev/null || true
  note "cursor-extensions.txt" "$(wc -l <"$OUT/cursor-extensions.txt" | tr -d ' ')"
fi

# Mac App Store apps brew can't install
if have mas; then
  mas list >"$OUT/mas-apps.txt" 2>/dev/null || true
  note "mas-apps.txt" "$(wc -l <"$OUT/mas-apps.txt" | tr -d ' ')"
fi

# Language-level global installs
have npm  && npm ls -g --depth=0 --parseable 2>/dev/null | tail -n +2 | xargs -n1 basename >"$OUT/npm-global.txt" || true
have pipx && pipx list --short >"$OUT/pipx.txt" 2>/dev/null || true
have uv   && uv tool list >"$OUT/uv-tools.txt" 2>/dev/null || true
have conda && conda env list >"$OUT/conda-envs.txt" 2>/dev/null || true

# Scheduled jobs. Informational: do NOT blindly replay these on a second
# machine, two hosts running the same unison sync will fight each other.
crontab -l >"$OUT/crontab.txt" 2>/dev/null || : >"$OUT/crontab.txt"
ls "$HOME/Library/LaunchAgents" >"$OUT/launchagents.txt" 2>/dev/null || true

# SSH host aliases only. Never the keys, never the hostnames' credentials.
if [[ -f "$HOME/.ssh/config" ]]; then
  grep -iE '^host ' "$HOME/.ssh/config" | awk '{$1=""; print substr($0,2)}' | tr ' ' '\n' \
    | grep -v '^\*$' | sort -u >"$OUT/ssh-hosts.txt"
  note "ssh-hosts.txt" "$(wc -l <"$OUT/ssh-hosts.txt" | tr -d ' ') aliases (names only)"
fi

# Git checkouts worth recreating, with their remotes
: >"$OUT/git-repos.txt"
for base in "$HOME/code" "$HOME/src" "$HOME/attic" "$HOME/projects"; do
  [[ -d $base ]] || continue
  while IFS= read -r g; do
    repo="${g%/.git}"
    remote="$(git -C "$repo" remote get-url origin 2>/dev/null || echo '(no origin)')"
    printf '%s\t%s\n' "${repo/#$HOME/~}" "$remote" >>"$OUT/git-repos.txt"
  done < <(find "$base" -maxdepth 2 -name .git -type d 2>/dev/null)
done
sort -o "$OUT/git-repos.txt" "$OUT/git-repos.txt"
note "git-repos.txt" "$(wc -l <"$OUT/git-repos.txt" | tr -d ' ') repos"

# Keyboard modifier remapping and input device prefs, so the new machine can
# be made to match rather than guessed at.
defaults -currentHost read -g 2>/dev/null | grep -A12 'com.apple.keyboard.modifiermapping' \
  >"$OUT/modifier-mapping.txt" || : >"$OUT/modifier-mapping.txt"
{
  for k in com.apple.trackpad.scaling com.apple.mouse.scaling \
           com.apple.swipescrolldirection com.apple.trackpad.forceClick \
           com.apple.mouse.tapBehavior; do
    printf '%s = %s\n' "$k" "$(defaults read -g "$k" 2>/dev/null || echo unset)"
  done
  defaults read com.apple.AppleMultitouchTrackpad 2>/dev/null \
    | grep -iE 'Clicking|ThreeFinger|Dragging|ClickThreshold' || true
} >"$OUT/input-prefs.txt"
note "input-prefs.txt" "trackpad/mouse values"

# Default apps / misc settings worth knowing about
{
  echo "default-browser: $(defaults read com.apple.LaunchServices/com.apple.launchservices.secure 2>/dev/null \
    | grep -A2 'https' | grep LSHandlerRoleAll | head -1 | sed 's/.*= "\(.*\)";/\1/' || echo unknown)"
  echo "login-shell: $(dscl . -read "$HOME" UserShell 2>/dev/null | awk '{print $2}')"
  echo "computer-name: $(scutil --get ComputerName 2>/dev/null)"
} >"$OUT/misc.txt"

echo
echo "Done. Review state/, then commit it."
echo "Replay on the new machine with: ./macos/restore-state.sh"
