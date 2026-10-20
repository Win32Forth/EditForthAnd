# Qt for Android setup (EditForthAnd)

Goal: run the same Qt `Edit/` sources (editor + Forth console) on Android that
EditForthWin uses on Windows.

## Install Qt on the Mac

1. Download the **Qt Online Installer** for macOS:  
   https://www.qt.io/download-open-source  
   (Create / sign in to a Qt account when asked.)

2. Run the installer. Under **Qt 6.x** (prefer 6.12+):

   Check at least:

   - **macOS** (desktop kit — useful for a Mac preview of the same UI)
   - **Android** / **Android arm64-v8a**
   - **CMake**, **Ninja** if offered
   - **Qt Creator** (recommended)

3. Point Qt Creator at your existing Android SDK:

   - **Qt Creator → Settings/Preferences → Devices → Android**
   - JDK: Android Studio’s JBR is fine  
     (`/Applications/Android Studio.app/Contents/jbr/Contents/Home`)
   - SDK: `~/Library/Android/sdk`
   - NDK: `~/Library/Android/sdk/ndk/27.2.12479018` (or another Qt-supported NDK)

4. Confirm **Kits** shows an **Android Qt 6.x arm64-v8a** kit with no red errors.

## Project notes

- Shared UI: `Edit/src/*` (CodeEdit, ForthConsole, MainWindow, …)
- Android packaging: `Edit/android/` + `androiddeployqt`
- Forth engine: `libforthnative.so` from `Forth/kernel/arm64-android` +
  `Forth/host/android`, driven in-process by `ForthPipe_android.cpp`
- Soft-keyboard Enter is handled in `ForthConsole` (IME newline → submit)
- Autoload, virtual `HYPER.SPECS`, and path resolve:
  [android-host.md](android-host.md)

## Build from the command line (verified)

```bash
export JAVA_HOME="/Applications/Android Studio.app/Contents/jbr/Contents/Home"
QT=~/Qt/6.12.0/android_arm64_v8a
SDK=~/Library/Android/sdk
NDK=$SDK/ndk/27.2.12479018
BUILD=~/Documents/XCodeProjects/EditForthAnd/build-android

rm -rf "$BUILD" && mkdir -p "$BUILD" && cd "$BUILD"
"$QT/bin/qt-cmake" -GNinja \
  -DANDROID_SDK_ROOT="$SDK" \
  -DANDROID_NDK_ROOT="$NDK" \
  -DANDROID_ABI=arm64-v8a \
  -DANDROID_PLATFORM=android-26 \
  -DCMAKE_BUILD_TYPE=Debug \
  ../Edit
cmake --build . -j8
```

APK output:

`build-android/android-build/build/outputs/apk/debug/android-build-debug.apk`

Install / stop on a running emulator:

```bash
adb install -r build-android/android-build/build/outputs/apk/debug/android-build-debug.apk
adb shell am start -n org.win32forth.editforthand/org.qtproject.qt.android.bindings.QtActivity
adb shell am force-stop org.win32forth.editforthand
```

## Open in Qt Creator (Run on the tablet)

Do **not** open Android Studio for day-to-day Run. Use Qt Creator.

### Easiest: double-click the launcher

In Finder:

`Documents/XCodeProjects/EditForthAnd/scripts/open-in-qt-creator.command`

That opens Qt Creator on the real project file:

`/Users/thomaszimmer/Documents/XCodeProjects/EditForthAnd/Edit/CMakeLists.txt`

### Or open the file by hand

1. Start **Qt Creator** (`~/Qt/Qt Creator.app`).
2. **File → Open File or Project…**
3. Go to this exact path (copy/paste into the file dialog’s path field if needed):

   `/Users/thomaszimmer/Documents/XCodeProjects/EditForthAnd/Edit/CMakeLists.txt`

   That file is named **`CMakeLists.txt`** inside the **`Edit`** folder
   (sibling of `src/`, not inside Android Studio’s old `Android/` tree — that
   tree was removed).
4. When Creator asks for a kit, check **Qt 6.12.0 for Android arm64-v8a**.
5. Top-left kit selector should show that Android kit. Pick your tablet AVD
   as the Run device.
6. Press the green **Run** button (or Build → Run).

If Creator’s Stop button does not clear a “Running” session, use:

```bash
adb shell am force-stop org.win32forth.editforthand
```
