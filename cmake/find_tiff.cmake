if(NOT TARGET tiff)
    set(LIBNAME       tiff)
    set(LIB_DIR_NAME  tiff-4.4.0)
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

set(TIFF_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(TIFF_INCLUDE_DIRS ${TIFF_ROOT_DIR}/include)
set(TIFF_LIBRARY_DIRS ${TIFF_ROOT_DIR}/lib)

set(TIFF_LIBRARY      tiff)
set(TIFF_LIBRARIES    tiff)

include_directories(${TIFF_INCLUDE_DIRS})
link_directories   (${TIFF_LIBRARY_DIRS})
