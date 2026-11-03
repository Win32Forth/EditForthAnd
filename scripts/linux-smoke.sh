#!/bin/bash
# Linux smoke for the Android host and the .S depth fix.
# The Qt APK still needs the Android Qt kit (see docs/qt-android-setup.md).
# This script is what `gradle test` runs on a machine without that kit.
set -euo pipefail
ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$ROOT"
OUT="${ROOT}/build-linux-smoke"
rm -rf "$OUT"
mkdir -p "$OUT"

echo "== .S source still skips the sentinel =="
if grep -n "add x0, x26, #1" Forth/kernel/arm64-android/prims.S; then
    echo "prims.S still adds one to the .S depth" >&2
    exit 1
fi
grep -q "_pd_empty" Forth/kernel/arm64-android/prims.S
grep -q "_pd_empty" Forth/kernel/arm64/prims.asm

echo "== dot-s model =="
gcc -std=c11 -Wall -Wextra -Werror -o "$OUT/dot_s_model" tests/dot_s_model.c
"$OUT/dot_s_model"

echo "== host TIME&DATE and SYSTEM =="
gcc -std=c11 -Wall -Wextra -Werror \
    -I tests/include \
    -I Forth/host/android \
    -o "$OUT/host_smoke" \
    tests/host_smoke.c \
    tests/edit_post_stub.c \
    Forth/host/android/host_android.c \
    Forth/host/android/emit_buf.c
"$OUT/host_smoke"

if command -v aarch64-linux-gnu-gcc >/dev/null 2>&1 && command -v qemu-aarch64-static >/dev/null 2>&1; then
    echo "== aarch64 .S walk =="
    aarch64-linux-gnu-gcc -static -std=c11 -Wall -Wextra -Werror -o "$OUT/print_dots" \
        tests/aarch64/print_dots_main.c tests/aarch64/print_dots.S
    qemu-aarch64-static "$OUT/print_dots"
    echo "== assemble Android prims.S =="
    aarch64-linux-gnu-gcc -c -o "$OUT/prims.o" Forth/kernel/arm64-android/prims.S
else
    echo "aarch64 cross tools not installed; skipped qemu .S walk" >&2
    echo "install gcc-aarch64-linux-gnu and qemu-user-static to execute print_dots" >&2
fi

echo "linux-smoke: PASS"
