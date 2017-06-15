include(vcpkg_common_functions)

if (NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    message(FATAL_ERROR "This portfile only supports UWP")
endif()

if (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
    set(COCOS_PLATFORM  "arm")
    set(VCPKG_PLATFORM  "arm")
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
    set(COCOS_PLATFORM  "x64")
    set(VCPKG_PLATFORM  "x64")
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
    set(COCOS_PLATFORM  "win32")
    set(VCPKG_PLATFORM  "x86")
else ()
    message(FATAL_ERROR "Unsupported architecture")
endif()

# Put the licence file where vcpkg expects it
file(COPY ${CMAKE_CURRENT_LIST_DIR}/LICENSE.GPL DESTINATION ${CURRENT_PACKAGES_DIR}/share/kodi-deps)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/kodi-deps/LICENSE.GPL ${CURRENT_PACKAGES_DIR}/share/kodi-deps/copyright)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/license.h DESTINATION ${CURRENT_PACKAGES_DIR}/include)

#[[
# We are going to copy everything to the kodi-deps dir
SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps)

#remove the previous output files
#file(REMOVE_RECURSE ${OUTPUT_PATH})

# Copy the curl header files
if (VCPKG_PLATFORM STREQUAL "x86")
    SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../curl_x86-uwp)
    SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/curl/include/win10)
    file(REMOVE_RECURSE ${OUTPUT_PATH})
    file(COPY ${SOURCE_PATH}/include/curl DESTINATION ${OUTPUT_PATH})
endif()

# Copy the curl files
SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../curl_${VCPKG_PLATFORM}-uwp)
SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/curl/prebuilt/win10/${COCOS_PLATFORM}/)
file(REMOVE_RECURSE ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/bin/libcurl.dll DESTINATION ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/lib/libcurl_imp.lib DESTINATION ${OUTPUT_PATH})

# Copy the openssl header files
if (VCPKG_PLATFORM STREQUAL "x86")
    SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../openssl_x86-uwp)
    SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/openssl/include/win10)
    file(REMOVE_RECURSE ${OUTPUT_PATH})
    file(COPY ${SOURCE_PATH}/include/openssl DESTINATION ${OUTPUT_PATH})
endif()

# Copy the openssl files
SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../openssl_${VCPKG_PLATFORM}-uwp)
SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/openssl/prebuilt/win10/${COCOS_PLATFORM}/)
file(REMOVE_RECURSE ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/bin/libeay32.dll DESTINATION ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/bin/ssleay32.dll DESTINATION ${OUTPUT_PATH})

# Copy the freetype header files
if (VCPKG_PLATFORM STREQUAL "x86")
    SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../freetype_x86-uwp)
    SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/freetype2/include/win10)
    file(REMOVE_RECURSE ${OUTPUT_PATH})
    file(COPY ${SOURCE_PATH}/include/freetype DESTINATION ${OUTPUT_PATH})
    file(COPY ${SOURCE_PATH}/include/ft2build.h DESTINATION ${OUTPUT_PATH})
endif()

# Copy the freetype files
SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../freetype_${VCPKG_PLATFORM}-uwp)
SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/freetype2/prebuilt/win10/${COCOS_PLATFORM}/)
file(REMOVE_RECURSE ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/lib/freetype.lib DESTINATION ${OUTPUT_PATH})

# Copy the sqlite3 files
# cocos2d-x already provides the header files
SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../sqlite3_${VCPKG_PLATFORM}-uwp)
SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/sqlite3/libraries/win10/${COCOS_PLATFORM}/)
file(REMOVE_RECURSE ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/bin/sqlite3.dll DESTINATION ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/lib/sqlite3.lib DESTINATION ${OUTPUT_PATH})


# Copy the zlib header files
if (VCPKG_PLATFORM STREQUAL "x86")
    SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../zlib_x86-uwp)
    SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/win10-specific/zlib)
    file(REMOVE_RECURSE ${OUTPUT_PATH})
    file(COPY ${SOURCE_PATH}/include DESTINATION ${OUTPUT_PATH})
endif()

# Copy the zlib files
SET(SOURCE_PATH ${CURRENT_PACKAGES_DIR}/../zlib_${VCPKG_PLATFORM}-uwp)
SET(OUTPUT_PATH ${CURRENT_PACKAGES_DIR}/../kodi-deps/win10-specific/zlib/prebuilt/${COCOS_PLATFORM}/)
file(REMOVE_RECURSE ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/bin/zlib1.dll DESTINATION ${OUTPUT_PATH})
file(COPY ${SOURCE_PATH}/lib/zlib.lib DESTINATION ${OUTPUT_PATH})
]]





