cmake_minimum_required(VERSION 3.0)
project(libmicrohttpd LANGUAGES C VERSION 0.9.55)

if(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(LIB_SUFFIX d)
endif()

add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS)
add_definitions(-D_WIN32 -DMHD_W32DLL -D_USRDLL -DBUILDING_MHD_LIB)

if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    add_definitions(-D_WIN32_WINNT=0x0A00)
endif()

add_library(libmicrohttpd
  src/include/autoinit_funcs.h
  src/include/mhd_options.h
  src/include/microhttpd.h
  src/include/platform.h
  src/microhttpd/base64.c
  src/microhttpd/base64.h
  src/microhttpd/basicauth.c
  src/microhttpd/connection.c
  src/microhttpd/connection.h
  src/microhttpd/daemon.c
  src/microhttpd/digestauth.c
  src/microhttpd/internal.c
  src/microhttpd/internal.h
  src/microhttpd/md5.c
  src/microhttpd/md5.h
  src/microhttpd/memorypool.c
  src/microhttpd/memorypool.h
  src/microhttpd/mhd_byteorder.h
  src/microhttpd/mhd_compat.c
  src/microhttpd/mhd_compat.h
  src/microhttpd/mhd_itc.c
  src/microhttpd/mhd_itc.h
  src/microhttpd/mhd_itc_types.h
  src/microhttpd/mhd_limits.h
  src/microhttpd/mhd_locks.h
  src/microhttpd/mhd_mono_clock.c
  src/microhttpd/mhd_mono_clock.h
  src/microhttpd/mhd_sockets.c
  src/microhttpd/mhd_sockets.h
  src/microhttpd/mhd_str.c
  src/microhttpd/mhd_str.h
  src/microhttpd/mhd_threads.c
  src/microhttpd/mhd_threads.h
  src/microhttpd/postprocessor.c
  src/microhttpd/reason_phrase.c
  src/microhttpd/response.c
  src/microhttpd/response.h
  src/microhttpd/sysfdsetsize.c
  src/microhttpd/sysfdsetsize.h
  src/microhttpd/tsearch.c
  src/microhttpd/tsearch.h
  w32/common/MHD_config.h
)

target_include_directories(
  libmicrohttpd PRIVATE
  $<BUILD_INTERFACE:src/include;src/microhttpd;src/platform;w32/common>
  INTERFACE
  $<INSTALL_INTERFACE:include>
)

if(MSVC)
  target_compile_definitions(libmicrohttpd PRIVATE MHD_W32LIB)
  set_target_properties(libmicrohttpd PROPERTIES COMPILE_PDB_OUTPUT_DIRECTORY ${PROJECT_BINARY_DIR} COMPILE_PDB_NAME libmicrohttpd COMPILE_PDB_NAME_DEBUG libmicrohttpd_d)
  install(FILES ${PROJECT_BINARY_DIR}/RelWithDebInfo/libmicrohttpd.pdb DESTINATION lib CONFIGURATIONS RelWithDebInfo)
  install(FILES ${PROJECT_BINARY_DIR}/Debug/libmicrohttpd_d.pdb DESTINATION lib CONFIGURATIONS Debug)
endif()

install(TARGETS libmicrohttpd
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

install(FILES
  src/include/microhttpd.h
  DESTINATION include)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        src/include/microhttpd.h
        DESTINATION include)
endif()


