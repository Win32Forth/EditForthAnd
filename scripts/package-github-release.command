#!/bin/zsh
# Build release assets under releases/ and optionally publish a GitHub Release.
# Usage:
#   ./scripts/package-github-release.command           # package only
#   ./scripts/package-github-release.command --publish # package + gh release
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"

VER="$(sed -n 's/.*"\([0-9][0-9]*\.[0-9][0-9]*\.[0-9][0-9]*\)".*/\1/p' \
  Forth/kernel/arm64-android/identity.S | head -1)"
if [[ -z "$VER" ]]; then
  echo "Could not read version from identity.S"
  exit 1
fi

SRC_APK="$ROOT/build-android/android-build/build/outputs/apk/debug/android-build-debug.apk"
if [[ ! -f "$SRC_APK" ]]; then
  echo "APK missing. Build first (docs/qt-android-setup.md), then re-run."
  echo "Expected: $SRC_APK"
  exit 1
fi

REL="$ROOT/releases"
mkdir -p "$REL"
NAME="EditForthAnd-${VER}-arm64"
APK_OUT="$REL/${NAME}.apk"
ZIP_OUT="$REL/${NAME}.zip"

cp -f "$SRC_APK" "$APK_OUT"
chmod +x "$REL/install-on-device.command" 2>/dev/null || true

rm -f "$ZIP_OUT"
(
  cd "$REL"
  zip -q "$ZIP_OUT" "$(basename "$APK_OUT")" install-on-device.command INSTALL.txt
)

echo "Packaged:"
ls -lh "$APK_OUT" "$ZIP_OUT"

if [[ "${1:-}" != "--publish" ]]; then
  echo "Package only. To publish: $0 --publish"
  exit 0
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "gh CLI not found; assets are ready under releases/."
  exit 1
fi

TAG="v${VER}"
NOTES="$REL/RELEASE-NOTES-${VER}.md"
if [[ ! -f "$NOTES" ]]; then
  NOTES="$(mktemp)"
  cat > "$NOTES" <<EOF
## EditForthAnd ${VER}

Android arm64-v8a sideload / emulator build.

### Install
1. Download **${NAME}.zip** (or the \`.apk\` plus \`install-on-device.command\`).
2. Start an emulator or connect a device with USB debugging.
3. Run \`install-on-device.command\` (macOS) or \`adb install -r ${NAME}.apk\`.

Package id: \`org.win32forth.editforthand\`
EOF
fi

if git rev-parse "$TAG" >/dev/null 2>&1; then
  echo "Tag $TAG already exists locally."
else
  git tag -a "$TAG" -m "EditForthAnd $VER"
fi
git push origin "refs/tags/$TAG" 2>/dev/null || git push origin "$TAG"

if gh release view "$TAG" >/dev/null 2>&1; then
  echo "Release $TAG exists; uploading assets..."
  gh release upload "$TAG" "$APK_OUT" "$ZIP_OUT" "$REL/install-on-device.command" "$REL/INSTALL.txt" --clobber
else
  gh release create "$TAG" \
    --title "EditForthAnd $VER" \
    --notes-file "$NOTES" \
    "$APK_OUT" "$ZIP_OUT" "$REL/install-on-device.command" "$REL/INSTALL.txt"
fi

echo "Published: https://github.com/Win32Forth/EditForthAnd/releases/tag/$TAG"
