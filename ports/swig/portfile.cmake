# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/swig-3.0.10-win32/project/BuildDependencies/Bin/)
vcpkg_download_distfile(ARCHIVE
    URLS "http://mirrors.xbmc.org/build-deps/win32/swig-3.0.10-win32.7z"
    FILENAME "swig-3.0.10-win32.7z"
    SHA512 f1a87099e6f16ede2f47f88829265e0789eed8ca6681359f7b26fcbcf81f73aeb8c4fe880afc5f20f7f263140ee883e110af535fd73accfe191bd98aa158ab26
)
vcpkg_extract_source_archive(${ARCHIVE})

# Handle copyright
file(COPY ${CMAKE_CURRENT_LIST_DIR}/copyright DESTINATION ${CURRENT_PACKAGES_DIR}/share/swig)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/swig-readme.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

# copy swig
file(MAKE_DIRECTORY ${VCPKG_ROOT_DIR}/../BuildDependencies/bin)
file(COPY ${SOURCE_PATH} DESTINATION ${VCPKG_ROOT_DIR}/../BuildDependencies/bin)

