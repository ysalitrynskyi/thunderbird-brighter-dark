#!/usr/bin/env bash
# Remove Thunderbird Brighter Dark from a Thunderbird profile.
# Usage: ./uninstall.sh  |  ./uninstall.sh /path/to/profile
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
# Reuse the profile detection from install.sh
eval "$(sed -n '/^find_tb_root()/,/^}/p;/^find_profile()/,/^}/p' "$HERE/install.sh")"

PROFILE="${1:-$(find_profile)}"
CSS_NAME="brighter-dark.css"
echo "Profile: $PROFILE"

for f in userChrome.css userContent.css; do
  target="$PROFILE/chrome/$f"
  [ -f "$target" ] || continue
  grep -vF "$CSS_NAME" "$target" > "$target.tmp" || true
  if [ -s "$target.tmp" ]; then mv "$target.tmp" "$target"; else rm -f "$target.tmp" "$target"; fi
  echo "  cleaned $f"
done
rm -f "$PROFILE/chrome/$CSS_NAME"

echo "Done. Restart Thunderbird. (user.js was left alone; it only allows custom styles.)"
