set(LUA_DEP_DEFS      LUA_STATIC)

if(NOT TARGET lua)
    set(LIBNAME      lua)
    set(LIB_DIR_NAME lua-5.4.4)

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

set(LUA_ROOT_DIR     ${${LIBNAME}_SRC_DIR})

set(LUA_INCLUDE_DIRS ${LUA_ROOT_DIR}     ${LUA_ROOT_DIR}/include  ${LUA_ROOT_DIR}/src  ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/include  )
set(LUA_LIBRARY_DIRS ${LUA_ROOT_DIR}     ${LUA_ROOT_DIR}/lib      ${LUA_ROOT_DIR}/src  ${${LIBNAME}_BIN_DIR}/     ${${LIBNAME}_BIN_DIR}/lib      ${${LIBNAME}_BIN_DIR}/Debug)

set(LUA_LIBRARY   $<TARGET_OBJECTS:liblua_static>)
set(LUA_LIBRARIES $<TARGET_OBJECTS:liblua_static>)

#include_directories(${LUA_INCLUDE_DIRS}  )
#link_directories   (${LUA_LIBRARY_DIRS}  )


