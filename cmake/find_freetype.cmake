set (FREETYPE_DEP_DEFS    DLL_IMPORT) # dll

if(NOT TARGET freetype)
    set(LIBNAME      freetype)
    set(LIB_DIR_NAME freetype-2.12.1)
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

set(FREETYPE_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(FREETYPE_INCLUDE_DIRS ${FREETYPE_ROOT_DIR}/include   ${FREETYPE_ROOT_DIR}/include/freetype2)
set(FREETYPE_LIBRARY_DIRS ${FREETYPE_ROOT_DIR}/lib)

set(FREETYPE_LIBRARY      freetype)  # freetype_static   freetyped
set(FREETYPE_LIBRARIES    freetype)

message("FREETYPE_INCLUDE_DIRS:${FREETYPE_INCLUDE_DIRS}")

include_directories(${FREETYPE_INCLUDE_DIRS})
link_directories   (${FREETYPE_LIBRARY_DIRS})
