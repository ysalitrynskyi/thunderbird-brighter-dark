#!/usr/bin/env bash
# Install Thunderbird Brighter Dark into a Thunderbird profile.
# Usage: ./install.sh                 (auto-detects your default profile)
#        ./install.sh /path/to/profile
set -euo pipefail

HERE="$(cd "$(dirname "$0")" && pwd)"
CSS_NAME="brighter-dark.css"
IMPORT_LINE="@import url(\"$CSS_NAME\");"

find_tb_root() {
  case "$(uname -s)" in
    Darwin) echo "$HOME/Library/Thunderbird" ;;
    *)      for d in "$HOME/.thunderbird" "$HOME/.var/app/org.mozilla.Thunderbird/.thunderbird" "$HOME/snap/thunderbird/common/.thunderbird"; do
              [ -f "$d/profiles.ini" ] && { echo "$d"; return; }
            done
            echo "$HOME/.thunderbird" ;;
  esac
}

find_profile() {
  local root ini rel
  root="$(find_tb_root)"; ini="$root/profiles.ini"
  [ -f "$ini" ] || { echo "Could not find $ini — pass the profile folder as an argument." >&2; exit 1; }
  # Prefer the profile the current install actually uses ([Install...] Default=)
  rel="$(awk -F= '/^\[Install/{s=1;next} /^\[/{s=0} s&&$1=="Default"{print $2;exit}' "$ini")"
  # Fall back to the profile marked Default=1
  if [ -z "$rel" ]; then
    rel="$(awk -F= '/^\[Profile/{p="";d=0} $1=="Path"{p=$2} $1=="Default"&&$2=="1"{d=1} d&&p!=""{print p;exit}' "$ini")"
  fi
  [ -n "$rel" ] || { echo "No default profile found — pass the profile folder as an argument." >&2; exit 1; }
  case "$rel" in /*) echo "$rel" ;; *) echo "$root/$rel" ;; esac
}

PROFILE="${1:-$(find_profile)}"
[ -d "$PROFILE" ] || { echo "Profile folder not found: $PROFILE" >&2; exit 1; }
echo "Profile: $PROFILE"

mkdir -p "$PROFILE/chrome"
cp "$HERE/chrome/$CSS_NAME" "$PROFILE/chrome/$CSS_NAME"

# Add the @import to the top of userChrome.css and userContent.css,
# keeping anything you already have in them (a backup is made once).
for f in userChrome.css userContent.css; do
  target="$PROFILE/chrome/$f"
  if [ -f "$target" ] && grep -qF "$CSS_NAME" "$target"; then
    echo "  $f already imports $CSS_NAME"
    continue
  fi
  if [ -f "$target" ]; then
    [ -f "$target.bak" ] || cp "$target" "$target.bak"
    { echo "$IMPORT_LINE"; cat "$target"; } > "$target.tmp" && mv "$target.tmp" "$target"
  else
    echo "$IMPORT_LINE" > "$target"
  fi
  echo "  updated $f"
done

# Turn on custom stylesheets
PREF='user_pref("toolkit.legacyUserProfileCustomizations.stylesheets", true);'
if ! grep -qF 'toolkit.legacyUserProfileCustomizations.stylesheets", true' "$PROFILE/user.js" 2>/dev/null; then
  echo "$PREF" >> "$PROFILE/user.js"
  echo "  enabled custom stylesheets in user.js"
fi

echo "Done. Restart Thunderbird to see the new look."
