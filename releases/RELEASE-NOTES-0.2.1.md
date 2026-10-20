## EditForthAnd 0.2.1

Android arm64-v8a build for emulator / USB sideload.

### Highlights
- Fix `TIME&DATE` / `host_time_date` (kernel `out[6]` ABI) — stops Facility / ANS crashes
- Live Forth emit to logcat (batched UI flush) for long FLOAD / validation suites
- Hayes **PASS** (`ALL COUNTS ZERO`); ANS-VALIDATE still incomplete on `/tmp` File-Access / Block (see `docs/android-host.md`)

### Install
1. Download **EditForthAnd-0.2.1-arm64.zip** (recommended), or the `.apk` plus `install-on-device.command`.
2. Start a tablet AVD (or connect a device with USB debugging).
3. On macOS, double-click `install-on-device.command`, or run:
   ```bash
   adb install -r EditForthAnd-0.2.1-arm64.apk
   adb shell am start -n org.win32forth.editforthand/org.qtproject.qt.android.bindings.QtActivity
   ```

Package: `org.win32forth.editforthand` · `versionCode` 3 · min SDK 26  
This APK is **debug-signed** (not a Play Store release).
