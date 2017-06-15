# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/c-pluff-0.1.3)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/jlehtine/c-pluff/archive/0.1.3.zip"
    FILENAME "c-pluff-0.1.3.zip"
    SHA512 cc68c40beea57e75771d100fa6a1e68cf58b6f272fa3e505d58b6da0bb3af7c2def0be928a0aaae67308bd9cb3cce4c613355f95abfd9302a823bb1941efe11a
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-xbmc.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/win32/ DESTINATION ${SOURCE_PATH}/libcpluff/win32/)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    # PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYRIGHT.txt DESTINATION ${CURRENT_PACKAGES_DIR}/share/cpluff)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/cpluff//COPYRIGHT.txt ${CURRENT_PACKAGES_DIR}/share/cpluff/copyright)
