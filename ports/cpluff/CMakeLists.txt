cmake_minimum_required(VERSION 3.0)
project(cpluff)

add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS -D_CRT_NONSTDC_NO_DEPRECATE)
add_definitions(-DXML_STATIC -D_USRDLL -DCP_C_API=CP_EXPORT)

if(CMAKE_SYSTEM_NAME STREQUAL "WindowsStore")
    add_definitions(-D_WIN32_WINNT=0x0A00)
endif()

find_path(EXPAT_INCLUDE_DIR expat.h)
find_library(EXPAT_LIBRARY expat)

add_library(cpluff
    libcpluff/context.c
    libcpluff/cpluff.c
    libcpluff/logging.c
    libcpluff/pcontrol.c
    libcpluff/pinfo.c
    libcpluff/ploader.c
    libcpluff/pscan.c
    libcpluff/psymbol.c
    libcpluff/serial.c
    libcpluff/thread_windows.c
    libcpluff/util.c
    libcpluff/win32/dirent.c
    kazlib/hash.c
    kazlib/list.c)

target_include_directories(cpluff PRIVATE ./libcpluff ./libcpluff/win32 ./kazlib ${EXPAT_INCLUDE_DIR})

target_link_libraries(cpluff ${EXPAT_LIBRARY})


install(TARGETS cpluff
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        libcpluff/cpluff.h
        DESTINATION include)
endif()


