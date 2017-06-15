# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)

set(VCPKG_LIBRARY_LINKAGE static)

set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/crossguid-8f399e8bd4252be9952f3dfa8199924cc8487ca4)
vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/graeme-hill/crossguid/archive/8f399e8bd4252be9952f3dfa8199924cc8487ca4.zip"
    FILENAME "8f399e8bd4252be9952f3dfa8199924cc8487ca4.zip"
    SHA512 7de417cdb11325711891b21d55ecd4484c2e31a09d097af0818e3a965e6cf263031d98cefe3f2f42eb9fa69a10860c0775102b6fd637566d3040e13b6b77993a
)
vcpkg_extract_source_archive(${ARCHIVE})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

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
file(COPY ${SOURCE_PATH}/LICENSE DESTINATION ${CURRENT_PACKAGES_DIR}/share/crossguid)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/crossguid/LICENSE ${CURRENT_PACKAGES_DIR}/share/crossguid/copyright)
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/crossguid.lib ${CURRENT_PACKAGES_DIR}/debug/lib/crossguidd.lib)
