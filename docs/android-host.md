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

## Verify quickly

After install and launch, the console should show sign-on first, then module
Loading lines and `HYPER: Config/HYPER.NDX … bytes`. Open a known word with
VIEW / Hyper to confirm the index is live.
