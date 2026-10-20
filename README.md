# EditForthAnd

Android sibling of [EditForthWin](https://github.com/Win32Forth/EditForthWin).  
Public domain (same spirit as the other EditForth trees).

**Version:** 0.2.0 (`versionCode` 2)

**Status:** Qt for Android runs the shared `Edit/` editor + Forth console on
arm64-v8a. The kernel is generated from Windows `Forth/kernel/arm64` via
`GrokTools/arm64_to_android_gas.py` and linked into `libforthnative.so`.

Boot matches Windows: product sign-on first, then Autoload (Debugger, Emitter,
Hyper + `HYPER-REINDEX`). The host resolves `Library/` / `AutoLoad` /
`Config` under the app data root, case-folds under that tree, and serves
virtual `Config/HYPER.SPECS` from `HYPER.CFG`. File → Open / FLOAD use an
in-app picker on Android so the session is not trapped in the system dialog.

### 0.2.0 highlights

- **Debugger** — arm / step / continue / Stop via `host_debug_android` and a
  worker-thread `eval` (DebugBar strip when armed)
- **VIEW** — strip View mode (and Alt+click when delivered) opens stamped source;
  `VIEW <word>` at the console
- **GRAPHICS** — in-activity overlay with char cells plus COLOR8 / TRUECOLOR
  pixel blit (`PREFRESH` / `host_app_cblit`); verified `GRAPHICS-SMOKE`,
  `RUN-LINES` (Bresenham), and `GCLOCK`
- Creator-free install helper: `scripts/run-on-emulator.command`

## Layout

| Path | Role |
| --- | --- |
| `Edit/` | Qt Widgets editor (shared with EditForthWin; Android via `ForthPipe_android.cpp`) |
| `Edit/android/` | Qt packaging (`AndroidManifest.xml` for `androiddeployqt`) |
| `Forth/` | Shared Forth tree |
| `Forth/Resources/` | Shipped AutoLoad, Config, Docs, Library (copied into the APK) |
| `Forth/kernel/arm64` | Windows ARM64 armasm (source of truth) |
| `Forth/kernel/arm64-android` | Android NDK / GAS sources |
| `Forth/host/android` | Bionic file/float host + emit buffer for `libforthnative.so` |
| `GrokTools/` | Translators (`arm64_to_android_gas.py`, …) |
| `docs/qt-android-setup.md` | Qt kit install and CLI build |
| `docs/android-host.md` | Roots, Autoload, SPECS, path resolve |
| `scripts/` | Creator launcher and helpers |

## Build and run (Qt)

See [docs/qt-android-setup.md](docs/qt-android-setup.md).

Host behaviour (Autoload, SPECS, paths): [docs/android-host.md](docs/android-host.md).

**Day-to-day Run:** double-click

`scripts/open-in-qt-creator.command`

That opens Qt Creator on:

`/Users/thomaszimmer/Documents/XCodeProjects/EditForthAnd/Edit/CMakeLists.txt`

Then choose the **Android arm64-v8a** kit and Run on your tablet AVD.

Do not use Android Studio’s green Run for this app (the old Kotlin `Android/`
project is gone). Studio can still provide the SDK/emulator only.

Package id: `org.win32forth.editforthand`.

## Console boot (expected)

```
=== EditForthAnd arm64 0.2.0 === Oct 20, 2026 4:31 PM ===
version=0.2.0  built=Oct 20, 2026 4:31 PM  console=EditForthAnd arm64
kernel_init => 0
DEBUGGER_MODULE :Loading module
EMITTER_MODULE :Loading module
…
HYPER-REINDEX: writing Config/HYPER.NDX...
HYPER: Config/HYPER.NDX … bytes
```

## Native API

`libforthnative.so` exports the C surface in `Forth/include/kernel_api.h`:

- `kernel_init`
- `kernel_eval`
- `kernel_set_emit` / `kernel_set_key` / `kernel_set_facility_op`
- `kernel_version` / `kernel_built` / `kernel_console`

The Qt app calls these in-process through `Edit/src/ForthPipe_android.cpp`.
Autoload entry: `android_host_autoload()` in `Forth/host/android/host_file_android.c`.
