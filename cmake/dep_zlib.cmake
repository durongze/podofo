#FindZLIB.cmake:FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZLIB REQUIRED_VARS ZLIB_LIBRARY ZLIB_INCLUDE_DIR VERSION_VAR ZLIB_VERSION HANDLE_COMPONENTS) 
if(NOT TARGET zlib)
    set(LIBNAME      zlib)
    set(LIB_DIR_NAME zlib-1.2.12)

    set(ALL_LIB_SRC_DIR ${CMAKE_CURRENT_LIST_DIR}/../thirdparty)
    set(ALL_LIB_BIN_DIR ${CMAKE_BINARY_DIR}/thirdparty)

    set(${LIBNAME}_SRC_DIR ${ALL_LIB_SRC_DIR}/${LIB_DIR_NAME})
    set(${LIBNAME}_BIN_DIR ${ALL_LIB_BIN_DIR}/${LIB_DIR_NAME})

    message("${LIBNAME}_SRC_DIR:${${LIBNAME}_SRC_DIR}")
    message("${LIBNAME}_BIN_DIR:${${LIBNAME}_BIN_DIR}")

    if(CMAKE_SYSTEM_NAME MATCHES "Linux")
        add_compile_definitions(DYZ)
    endif()
    add_subdirectory(${${LIBNAME}_SRC_DIR}/)
endif()

set(ZLIB_ROOT_DIR     ${${LIBNAME}_SRC_DIR})

set(ZLIB_INCLUDE_DIRS ${ZLIB_ROOT_DIR}   ${ZLIB_ROOT_DIR}/src   ${ZLIB_ROOT_DIR}/include   ${${LIBNAME}_BIN_DIR}/      ${${LIBNAME}_BIN_DIR}/include  )
set(ZLIB_LIBRARY_DIRS ${ZLIB_ROOT_DIR}   ${ZLIB_ROOT_DIR}/lib   ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/lib   ${${LIBNAME}_BIN_DIR}/Debug)

set(ZLIB_LIBRARY   $<TARGET_OBJECTS:zlib>)
set(ZLIB_LIBRARIES $<TARGET_OBJECTS:zlib>)

include_directories(${ZLIB_INCLUDE_DIRS})
link_directories   (${ZLIB_LIBRARY_DIRS})

