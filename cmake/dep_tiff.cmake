if(NOT TARGET tiff)
    set(LIBNAME         tiff      )
    set(LIB_DIR_NAME    tiff-4.4.0)

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

set(TIFF_ROOT_DIR     ${${LIBNAME}_SRC_DIR})

set(TIFF_INCLUDE_DIRS ${TIFF_ROOT_DIR}     ${TIFF_ROOT_DIR}/include   ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/include)
set(TIFF_LIBRARY_DIRS ${TIFF_ROOT_DIR}     ${TIFF_ROOT_DIR}/lib       ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/lib)

set(TIFF_LIBRARY   $<TARGET_OBJECTS:tiff>)
set(TIFF_LIBRARIES $<TARGET_OBJECTS:tiff>)

include_directories(${TIFF_INCLUDE_DIRS})
link_directories   (${TIFF_LIBRARY_DIRS})