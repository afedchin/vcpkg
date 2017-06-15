# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/tinyxml)
vcpkg_download_distfile(ARCHIVE
    URLS "https://downloads.sourceforge.net/project/tinyxml/tinyxml/2.6.2/tinyxml_2_6_2.zip"
    FILENAME "tinyxml_2_6_2.zip"
    SHA512 eb9aead0b500e36f65cae234732854567ebad450d312d95a0998e0f68cbdd661dc5abd17aaed4af810c72bd491a30316298653095616f52ab5a656863c9ecb9b
)
vcpkg_extract_source_archive(${ARCHIVE})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/CMakeLists.txt DESTINATION ${SOURCE_PATH})

set(VCPKG_LIBRARY_LINKAGE static)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
    OPTIONS -DCMAKE_WINDOWS_EXPORT_ALL_SYMBOLS=True
)

vcpkg_install_cmake()

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)

# Handle copyright
file(WRITE ${CURRENT_PACKAGES_DIR}/share/tinyxml/copyright "dummy")
file(RENAME ${CURRENT_PACKAGES_DIR}/debug/lib/tinyxmlSTL.lib ${CURRENT_PACKAGES_DIR}/debug/lib/tinyxmlSTLd.lib)

vcpkg_copy_pdbs()
