cmake_minimum_required(VERSION 3.0)
project(libass)

find_package(Freetype REQUIRED) # fails to find debug lib
if(CMAKE_BUILD_TYPE MATCHES Debug)
    find_library(FREETYPE_DEBUG_LIBRARY freetyped)
    set(FREETYPE_ACTUAL_LIBRARY ${FREETYPE_DEBUG_LIBRARY})
else()
    set(FREETYPE_ACTUAL_LIBRARY ${FREETYPE_LIBRARY})
endif()



find_library(FONTCONFIG_LIBRARY fontconfig)
find_library(HARFBUZZ_LIBRARY harfbuzz)
find_library(ICONV_LIBRARY NAMES iconv libiconv)
find_library(FRIBIDI_LIBRARY NAMES fribidi libfribidi)

find_path(FREETYPE_INCLUDE_DIR ft2build.h)
find_path(HARFBUZZ_INCLUDE_DIR harfbuzz/hb.h)
find_path(FRIBIDI_INCLUDE_DIR fribidi/fribidi.h)


if(CMAKE_BUILD_TYPE STREQUAL Debug)
    set(LIB_SUFFIX d)
endif()

add_definitions(-DWIN32)
add_definitions(-D_CRT_SECURE_NO_DEPRECATE)

add_library(libass
    libass/ass.c
    libass/ass_bitmap.c
    libass/ass_blur.c
    libass/ass_cache.c
    libass/ass_directwrite.c
    libass/ass_drawing.c
    libass/ass_font.c
    libass/ass_fontconfig.c
    libass/ass_fontselect.c
    libass/ass_library.c
    libass/ass_parse.c
    libass/ass_rasterizer.c
    libass/ass_rasterizer_c.c
    libass/ass_render.c
    libass/ass_render_api.c
    libass/ass_shaper.c
    libass/ass_shaper.c
    libass/ass_string.c
    libass/ass_strtod.c
    libass/ass_utils.c
    Win32/ass_uwp.cpp)

target_link_libraries(libass ${FREETYPE_ACTUAL_LIBRARY} ${FONTCONFIG_LIBRARY} ${HARFBUZZ_LIBRARY} ${ICONV_LIBRARY} ${FRIBIDI_LIBRARY})
target_include_directories(libass PRIVATE . Win32 ${FREETYPE_INCLUDE_DIR} ${HARFBUZZ_INCLUDE_DIR}/harfbuzz ${FRIBIDI_INCLUDE_DIR}/fribidi)

install(TARGETS libass
    RUNTIME DESTINATION bin
    LIBRARY DESTINATION lib
    ARCHIVE DESTINATION lib)

if(NOT FC_SKIP_HEADERS)
    install(FILES
        libass/ass.h
        libass/ass_bitmap.h
        libass/ass_cache.h
        libass/ass_cache_template.h
        libass/ass_compat.h
        libass/ass_directwrite.h
        libass/ass_drawing.h
        libass/ass_font.h
        libass/ass_fontconfig.h
        libass/ass_fontselect.h
        libass/ass_func_template.h
        libass/ass_library.h
        libass/ass_parse.h
        libass/ass_rasterizer.h
        libass/ass_render.h
        libass/ass_shaper.h
        libass/ass_string.h
        libass/ass_types.h
        libass/ass_utils.h
        DESTINATION include/ass)
endif()


