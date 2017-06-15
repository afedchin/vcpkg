cmake_minimum_required(VERSION 3.0)
project(crossguid)

add_definitions(-D_CRT_SECURE_NO_WARNINGS -D_CRT_NONSTDC_NO_WARNINGS)

if(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(LIB_SUFFIX d)
endif()

add_definitions(-DWIN32)
add_definitions(-DGUID_WINDOWS)

add_library(crossguid guid.cpp)

target_include_directories(crossguid PRIVATE .)

install(TARGETS crossguid
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        guid.h
        DESTINATION include)
endif()


