if(NOT TARGET jpeg)
    set(LIBNAME      jpeg)
    set(LIB_DIR_NAME jpeg-9e)
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

set(JPEG_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(JPEG_INCLUDE_DIRS ${JPEG_ROOT_DIR}/include)
set(JPEG_LIBRARY_DIRS ${JPEG_ROOT_DIR}/lib)

set(JPEG_LIBRARY      libjpeg)
set(JPEG_LIBRARIES    libjpeg)

include_directories(${JPEG_INCLUDE_DIRS})
link_directories   (${JPEG_LIBRARY_DIRS})

