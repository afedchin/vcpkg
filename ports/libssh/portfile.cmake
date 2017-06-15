# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libssh-master)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/xbmc/libssh/archive/master.zip"
    FILENAME "libssh-master.zip"
    SHA512 35b68f46912685954def328d3fa1db8e9366d28a7cb7017c5b2d2d897c0594d391f6cb9e9dde1046da348b8b8aa752bb58a33169b4d0ce2c234468681cf86669
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
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libssh)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libssh/COPYING ${CURRENT_PACKAGES_DIR}/share/libssh/copyright)

# Handle CMake files
file(RENAME ${CURRENT_PACKAGES_DIR}/CMake/libssh/libssh-config-version.cmake ${CURRENT_PACKAGES_DIR}/share/libssh/libssh-config-version.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/CMake/libssh/libssh-config.cmake ${CURRENT_PACKAGES_DIR}/share/libssh/libssh-config.cmake)

file(MAKE_DIRECTORY ${CURRENT_PACKAGES_DIR}/share/libssh/debug)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/CMake/libssh/libssh-config-version.cmake ${CURRENT_PACKAGES_DIR}/share/libssh/debug/libssh-config-version.cmake)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/CMake/libssh/libssh-config.cmake ${CURRENT_PACKAGES_DIR}/share/libssh/debug/libssh-config.cmake)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/CMake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/CMake)

vcpkg_copy_pdbs()
