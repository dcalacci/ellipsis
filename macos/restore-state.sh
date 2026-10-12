#!/usr/bin/env bash
#
# Replay the replayable parts of state/ onto this machine.
#
#   ./macos/restore-state.sh              interactive, asks per section
#   ./macos/restore-state.sh --r          R packages only
#   ./macos/restore-state.sh --editors    VS Code + Cursor extensions
#   ./macos/restore-state.sh --mas        Mac App Store apps
#   ./macos/restore-state.sh --repos      clone the git checkouts
#   ./macos/restore-state.sh --all
#
# Deliberately does NOT replay crontab or LaunchAgents. Those are per-machine:
# two hosts running the same unison sync jobs will overwrite each other.

set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
IN="$DIR/state"

c_reset=$'\033[0m'; c_blue=$'\033[34m'; c_dim=$'\033[2m'; c_yellow=$'\033[33m'
step() { printf '\n%s==>%s %s\n' "$c_blue" "$c_reset" "$*"; }
skip() { printf '  %s·%s %s\n' "$c_dim" "$c_reset" "$*"; }
warn() { printf '  %s!%s %s\n' "$c_yellow" "$c_reset" "$*"; }
have() { command -v "$1" >/dev/null 2>&1; }
ask()  { [[ -t 0 ]] || return 1; local r; read -r -p "  $1 [y/N] " r; [[ $r =~ ^[Yy]$ ]]; }

[[ -d $IN ]] || { echo "No state/ directory. Run macos/capture-state.sh on the old machine first." >&2; exit 1; }
[[ -f $IN/CAPTURED ]] && echo "State captured from: $(cat "$IN/CAPTURED")"

restore_r() {
  step "R packages"
  local list="$IN/r-packages.txt"
  [[ -f $list ]] || { skip "no r-packages.txt"; return 0; }
  have Rscript || { warn "Rscript not found; install the r-app cask first"; return 0; }
  [[ -f $IN/r-version.txt ]] && echo "  captured under: $(cat "$IN/r-version.txt")"
  echo "  installing under: $(Rscript -e 'cat(R.version.string)')"
  warn "a different R major.minor rebuilds everything from source; this is slow"
  Rscript --vanilla - "$list" <<'EOF'
args <- commandArgs(trailingOnly = TRUE)
want <- readLines(args[1])
want <- want[nzchar(want)]
have <- rownames(installed.packages())
todo <- setdiff(want, have)
cat(sprintf("  %d wanted, %d already present, %d to install\n",
            length(want), length(intersect(want, have)), length(todo)))
if (length(todo)) {
  options(repos = c(CRAN = "https://cloud.r-project.org"))
  install.packages(todo, Ncpus = max(1, parallel::detectCores() - 1))
  still <- setdiff(todo, rownames(installed.packages()))
  if (length(still)) {
    cat("  not on CRAN (install from GitHub/Bioconductor by hand):\n")
    cat(paste0("    ", still, collapse = "\n"), "\n")
  }
}
EOF
}

restore_editors() {
  step "Editor extensions"
  local f
  f="$IN/vscode-extensions.txt"
  if [[ -f $f ]] && have code; then
    while IFS= read -r ext; do
      [[ -n $ext ]] && code --install-extension "$ext" --force >/dev/null 2>&1 \
        && echo "  + $ext" || warn "failed: $ext"
    done <"$f"
  else
    skip "vscode: $( [[ -f $f ]] && echo "'code' CLI not on PATH (VS Code: Cmd-Shift-P, 'Install code command')" || echo "no list captured")"
  fi

  f="$IN/cursor-extensions.txt"
  if [[ -f $f ]] && have cursor; then
    while IFS= read -r ext; do
      [[ -n $ext ]] && cursor --install-extension "$ext" --force >/dev/null 2>&1 \
        && echo "  + $ext" || warn "failed: $ext"
    done <"$f"
  else
    skip "cursor: $( [[ -f $f ]] && echo "'cursor' CLI not on PATH" || echo "no list captured")"
  fi
}

restore_mas() {
  step "Mac App Store apps"
  local f="$IN/mas-apps.txt"
  [[ -f $f ]] || { skip "no mas-apps.txt"; return 0; }
  have mas || { warn "mas not installed (it's in Brewfile.core)"; return 0; }
  warn "sign in to the App Store first, or every install fails"
  while read -r id name _; do
    [[ -n ${id:-} ]] || continue
    echo "  $name ($id)"
    mas install "$id" || warn "failed: $name"
  done <"$f"
}

restore_repos() {
  step "Git checkouts"
  local f="$IN/git-repos.txt"
  [[ -f $f ]] || { skip "no git-repos.txt"; return 0; }
  while IFS=$'\t' read -r path remote; do
    [[ -n ${path:-} && -n ${remote:-} ]] || continue
    [[ $remote == "(no origin)" ]] && { skip "$path (no remote)"; continue; }
    local dest="${path/#\~/$HOME}"
    if [[ -d $dest/.git ]]; then
      skip "$path"
    else
      mkdir -p "$(dirname "$dest")"
      echo "  cloning $remote -> $path"
      git clone "$remote" "$dest" || warn "failed: $remote"
    fi
  done <"$f"
}

show_manual() {
  step "Not replayed automatically"
  echo "  crontab.txt / launchagents.txt -- read them, don't replay blind."
  echo "    The unison sync jobs are muriel's; running them on two machines"
  echo "    at once makes them fight over the same Proton Drive folders."
  echo "  ssh-hosts.txt -- alias names only. Copy ~/.ssh/config across by hand"
  echo "    and generate a NEW key per machine rather than copying the old one."
  echo "  Brewfile.actual -- the full dump from the old machine. Diff it"
  echo "    against brew/Brewfile.* to see what the curated tiers are missing."
}

DO_R=0 DO_ED=0 DO_MAS=0 DO_REPOS=0 INTERACTIVE=1
while [[ $# -gt 0 ]]; do
  case "$1" in
    --all)     DO_R=1; DO_ED=1; DO_MAS=1; DO_REPOS=1; INTERACTIVE=0 ;;
    --r)       DO_R=1; INTERACTIVE=0 ;;
    --editors) DO_ED=1; INTERACTIVE=0 ;;
    --mas)     DO_MAS=1; INTERACTIVE=0 ;;
    --repos)   DO_REPOS=1; INTERACTIVE=0 ;;
    -h|--help) awk 'NR>1 { if (!/^#/) exit; sub(/^# ?/, ""); print }' "${BASH_SOURCE[0]}"; exit 0 ;;
    *)         echo "unknown option: $1" >&2; exit 1 ;;
  esac
  shift
done

if [[ $INTERACTIVE -eq 1 ]]; then
  ask "Install R packages?"        && DO_R=1
  ask "Install editor extensions?" && DO_ED=1
  ask "Install Mac App Store apps?" && DO_MAS=1
  ask "Clone git repos?"           && DO_REPOS=1
fi

[[ $DO_R     -eq 1 ]] && restore_r
[[ $DO_ED    -eq 1 ]] && restore_editors
[[ $DO_MAS   -eq 1 ]] && restore_mas
[[ $DO_REPOS -eq 1 ]] && restore_repos
show_manual
