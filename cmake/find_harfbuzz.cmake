if(NOT TARGET harfbuzz)
    set(LIBNAME      harfbuzz)
    set(LIB_DIR_NAME harfbuzz-5.1.0)
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

set(HARFBUZZ_ROOT_DIR     ${ALL_LIB_HOME_DIR}/${LIB_DIR_NAME})

set(HARFBUZZ_INCLUDE_DIRS ${HARFBUZZ_ROOT_DIR}/include   ${HARFBUZZ_ROOT_DIR}/include/harfbuzz)
set(HARFBUZZ_LIBRARY_DIRS ${HARFBUZZ_ROOT_DIR}/lib)

set(HARFBUZZ_LIBRARY      harfbuzz   harfbuzz-subset  )  # harfbuzz_static     harfbuzz   harfbuzz-subset
set(HARFBUZZ_LIBRARIES    harfbuzz   harfbuzz-subset  )

include_directories(${HARFBUZZ_INCLUDE_DIRS})
link_directories   (${HARFBUZZ_LIBRARY_DIRS})
