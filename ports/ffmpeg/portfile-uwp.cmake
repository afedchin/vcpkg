# Common Ambient Variables:
#   VCPKG_ROOT_DIR = <C:\path\to\current\vcpkg>
#   TARGET_TRIPLET is the current triplet (x86-windows, etc)
#   PORT is the current port name (zlib, etc)
#   CURRENT_BUILDTREES_DIR = ${VCPKG_ROOT_DIR}\buildtrees\${PORT}
#   CURRENT_PACKAGES_DIR  = ${VCPKG_ROOT_DIR}\packages\${PORT}_${TARGET_TRIPLET}
#

if (NOT VCPKG_CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
	message(FATAL_ERROR "This portfile only supports UWP")
endif()

vcpkg_download_distfile(ARCHIVE
    URLS "https://github.com/FFmpeg/gas-preprocessor/archive/master.zip"
    FILENAME "gas-preprocessor-master.zip"
    SHA512 8de75f4d288458ed9043fb40db08b5fce1cacb747a5ccc7ce37446182e480255e9a2e380083e6154222e2321873a1b58b42ff268dcf1a4727b361e959c61f0ec
)
vcpkg_extract_source_archive(${ARCHIVE})

if (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
	set(UWP_PLATFORM  "arm")
    set(LIB_MACHINE_ARG /machine:ARM)
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x64")
	set(UWP_PLATFORM  "x64")
    set(LIB_MACHINE_ARG /machine:x64)
elseif (VCPKG_TARGET_ARCHITECTURE STREQUAL "x86")
	set(UWP_PLATFORM  "x86")
    set(LIB_MACHINE_ARG /machine:x86)
else ()
	message(FATAL_ERROR "Unsupported architecture")
endif()

if (VCPKG_TARGET_ARCHITECTURE STREQUAL "arm")
  if(NOT EXISTS "${MSYS_ROOT}/usr/bin/gas-preprocessor.pl")
    message(STATUS "Acquiring: gas-preprocessor.pl")
    file(COPY ${CURRENT_BUILDTREES_DIR}/src/gas-preprocessor-master/gas-preprocessor.pl DESTINATION ${MSYS_ROOT}/usr/bin)
  endif()
endif()

include(vcpkg_common_functions)

set(PATH_TO_BUILD_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-dbg)

file(COPY ${CMAKE_CURRENT_LIST_DIR}/BuildFFmpeg.bat DESTINATION ${PATH_TO_BUILD_DIR})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/FFmpegConfig.sh DESTINATION ${PATH_TO_BUILD_DIR})

set(ENV{MSYS2_BIN} ${BASH})
set(ENV{LIB} "${CURRENT_INSTALLED_DIR}/lib;${CURRENT_INSTALLED_DIR}/debug/lib")
set(ENV{INCLUDE} "${CURRENT_INSTALLED_DIR}/include")

message(STATUS "Building ${_csc_PROJECT_PATH} for Debug")
file(MAKE_DIRECTORY ${PATH_TO_BUILD_DIR})
vcpkg_execute_required_process(
	COMMAND ${PATH_TO_BUILD_DIR}/BuildFFmpeg.bat win10 debug ${UWP_PLATFORM} "${CURRENT_PACKAGES_DIR}/debug" "${SOURCE_PATH}"
	WORKING_DIRECTORY ${PATH_TO_BUILD_DIR}
    LOGNAME build-${TARGET_TRIPLET}-dbg
)

set(PATH_TO_BUILD_DIR ${CURRENT_BUILDTREES_DIR}/${TARGET_TRIPLET}-rel)
file(COPY ${CMAKE_CURRENT_LIST_DIR}/BuildFFmpeg.bat DESTINATION ${PATH_TO_BUILD_DIR})
file(COPY ${CMAKE_CURRENT_LIST_DIR}/FFmpegConfig.sh DESTINATION ${PATH_TO_BUILD_DIR})

message(STATUS "Building ${_csc_PROJECT_PATH} for Release")
file(MAKE_DIRECTORY ${PATH_TO_BUILD_DIR})
vcpkg_execute_required_process(
	COMMAND ${PATH_TO_BUILD_DIR}/BuildFFmpeg.bat win10 release ${UWP_PLATFORM} "${CURRENT_PACKAGES_DIR}" "${SOURCE_PATH}"
	WORKING_DIRECTORY ${PATH_TO_BUILD_DIR}
    LOGNAME build-${TARGET_TRIPLET}-rel
)

file(GLOB DEF_FILES ${CURRENT_PACKAGES_DIR}/lib/*.def ${CURRENT_PACKAGES_DIR}/debug/lib/*.def)

foreach(DEF_FILE ${DEF_FILES})
    get_filename_component(DEF_FILE_DIR "${DEF_FILE}" DIRECTORY)
    get_filename_component(DEF_FILE_NAME "${DEF_FILE}" NAME)
    string(REGEX REPLACE "-[0-9]*\\.def" ".lib" OUT_FILE_NAME "${DEF_FILE_NAME}")
    file(TO_NATIVE_PATH "${DEF_FILE}" DEF_FILE_NATIVE)
    file(TO_NATIVE_PATH "${DEF_FILE_DIR}/${OUT_FILE_NAME}" OUT_FILE_NATIVE)
    message(STATUS "Generating ${OUT_FILE_NATIVE}")
    vcpkg_execute_required_process(
        COMMAND lib.exe /def:${DEF_FILE_NATIVE} /out:${OUT_FILE_NATIVE} ${LIB_MACHINE_ARG}
        WORKING_DIRECTORY ${CURRENT_PACKAGES_DIR}
        LOGNAME libconvert-${TARGET_TRIPLET}
    )
endforeach()

file(GLOB EXP_FILES ${CURRENT_PACKAGES_DIR}/lib/*.exp ${CURRENT_PACKAGES_DIR}/debug/lib/*.exp)
file(GLOB LIB_FILES ${CURRENT_PACKAGES_DIR}/bin/*.lib ${CURRENT_PACKAGES_DIR}/debug/bin/*.lib)
file(GLOB EXE_FILES ${CURRENT_PACKAGES_DIR}/bin/*.exe ${CURRENT_PACKAGES_DIR}/debug/bin/*.exe)
set(FILES_TO_REMOVE ${EXP_FILES} ${LIB_FILES} ${DEF_FILES} ${EXE_FILES})
list(LENGTH FILES_TO_REMOVE FILES_TO_REMOVE_LEN)
if(FILES_TO_REMOVE_LEN GREATER 0)
    file(REMOVE ${FILES_TO_REMOVE})
endif()
file(REMOVE_RECURSE ${CURRENT_PACKAGES_DIR}/debug/include ${CURRENT_PACKAGES_DIR}/debug/share)

vcpkg_copy_pdbs()

# Handle copyright
# TODO: Examine build log and confirm that this license matches the build output
file(COPY ${SOURCE_PATH}/COPYING.LGPLv2.1 DESTINATION ${CURRENT_PACKAGES_DIR}/share/ffmpeg)
file(RENAME ${CURRENT_PACKAGES_DIR}/share/ffmpeg/COPYING.LGPLv2.1 ${CURRENT_PACKAGES_DIR}/share/ffmpeg/copyright)
