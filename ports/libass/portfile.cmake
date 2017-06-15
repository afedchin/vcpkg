# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libass-3b08a1dcb5be8ef42feafdfcbe6a8be97f9a4a9e)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/libass/libass/archive/3b08a1dcb5be8ef42feafdfcbe6a8be97f9a4a9e.zip"
    FILENAME "3b08a1dcb5be8ef42feafdfcbe6a8be97f9a4a9e.zip"
    SHA512 7f1315f6cb35251b974bc35f8ce6ca0129bbbb65ad68f4a5ea1c2c78adaf582a0c5ad506c130d65488eee33476198f5ca6e7422babcff9cdc5d12002d0365b79
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/0001-Fix-uwp.patch
)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/Win32 DESTINATION ${SOURCE_PATH})

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    #PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=True
    # OPTIONS_RELEASE -DOPTIMIZE=1
    # OPTIONS_DEBUG -DDEBUGGABLE=1
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libass)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libass/COPYING ${CURRENT_PACKAGES_DIR}/share/libass/copyright)

vcpkg_copy_pdbs()

