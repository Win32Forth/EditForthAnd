#!/bin/zsh
# Double-click to install/start EditForthAnd on the running Android emulator.
# No Qt Creator required.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
ADB="$HOME/Library/Android/sdk/platform-tools/adb"
APK="$ROOT/build-android/android-build/build/outputs/apk/debug/android-build-debug.apk"
PKG=org.win32forth.editforthand
ACTIVITY="$PKG/org.qtproject.qt.android.bindings.QtActivity"

if [[ ! -x "$ADB" ]]; then
  echo "adb not found at $ADB"
  read -k 1 "?Press any key "
  exit 1
fi
if [[ ! -f "$APK" ]]; then
  echo "APK missing. Build it first (ask Grok, or use the cmake steps in docs/qt-android-setup.md)."
  echo "Expected: $APK"
  read -k 1 "?Press any key "
  exit 1
fi
if ! "$ADB" devices | grep -q $'device$'; then
  echo "No emulator/device online. Start your tablet AVD in Android Studio first."
  "$ADB" devices
  read -k 1 "?Press any key "
  exit 1
fi

echo "Installing $APK ..."
"$ADB" install -r "$APK"
"$ADB" shell am force-stop "$PKG" >/dev/null 2>&1 || true
echo "Starting EditForthAnd ..."
"$ADB" shell am start -n "$ACTIVITY"
echo "Done. Use the red Close button in the app to exit."
sleep 2
