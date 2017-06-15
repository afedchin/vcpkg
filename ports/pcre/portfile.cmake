# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

set(PCRE_VERSION 8.40)
include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/pcre-${PCRE_VERSION})
vcpkg_download_distfile(ARCHIVE
    URLS "ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-${PCRE_VERSION}.zip" 
         "https://downloads.sourceforge.net/project/pcre/pcre/${PCRE_VERSION}/pcre-${PCRE_VERSION}.zip"
    FILENAME "pcre-${PCRE_VERSION}.zip"
    SHA512 121c0389a739a2a1d7d5d87e5f15167601739ddfab9eed66a1f55b5bbadadb58730208430f5ad069f9342c9a84ee1817dfa07efc802c29c84f86147714ee8eff
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/fix-option.patch
            ${CMAKE_CURRENT_LIST_DIR}/fix-option-2.patch
            ${CMAKE_CURRENT_LIST_DIR}/fix-arm-config-define.patch
            ${CMAKE_CURRENT_LIST_DIR}/fix-linkage-to-kernel32.patch
            ${CMAKE_CURRENT_LIST_DIR}/fix-pdbs.patch
            )

set(VCPKG_LIBRARY_LINKAGE static)
vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    #PREFER_NINJA
    OPTIONS -DPCRE_BUILD_TESTS=NO
            -DPCRE_BUILD_PCREGREP=NO
            -DINSTALL_DOC:BOOL=OFF
            -DINSTALL_MSVC_PDB=ON
            -DPCRE_MATCH_LIMIT_RECURSION=1500
            -DPCRE_NEWLINE=ANYCRLF
            -DPCRE_SUPPORT_JIT=YES
            -DPCRE_SUPPORT_UTF=YES
            -DPCRE_SUPPORT_UNICODE_PROPERTIES=YES
            # optional dependencies for PCREGREP
            -DPCRE_SUPPORT_LIBBZ2=OFF
            -DPCRE_SUPPORT_LIBZ=OFF
            -DPCRE_SUPPORT_LIBEDIT=OFF
            -DPCRE_SUPPORT_LIBREADLINE=OFF
)

vcpkg_install_cmake(RELEASE_CONFIG RelWithDebInfo)



file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/share)

file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/man)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/share/doc)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/pcre)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/pcre/COPYING ${CURRENT_PACKAGES_DIR}/share/pcre/copyright)

vcpkg_copy_pdbs()