#!/bin/zsh
# Double-click this in Finder, or run from a terminal, to open EditForthAnd in Qt Creator.
set -e
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
CMAKE="$ROOT/Edit/CMakeLists.txt"
CREATOR=""
for candidate in \
  "$HOME/Qt/Qt Creator.app" \
  "/Applications/Qt Creator.app" \
  "$HOME/Qt/Tools/QtCreator/Qt Creator.app"
do
  if [[ -d "$candidate" ]]; then
    CREATOR="$candidate"
    break
  fi
done
if [[ -z "$CREATOR" ]]; then
  echo "Qt Creator.app not found under ~/Qt or /Applications."
  echo "Open this file manually in Qt Creator:"
  echo "  $CMAKE"
  read -k 1 "?Press any key to close "
  exit 1
fi
if [[ ! -f "$CMAKE" ]]; then
  echo "Missing project file: $CMAKE"
  read -k 1 "?Press any key to close "
  exit 1
fi
echo "Opening:"
echo "  $CMAKE"
echo "in: $CREATOR"
open -a "$CREATOR" "$CMAKE"
