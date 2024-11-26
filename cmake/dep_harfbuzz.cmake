#FindHARFBUZZ.cmake:FIND_PACKAGE_HANDLE_STANDARD_ARGS(HARFBUZZ REQUIRED_VARS HARFBUZZ_LIBRARY HARFBUZZ_INCLUDE_DIR VERSION_VAR HARFBUZZ_VERSION HANDLE_COMPONENTS) 
if(NOT TARGET harfbuzz)
    set(LIBNAME      harfbuzz )
    set(LIB_DIR_NAME harfbuzz-5.1.0)

    set(ALL_LIB_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/../thirdparty)
    set(ALL_LIB_BIN_DIR ${CMAKE_BINARY_DIR}/thirdparty)

    set(${LIBNAME}_SRC_DIR ${ALL_LIB_SRC_DIR}/${LIBNAME})
    set(${LIBNAME}_BIN_DIR ${ALL_LIB_BIN_DIR}/${LIBNAME})

    message("${LIBNAME}_SRC_DIR:${${LIBNAME}_SRC_DIR}")
    message("${LIBNAME}_BIN_DIR:${${LIBNAME}_BIN_DIR}")

    if(CMAKE_SYSTEM_NAME MATCHES "Linux")
        add_compile_definitions(DYZ)
    endif()
    add_subdirectory(${${LIBNAME}_SRC_DIR}/)
endif()

set(HARFBUZZ_ROOT_DIR     ${${LIBNAME}_SRC_DIR})

set(HARFBUZZ_INCLUDE_DIRS ${HARFBUZZ_ROOT_DIR}/src     ${HARFBUZZ_ROOT_DIR}/include  ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/include  )
set(HARFBUZZ_LIBRARY_DIRS ${HARFBUZZ_ROOT_DIR}         ${HARFBUZZ_ROOT_DIR}/lib      ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/lib      ${${LIBNAME}_BIN_DIR}/Debug)

set(HARFBUZZ_LIBRARY   $<TARGET_OBJECTS:harfbuzz> $<TARGET_OBJECTS:harfbuzz-subset>)
set(HARFBUZZ_LIBRARIES $<TARGET_OBJECTS:harfbuzz> $<TARGET_OBJECTS:harfbuzz-subset>)

#include_directories(${HARFBUZZ_INCLUDE_DIRS}  )
#link_directories   (${HARFBUZZ_LIBRARY_DIRS}  )
