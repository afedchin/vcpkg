
include(vcpkg_common_functions)
set(SOURCE_PATH ${CURRENT_BUILDTREES_DIR}/src/libcdio-0.94)
vcpkg_download_distfile(ARCHIVE
    URLS "https://ftp.gnu.org/gnu/libcdio/libcdio-0.94.tar.gz"
    FILENAME "libcdio-0.94.tar.gz"
    SHA512 e1d3c96c4acc7be923c97109c3f76223adc00b293278daef7d5008b1e5d67f33402f9f224f05120e9e1e8b3a8d1fa1b0bd5069dc6dd309741e3590e2c19e0e66
)
vcpkg_extract_source_archive(${ARCHIVE})

vcpkg_apply_patches(
    SOURCE_PATH ${SOURCE_PATH}
    PATCHES ${CMAKE_CURRENT_LIST_DIR}/libcdio.patch
)

vcpkg_configure_cmake(
    SOURCE_PATH ${SOURCE_PATH}
    PREFER_NINJA # Disable this option if project cannot be built with Ninja
)

vcpkg_install_cmake(RELEASE_CONFIG RelWithDebInfo)

file(COPY ${CURRENT_PACKAGES_DIR}/debug/lib/cmake/libcdio DESTINATION ${CURRENT_PACKAGES_DIR}/share)
file(COPY ${CURRENT_PACKAGES_DIR}/lib/cmake/libcdio DESTINATION ${CURRENT_PACKAGES_DIR}/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/share)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/lib/cmake)
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/lib/cmake)

# Handle copyright
file(COPY ${SOURCE_PATH}/COPYING DESTINATION ${CURRENT_PACKAGES_DIR}/share/libcdio)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/libcdio/COPYING ${CURRENT_PACKAGES_DIR}/share/libcdio/copyright)
