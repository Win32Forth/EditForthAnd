## EditForthAnd 0.2.0

Android arm64-v8a build for emulator / USB sideload.

### Highlights
- **Debugger** — arm / step / continue / Stop (DebugBar when armed)
- **VIEW** — strip View mode opens stamped source; `VIEW <word>` at the console
- **GRAPHICS** — char overlay plus COLOR8 / TRUECOLOR pixel blit (`RUN-LINES`, `GCLOCK`)

### Install
1. Download **EditForthAnd-0.2.0-arm64.zip** (recommended), or the `.apk` plus `install-on-device.command`.
2. Start a tablet AVD (or connect a device with USB debugging).
3. On macOS, double-click `install-on-device.command`, or run:
   ```bash
   adb install -r EditForthAnd-0.2.0-arm64.apk
   adb shell am start -n org.win32forth.editforthand/org.qtproject.qt.android.bindings.QtActivity
   ```

Package: `org.win32forth.editforthand` · `versionCode` 2 · min SDK 26  
This APK is **debug-signed** (not a Play Store release).
