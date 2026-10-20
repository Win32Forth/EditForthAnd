#!/bin/zsh
# Install/start EditForthAnd from this releases folder (or beside a downloaded APK).
# Double-click friendly. Public domain.
set -e
HERE="$(cd "$(dirname "$0")" && pwd)"
ADB_CANDIDATES=(
  "$HERE/adb"
  "$HOME/Library/Android/sdk/platform-tools/adb"
  "/opt/homebrew/bin/adb"
  "/usr/local/bin/adb"
)
ADB=""
for c in "${ADB_CANDIDATES[@]}"; do
  if [[ -x "$c" ]]; then
    ADB="$c"
    break
  fi
done
if [[ -z "$ADB" ]] && command -v adb >/dev/null 2>&1; then
  ADB="$(command -v adb)"
fi

PKG=org.win32forth.editforthand
ACTIVITY="$PKG/org.qtproject.qt.android.bindings.QtActivity"

# Prefer versioned release APK next to this script; fall back to newest match.
APK=""
if ls "$HERE"/EditForthAnd-*-arm64.apk >/dev/null 2>&1; then
  APK="$(ls -t "$HERE"/EditForthAnd-*-arm64.apk | head -1)"
fi
if [[ -z "$APK" || ! -f "$APK" ]]; then
  echo "No EditForthAnd-*-arm64.apk found in:"
  echo "  $HERE"
  echo "Download the APK from the GitHub Release into this folder, then try again."
  read -k 1 "?Press any key "
  exit 1
fi

if [[ -z "$ADB" || ! -x "$ADB" ]]; then
  echo "adb not found. Install Android platform-tools, or put adb on your PATH."
  echo "Expected: $HOME/Library/Android/sdk/platform-tools/adb"
  read -k 1 "?Press any key "
  exit 1
fi

if ! "$ADB" devices | grep -q $'device$'; then
  echo "No emulator/device online (adb devices shows none in 'device' state)."
  echo "Start a tablet AVD in Android Studio, or connect a phone with USB debugging."
  "$ADB" devices
  read -k 1 "?Press any key "
  exit 1
fi

echo "Installing $(basename "$APK") ..."
"$ADB" install -r "$APK"
"$ADB" shell am force-stop "$PKG" >/dev/null 2>&1 || true
echo "Starting EditForthAnd ..."
"$ADB" shell am start -n "$ACTIVITY"
echo "Done. Use File → Exit (or the red Close control) to quit the app."
sleep 2
