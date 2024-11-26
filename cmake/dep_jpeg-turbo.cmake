if(NOT TARGET jpeg)
    set(LIBNAME         jpeg)
    set(LIB_DIR_NAME    libjpeg-turbo-2.1.4)

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

set(JPEG_ROOT_DIR     ${${LIBNAME}_SRC_DIR})

set(JPEG_INCLUDE_DIRS ${JPEG_ROOT_DIR} ${JPEG_ROOT_DIR}/include   ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/include)
set(JPEG_LIBRARY_DIRS ${JPEG_ROOT_DIR} ${JPEG_ROOT_DIR}/lib       ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/lib )

set(JPEG_LIBRARY    $<TARGET_OBJECTS:jpeg-turbo>)
set(JPEG_LIBRARIES  $<TARGET_OBJECTS:jpeg-turbo>)

include_directories(${JPEG_INCLUDE_DIRS})
link_directories   (${JPEG_LIBRARY_DIRS})
