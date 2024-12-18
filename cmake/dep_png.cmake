if(NOT TARGET png)
    set(LIBNAME         png     )
    set(LIB_DIR_NAME    lpng1637)

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

set(PNG_ROOT_DIR     ${${LIBNAME}_SRC_DIR})

set(PNG_INCLUDE_DIRS ${PNG_ROOT_DIR} ${PNG_ROOT_DIR}/include     ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/include)
set(PNG_LIBRARY_DIRS ${PNG_ROOT_DIR} ${PNG_ROOT_DIR}/lib         ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/lib )

set(PNG_LIBRARY   $<TARGET_OBJECTS:png_static>)
set(PNG_LIBRARIES $<TARGET_OBJECTS:png_static>)

include_directories(${PNG_INCLUDE_DIRS})
link_directories   (${PNG_LIBRARY_DIRS})
