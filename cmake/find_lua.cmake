set(LUA_DEP_DEFS      LUA_STATIC)

if(NOT TARGET lua)
    set(LIBNAME      lua)
    set(LIB_DIR_NAME lua)
endif()

if("$ENV{HomeDir}" STREQUAL "")
    if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
        set(ALL_LIB_HOME_DIR ${CMAKE_CURRENT_LIST_DIR}/../out/linux)
    elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
        set(ALL_LIB_HOME_DIR ${CMAKE_CURRENT_LIST_DIR}/../out/windows)
        string(REPLACE "/" "\\" ALL_LIB_HOME_DIR "${ALL_LIB_HOME_DIR}")
    else()
        message("current platform: unkonw ") 
    endif()
else()
    set(ALL_LIB_HOME_DIR "$ENV{HomeDir}")
endif()

set(LUA_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(LUA_INCLUDE_DIRS ${LUA_ROOT_DIR}/include)
set(LUA_LIBRARY_DIRS ${LUA_ROOT_DIR}/lib)

set(LUA_LIBRARY      LUA_static)
set(LUA_LIBRARIES    LUA_static)

include_directories(${LIBJPEG_INCLUDE_DIRS})
link_directories   (${LIBJPEG_LIBRARY_DIRS})