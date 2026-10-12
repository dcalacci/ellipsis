#!/usr/bin/env bash
# macOS system defaults. Run directly or via `setup.sh --macos`.
#
# Everything here is reversible: `defaults delete <domain> <key>` puts any
# single setting back to the system default. Nothing here touches SIP,
# Gatekeeper, FileVault, or anything else security-relevant.
set -euo pipefail

echo "Applying macOS defaults (some need a logout to take effect)..."

# ---------------------------------------------------------------- keyboard --
# Fast key repeat. These are the values muriel is set to -- the lowest the
# Settings UI offers are 15 and 2, so these are below what the slider can do.
defaults write -g InitialKeyRepeat -int 10
defaults write -g KeyRepeat -int 1

# Hold a key to repeat it rather than showing the accent picker. Required for
# vim-style navigation to feel right.
defaults write -g ApplePressAndHoldEnabled -bool false

# No autocorrect, smart quotes, or smart dashes. Smart dashes in particular
# turn typed hyphens into en/em dashes, which ruins code and LaTeX.
defaults write -g NSAutomaticSpellingCorrectionEnabled -bool false
defaults write -g NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write -g NSAutomaticDashSubstitutionEnabled -bool false
defaults write -g NSAutomaticCapitalizationEnabled -bool false
defaults write -g NSAutomaticPeriodSubstitutionEnabled -bool false

# Full keyboard access: tab moves between all controls, not just text fields.
defaults write -g AppleKeyboardUIMode -int 3

# ------------------------------------------------------------- trackpad/mouse --
# Read off muriel rather than guessed, so the two machines match.
defaults write -g com.apple.trackpad.scaling -float 1.5
defaults write -g com.apple.mouse.scaling -float 2.0
defaults write -g com.apple.swipescrolldirection -bool true  # natural scrolling

# Tap to click, two-finger right click, no three-finger drag.
defaults write -g com.apple.mouse.tapBehavior -int 1
defaults -currentHost write -g com.apple.mouse.tapBehavior -int 1
defaults write com.apple.AppleMultitouchTrackpad Clicking -bool true
defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true
defaults write com.apple.AppleMultitouchTrackpad TrackpadThreeFingerDrag -bool false
defaults write com.apple.AppleMultitouchTrackpad Dragging -bool false
defaults -currentHost write -g com.apple.trackpad.enableSecondaryClick -bool true

# Force Touch on, with the default click thresholds.
defaults write -g com.apple.trackpad.forceClick -bool true
defaults write com.apple.AppleMultitouchTrackpad FirstClickThreshold -int 1
defaults write com.apple.AppleMultitouchTrackpad SecondClickThreshold -int 1

# -------------------------------------------------------------------- finder --
defaults write com.apple.finder AppleShowAllFiles -bool true           # dotfiles
defaults write -g AppleShowAllExtensions -bool true
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"    # list view
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"    # search here
defaults write com.apple.finder _FXSortFoldersFirst -bool true
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# Don't write .DS_Store on network or USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true

# ---------------------------------------------------------------------- dock --
defaults write com.apple.dock autohide -bool true
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
defaults write com.apple.dock show-recents -bool false
defaults write com.apple.dock tilesize -int 42
defaults write com.apple.dock mru-spaces -bool false  # don't reorder spaces

# -------------------------------------------------------------- screenshots --
mkdir -p "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture location -string "$HOME/Pictures/screenshots"
defaults write com.apple.screencapture type -string "png"
defaults write com.apple.screencapture disable-shadow -bool true

# ------------------------------------------------------------------- safari --
# Developer menu. Safari is sandboxed hard these days so this can fail
# depending on Full Disk Access; don't let it kill the script.
defaults write com.apple.Safari IncludeDevelopMenu -bool true 2>/dev/null || true

# -------------------------------------------------------------- hot corners --
# Bottom-right = Quick Note (14), matching muriel. Modifier 0 = no modifier.
defaults write com.apple.dock wvous-br-corner -int 14
defaults write com.apple.dock wvous-br-modifier -int 0

# --------------------------------------------------------------------- misc --
defaults write com.apple.LaunchServices LSQuarantine -bool false  # no "are you sure"
defaults write NSGlobalDomain NSWindowResizeTime -float 0.001
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
defaults write com.apple.CrashReporter DialogType -string "none"

echo "Restarting affected apps..."
for app in Dock Finder SystemUIServer; do
  killall "$app" >/dev/null 2>&1 || true
done

echo "Done. Log out and back in for the keyboard settings to fully apply."
