# GrokTools

Tools that rebuild generated kernels from the Windows ARM64 armasm sources.

## arm64_to_ml64.py

Windows x64 path (EditForthWin). Reads `Forth/kernel/arm64` and writes ml64
to `Forth/kernel/x64/asm`. See EditForthWin for the full Windows notes.

## arm64_to_android_gas.py

Android NDK path (EditForthAnd). Reads `Forth/kernel/arm64` and writes Clang
GAS `*.S` into `Forth/kernel/arm64-android/` (except hand-written `identity.S`).

The instruction stream stays real AArch64. The translator:

- expands armasm macros / INCLUDE / IF
- emits `.equ` for armasm `EQU`
- rewrites `adrp`/`add` page pairs as PIC GOT loads
- uses writable `.bootptr` / `.bootword` / `.bwstr` so pointer rows relocate in a `.so`

From the EditForthAnd directory:

```bash
python3 GrokTools/arm64_to_android_gas.py
```

Set `EDITFORTHAND` to override the project root (default: parent of GrokTools).
