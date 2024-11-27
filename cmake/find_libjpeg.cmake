if(NOT TARGET libjpeg)
    set(LIBNAME      libjpeg)
    set(LIB_DIR_NAME libjpeg)
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

set(LIBJPEG_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(LIBJPEG_INCLUDE_DIRS ${LIBJPEG_ROOT_DIR}/include)
set(LIBJPEG_LIBRARY_DIRS ${LIBJPEG_ROOT_DIR}/lib)

set(LIBJPEG_LIBRARY      LibJpeg_static)
set(LIBJPEG_LIBRARIES    LibJpeg_static)

include_directories(${LIBJPEG_INCLUDE_DIRS})
link_directories   (${LIBJPEG_LIBRARY_DIRS})
