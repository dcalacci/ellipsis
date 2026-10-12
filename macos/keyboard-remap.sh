#!/usr/bin/env bash
#
# Swap Caps Lock and Control.
#
#   ./macos/keyboard-remap.sh            apply
#   ./macos/keyboard-remap.sh --show     print the current mapping
#   ./macos/keyboard-remap.sh --reset    remove the mapping
#
# This replicates the mapping already running on muriel, read straight off it:
#
#   Caps Lock     (0x39) -> Right Control (0xE4)
#   Right Control (0xE4) -> Caps Lock     (0x39)
#   Left Control  (0xE0) -> Caps Lock     (0x39)
#
# So both physical Control keys become Caps Lock and Caps Lock becomes
# Control. Not a plain two-key swap; that's deliberate, it's what you already
# use.
#
# macOS stores this per keyboard, keyed by vendor-product id, which is why a
# new machine doesn't inherit it. This script writes entries for every
# keyboard currently attached, plus the ids already known from muriel's other
# keyboards so they work the moment you plug one in.
#
# Takes effect at the next login. `defaults -currentHost` is the same thing
# System Settings -> Keyboard -> Modifier Keys writes, so the UI stays honest
# about what's set (unlike the `hidutil` approach, which the UI can't see).

set -euo pipefail

# HID usage ids, as the integers macOS stores (0x700000000 + usage)
CAPS=30064771129     # 0x700000039
LCTRL=30064771296    # 0x7000000E0
RCTRL=30064771300    # 0x7000000E4

# Keyboards seen on muriel. Pre-seeding these means an external keyboard gets
# the mapping without re-running anything.
#   1452-591  Apple Magic Keyboard
#   1452-835  Apple Internal Keyboard / Trackpad
#   1133-45933 Logitech
KNOWN_IDS="1452-591-0 1452-835-0 1133-45933-0 alt_handler_id-49"

mapping_plist() {
  cat <<EOF
(
  { HIDKeyboardModifierMappingSrc = $CAPS;  HIDKeyboardModifierMappingDst = $RCTRL; },
  { HIDKeyboardModifierMappingSrc = $RCTRL; HIDKeyboardModifierMappingDst = $CAPS;  },
  { HIDKeyboardModifierMappingSrc = $LCTRL; HIDKeyboardModifierMappingDst = $CAPS;  }
)
EOF
}

# Every keyboard the system can see right now, as "<vendor>-<product>-0".
attached_ids() {
  ioreg -c AppleHIDKeyboardEventDriverV2 -r -d1 2>/dev/null \
    | grep -E '"(VendorID|ProductID)" =' \
    | sed -E 's/.*"(VendorID|ProductID)" = ([0-9]+).*/\1 \2/' \
    | awk '/VendorID/ { v=$2 } /ProductID/ { if (v != "") { print v "-" $2 "-0"; v="" } }'
}

case "${1:-apply}" in
  --show)
    echo "Current modifier mappings:"
    defaults -currentHost read -g 2>/dev/null \
      | grep -A12 'com.apple.keyboard.modifiermapping' || echo "  (none set)"
    echo
    echo "Keyboards attached right now:"
    attached_ids | sed 's/^/  /'
    exit 0
    ;;
  --reset)
    for id in $(attached_ids) $KNOWN_IDS; do
      defaults -currentHost delete -g "com.apple.keyboard.modifiermapping.$id" 2>/dev/null \
        && echo "  removed $id" || true
    done
    echo "Done. Log out and back in."
    exit 0
    ;;
  apply) ;;
  *) echo "unknown option: $1 (try --show or --reset)" >&2; exit 1 ;;
esac

applied=0
# shellcheck disable=SC2046  # word splitting is what we want here
for id in $(attached_ids | sort -u) $KNOWN_IDS; do
  defaults -currentHost write -g "com.apple.keyboard.modifiermapping.$id" "$(mapping_plist)"
  echo "  mapped $id"
  applied=$((applied + 1))
done

echo
echo "Wrote $applied keyboard mapping(s): Caps Lock <-> Control."
echo "Log out and back in to pick it up."
echo
echo "If a keyboard you plug in later isn't remapped, run this again with it"
echo "attached, or set it in System Settings -> Keyboard -> Modifier Keys."
echo "If the per-keyboard approach gives you trouble, karabiner-elements is in"
echo "brew and handles this at a lower level."
