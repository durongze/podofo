if(NOT TARGET zlib)
    set(LIBNAME      zlib)
    set(LIB_DIR_NAME zlib-1.2.12)
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

set(ZLIB_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(ZLIB_INCLUDE_DIRS ${ZLIB_ROOT_DIR}/include)
set(ZLIB_LIBRARY_DIRS ${ZLIB_ROOT_DIR}/lib)

set(ZLIB_LIBRARY      zlibstaticd)  # zlibstatic  zlibstaticd  zlib_static
set(ZLIB_LIBRARIES    zlibstaticd)

include_directories(${ZLIB_INCLUDE_DIRS})
link_directories   (${ZLIB_LIBRARY_DIRS})

message("ZLIB_LIBRARY_DIRS = ${ZLIB_LIBRARY_DIRS} ") 