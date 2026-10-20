# Android Forth host (EditForthAnd)

How the in-process kernel opens files, boots Autoload, and serves Hyper SPECS
on Android. Companion reference: Windows `Forth/host/main.c` + `companion.c`.

## Roots and packaging

- App data root: `AppDataLocation/EditForthAnd` (writable).
- `ForthPipe_android::start()` calls `android_host_set_roots()` with that path
  before `kernel_init`, then Autoload (see boot order below).
- Shipped trees (`Library`, `AutoLoad`, `Docs`, `Config`) are copied from APK
  assets by `Edit/src/AndroidShip.cpp` when the ship marker version changes.
- Source of those trees: `Forth/Resources/`. Build packages them into
  `Edit/android/assets/EditForthAnd/` (that assets folder is gitignored).

## Boot order

Matches the Windows companion:

1. `kernel_init`
2. Product sign-on banner (`=== EditForthAnd … ===`, version lines)
3. `android_host_autoload()` — evaluate `AutoLoad/autoload.fth` as one buffer
   from `user_root`, then `[DEFINED] MAIN [IF] MAIN [THEN]`
4. Interactive console

Autoload REQUIREs Debugger, Emitter, and Hyper, turns `MIN-HYPER-NOISE` on,
runs `HYPER-REINDEX`, and re-arms debugger HL. Quiet reindex hides
`HX: N SPECS files`; a successful boot still writes `Config/HYPER.NDX`.

## Path resolve

`host_resolve` in `Forth/host/android/host_file_android.c`:

- `Library/…`, `AutoLoad/…`, `Docs/…`, `Config/…` resolve under `user_root`
  even when INCLUDE has set load-cwd to `AutoLoad/` (so
  `REQUIRE Library/…` from `autoload.fth` does not look beside AutoLoad).
- After absolute resolve, case-fold walks only under app-owned `user_root`.
  SELinux denies `opendir("/")`, so folding from `/` must not be used.
- Examples that need fold on case-sensitive Android: `autoload` → `AutoLoad`,
  `Library/HYPER/HYPER.fth` → `Library/Hyper/hyper.fth`.

## Virtual `Config/HYPER.SPECS`

There is no on-disk `HYPER.SPECS`. The host expands `Config/HYPER.CFG`
(`SPECS` / `*EXCLUDE`) the same way Windows/Mac do, builds an NDX path list,
and serves it from a `host_mem` slot when Forth opens basename `HYPER.SPECS`.

`HYPER-REINDEX` therefore uses the full SPECS set instead of the fallback list.

## File dialogs

On Android, source opens (File → Open, EDIT, FLOAD) use non-native
`QFileDialog` (`DontUseNativeDialog`) so the session is not trapped in SAF /
DocumentsUI. Directory picks use the same pattern under `Q_OS_ANDROID`.

## Kernel throw vs BYE

Uncaught throws in the Android kernel map to `_do_quit` (interactive QUIT),
not BYE, so a fault during INCLUDE / Autoload does not stop the Forth engine.

## Debugger (arm / step / continue)

In-process bridge in `Forth/host/android/host_debug_android.c`:

- `host_debug_paint` / `host_debug_set_span` notify the Qt UI (same JSON fields
  as the Windows companion: armed, paused, line, off, len, name, path).
- `kernel_set_key(android_debug_key)` blocks while `debug_busy` until
  `android_debug_post_key` / `android_debug_post_arm` (Continue → `'g'` +
  `debug_bp_go`) or quit.
- `ForthPipe_android::eval` runs `kernel_eval` on a worker thread so KEY can
  block without freezing the UI. `sendKey` / `sendArm` / `signalBreak` feed that
  queue / `debug_break_asap`.

Arm with DebugBar Arm (caret word → `BPGO`), Forth → DEBUG LAST, or
`DEBUG <word>` / `INCLUDE` of a file that ends in `DEBUG …`. While paused,
Step Over / Into / Out, Continue, and Stop match the Windows keys.

Breakpoint list toggle UI is not wired on Android yet (step/continue path is).

## GRAPHICS window

Cold-loaded `app-output.fth` / `app-points.fth` define the **GRAPHICS** vocabulary.
On Android, `Forth/host/android/host_gfx_android.c` plus the in-activity Qt overlay
(`Edit/src/GraphicsWindow` via `GraphicsBridge`) implement char cells and pixel
blits (1-bit / COLOR8 palette / TRUECOLOR BGRA via `host_app_cblit`).

Title (`APP-NAME`), KEY/KEY?, mouse, Close/Esc, and `PREFRESH` pixel paint work.
Image / file panels remain stubs. Eval runs on a worker thread; open/close marshal
to the UI thread (BlockingQueued); blit refreshes are queued.

Smoke:
- `ALSO GRAPHICS GRAPHICS-SMOKE` — char overlay, then key or **Close**
- `FROMLIB FLOAD Sample/BRESENHAM.fth` then `RUN-LINES` — TRUECOLOR bouncing trails (any key stops)
- `FROMLIB FLOAD Sample/GCLOCK.FTH` then `GCLOCK` — COLOR8 analog clock (Esc quits)

## VIEW / jump to source

On desktop, Ctrl-click (Command on Mac) a word in the console or a source tab
opens that word’s stamped file. The Android emulator steals Ctrl+click for
pinch-zoom (two touch points and a line), and host Alt/Option often never
reaches mouse events, so on Android the reliable path is the strip **View**
toggle (also View → View click): turn it on, then left-click a word. Alt+click
still works when the host delivers Alt. Right-click / context menu **View Word**
is the same path. View and Pan are mutually exclusive.
`VIEW <word>` at the console uses the same open path.

Relative Hyper stamps (`Library/…`) resolve under the app Forth root before
the editor opens the file.

## Verify quickly

Marketing version **0.2.0** (`AndroidManifest` `versionName`, kernel
`identity.S`, ship marker `0.2.0-resources`). After install and launch, the
console should show sign-on first, then module Loading lines and
`HYPER: Config/HYPER.NDX … bytes`. Open a known word with VIEW / Hyper to
confirm the index is live.

Debugger smoke: put `: DBG-SMOKE 7 . CR ; DEBUG DBG-SMOKE` in a `.fth` under
the app root, `INCLUDE` it, confirm Step controls appear, step or Continue
until `DEBUG done`.

GRAPHICS: `ALSO GRAPHICS GRAPHICS-SMOKE`, or load `Sample/BRESENHAM.fth` /
`Sample/GCLOCK.FTH` as above.
