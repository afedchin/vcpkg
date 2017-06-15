# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libnfs-master)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/xbmc/libnfs/archive/master.zip"
    FILENAME "libnfs-master.zip"
    SHA512 5a6d81aca4791391420deed9c46771661444cae9c2cce749240372b55aa39480cc9efcdc97aa8b9a6a3f960486e33ca8745855ec31794d4ea94644572b92fd1c
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-uwp.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    # OPTIONS -DUSE_THIS_IN_ALL_BUILDS=1 -DUSE_THIS_TOO=2
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libnfs)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libnfs/COPYING ${CURRENT_PACKAGES_DIR}/share/libnfs/copyright)

# Handle CMake files
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libnfs/libnfs-config-version.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/libnfs-config-version.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libnfs/libnfs-config.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/libnfs-config.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libnfs/libnfs-release.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/libnfs-release.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/lib/cmake/libnfs/libnfs.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/libnfs.cmake)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/libnfs/debug)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libnfs/libnfs-config-version.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/debug/libnfs-config-version.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libnfs/libnfs-config.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/debug/libnfs-config.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libnfs/libnfs-debug.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/debug/libnfs-debug.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libnfs/libnfs.cmake ${CURRENT_PACKAGES_DIR}/share/libnfs/debug/libnfs.cmake)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

vcpkg_copy_pdbs()
