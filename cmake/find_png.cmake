if(NOT TARGET png)
    set(LIBNAME      png)
    set(LIB_DIR_NAME lpng1637)
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

set(PNG_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(PNG_INCLUDE_DIRS ${PNG_ROOT_DIR}/include)
set(PNG_LIBRARY_DIRS ${PNG_ROOT_DIR}/lib)

set(PNG_LIBRARY      libpng16_static)
set(PNG_LIBRARIES    libpng16_static)

include_directories(${PNG_INCLUDE_DIRS})
link_directories   (${PNG_LIBRARY_DIRS})
