# Common Ambient Variables:
#   CURRENT_BUILDTREES_DIR    = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR      = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#   CURRENT_PORT DIR          = ${VCPKG_ROOT_DIR}\ports\${PORT}
#   PORT                      = current port name (zlib, etc)
#   TARGET_TRIPLET            = current triplet (x86-windows, x64-windows-static, etc)
#   VCPKG_CRT_LINKAGE         = C runtime linkage type (static, dynamic)
#   VCPKG_LIBRARY_LINKAGE     = target library linkage type (static, dynamic)
#   VCPKG_ROOT_DIR            = <C:\path\to\current\vcpkg>
#   VCPKG_TARGET_ARCHITECTURE = target architecture (x64, x86, arm)
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libmicrohttpd-0.9.55)
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnu.org/gnu/libmicrohttpd/libmicrohttpd-0.9.55.tar.gz"
    FILENAME "libmicrohttpd-0.9.55.tar.gz"
    SHA512 b410e7253d7c98c40b5e8b8dcd1f93bcbb05c88717190e8dae73073d36465e8e5cfa53c6c5098de60051a5ec64dc423fd94f4b06537d8146b744aa99f5a0b173
)
vcpkg_extract_source_archive(${ARCHIVE})

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
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
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libmicrohttpd)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libmicrohttpd/COPYING ${CURRENT_PACKAGES_DIR}/share/libmicrohttpd/copyright)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/libmicrohttpd.lib ${CURRENT_PACKAGES_DIR}/debug/lib/libmicrohttpd_d.lib)

vcpkg_copy_pdbs()
