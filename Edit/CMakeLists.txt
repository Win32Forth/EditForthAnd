cmake_minimum_required(VERSION 3.21)
project(EditForthAndEditor LANGUAGES C CXX)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 REQUIRED COMPONENTS Widgets Network)
qt_standard_project_setup()

set(EDIT_SOURCES
    src/main.cpp
    src/MainWindow.cpp
    src/CodeEdit.cpp
    src/DebugBar.cpp
    src/DiskDiff.cpp
    src/FindBar.cpp
    src/FolderSearch.cpp
    src/ForthConsole.cpp
    src/WebTab.cpp
    src/AskForth.cpp
    src/AskForthEmbed.cpp
    src/WheelScroll.cpp
)

if(ANDROID)
    # Header listed so AUTOMOC sees Q_OBJECT (cpp name is ForthPipe_android.cpp).
    list(APPEND EDIT_SOURCES src/ForthPipe.h src/ForthPipe_android.cpp)
else()
    list(APPEND EDIT_SOURCES src/ForthPipe.cpp)
endif()

qt_add_executable(editforthand ${EDIT_SOURCES})

target_link_libraries(editforthand PRIVATE Qt6::Widgets Qt6::Network)

if(WIN32)
    target_link_libraries(editforthand PRIVATE advapi32)
    # Windows keeps the historical editforthwin{arch}.exe names when built there.
    set(EDITFORTH_ARCH "" CACHE STRING "arm64 or x64 suffix for the editor executable")
    if(NOT EDITFORTH_ARCH)
        if(CMAKE_CXX_COMPILER_ARCHITECTURE_ID MATCHES "ARM64")
            set(EDITFORTH_ARCH "arm64")
        else()
            set(EDITFORTH_ARCH "x64")
        endif()
    endif()
    set_target_properties(editforthand PROPERTIES
        OUTPUT_NAME "editforthwin${EDITFORTH_ARCH}"
        WIN32_EXECUTABLE TRUE
    )
endif()

if(ANDROID)
    get_filename_component(EDITFORTHAND_ROOT "${CMAKE_CURRENT_SOURCE_DIR}/.." ABSOLUTE)
    set(FORTH_ROOT "${EDITFORTHAND_ROOT}/Forth")
    set(ARM64_ANDROID "${FORTH_ROOT}/kernel/arm64-android")
    set(HOST_ANDROID "${FORTH_ROOT}/host/android")

    enable_language(ASM)
    set(CMAKE_ASM_FLAGS "${CMAKE_ASM_FLAGS} -fPIC -I${FORTH_ROOT}")

    set(KERNEL_ASM
        ${ARM64_ANDROID}/state.S
        ${ARM64_ANDROID}/emit.S
        ${ARM64_ANDROID}/boot_begin.S
        ${ARM64_ANDROID}/prims.S
        ${ARM64_ANDROID}/prims_k1.S
        ${ARM64_ANDROID}/prims_k2.S
        ${ARM64_ANDROID}/prims_k3.S
        ${ARM64_ANDROID}/sa_print.S
        ${ARM64_ANDROID}/sa_files.S
        ${ARM64_ANDROID}/sa_float.S
        ${ARM64_ANDROID}/prims_dbg.S
        ${ARM64_ANDROID}/dict.S
        ${ARM64_ANDROID}/entry.S
        ${ARM64_ANDROID}/cold.S
        ${ARM64_ANDROID}/identity.S
        ${ARM64_ANDROID}/boot_end.S
    )

    add_library(forthnative SHARED
        ${HOST_ANDROID}/emit_buf.c
        ${HOST_ANDROID}/host_android.c
        ${HOST_ANDROID}/host_file_android.c
        ${HOST_ANDROID}/host_float.c
        ${HOST_ANDROID}/host_view.c
        ${KERNEL_ASM}
    )
    target_include_directories(forthnative PUBLIC
        ${HOST_ANDROID}
        ${FORTH_ROOT}/include
    )
    find_library(log-lib log)
    target_link_libraries(forthnative PUBLIC ${log-lib} m)
    target_link_options(forthnative PRIVATE "-Wl,--no-undefined")

    target_include_directories(editforthand PRIVATE
        ${HOST_ANDROID}
        ${FORTH_ROOT}/include
    )
    target_link_libraries(editforthand PRIVATE forthnative)
    find_library(log-lib-ui log)
    if(log-lib-ui)
        target_link_libraries(editforthand PRIVATE ${log-lib-ui})
    endif()
    target_sources(editforthand PRIVATE
        src/AndroidShip.cpp
        src/AndroidShip.h
    )

    # Bundle Forth/Resources into the APK as assets:/EditForthAnd/…
    set(ANDROID_ASSET_SHIP "${CMAKE_CURRENT_SOURCE_DIR}/android/assets/EditForthAnd")
    set(ANDROID_ASSET_STAMP "${ANDROID_ASSET_SHIP}/.stamp")
    add_custom_command(
        OUTPUT "${ANDROID_ASSET_STAMP}"
        COMMAND ${CMAKE_COMMAND} -E rm -rf "${ANDROID_ASSET_SHIP}"
        COMMAND ${CMAKE_COMMAND} -E make_directory "${ANDROID_ASSET_SHIP}"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                "${FORTH_ROOT}/Resources/Library" "${ANDROID_ASSET_SHIP}/Library"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                "${FORTH_ROOT}/Resources/AutoLoad" "${ANDROID_ASSET_SHIP}/AutoLoad"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                "${FORTH_ROOT}/Resources/Docs" "${ANDROID_ASSET_SHIP}/Docs"
        COMMAND ${CMAKE_COMMAND} -E copy_directory
                "${FORTH_ROOT}/Resources/Config" "${ANDROID_ASSET_SHIP}/Config"
        COMMAND ${CMAKE_COMMAND} -E touch "${ANDROID_ASSET_STAMP}"
        COMMENT "Sync Forth Resources into Edit/android/assets for APK"
        VERBATIM
    )
    add_custom_target(android_ship_resources DEPENDS "${ANDROID_ASSET_STAMP}")
    add_dependencies(editforthand android_ship_resources)

    set_target_properties(editforthand PROPERTIES
        QT_ANDROID_PACKAGE_SOURCE_DIR "${CMAKE_CURRENT_SOURCE_DIR}/android"
        QT_ANDROID_TARGET_SDK_VERSION 35
        QT_ANDROID_MIN_SDK_VERSION 26
    )
endif()
