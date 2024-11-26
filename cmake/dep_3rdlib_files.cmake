set(LIBNAME zlib-1.2.12)

if("$ENV{HomeDir}" STREQUAL "")
    if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
        set(ALL_LIB_HOME_DIR ${CMAKE_CURRENT_LIST_DIR}/../out/linux)
    elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
        set(ALL_LIB_HOME_DIR ${CMAKE_CURRENT_LIST_DIR}/../out/windows)
        string(REPLACE "/" "\\" ALL_LIB_HOME_DIR "${ALL_LIB_HOME_DIR}")
        message("[INFO] ${CMAKE_HOST_SYSTEM_NAME}  ALL_LIB_HOME_DIR: ${ALL_LIB_HOME_DIR}")
    else()
        message("current platform: unkonw ") 
    endif()
else()
    set(ALL_LIB_HOME_DIR "$ENV{HomeDir}")
    message("[INFO] ENV{HomeDir}: $ENV{HomeDir}")
endif()

if(NOT EXISTS "${ALL_LIB_HOME_DIR}/${LIBNAME}")
    set(DISK_NAME_LIST C D E F G)
    set(LIB_HOME_DIR_LIST   Programs Program)
    foreach(DISK_NAME ${DISK_NAME_LIST})
        foreach(LIB_HOME_DIR ${LIB_HOME_DIR_LIST})
            if(EXISTS "${DISK_NAME}:/${LIB_HOME_DIR}/${LIBNAME}")
                set(ALL_LIB_HOME_DIR "${DISK_NAME}:/${LIB_HOME_DIR}")
                message("[INFO] ALL_LIB_HOME_DIR: ${ALL_LIB_HOME_DIR}")
            else()
                message("[INFO] Skip LIB_HOME_DIR:${DISK_NAME}:/${LIB_HOME_DIR}")
            endif()
        endforeach()
    endforeach()
else()
    message("[INFO] ALL_LIB_HOME_DIR: ${ALL_LIB_HOME_DIR}  LIBNAME: ${LIBNAME}")
endif()

#set(ALL_LIB_HOME_DIR "$ENV{HomeDir}")
function(gen_dep_lib_dir all_dep_lib_dir)
    message("[INFO] ${CMAKE_CURRENT_FUNCTION} platform: ${CMAKE_HOST_SYSTEM_NAME} HOME : $ENV{HomeDir} ALL_LIB_HOME_DIR : ${ALL_LIB_HOME_DIR} ")
    if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
        EXECUTE_PROCESS(COMMAND ls ${ALL_LIB_HOME_DIR}
            TIMEOUT 5
            OUTPUT_VARIABLE ALL_LIB_DIR_LIST
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
    elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
        string(REPLACE "/" "\\" ALL_LIB_HOME_DIR "${ALL_LIB_HOME_DIR}")
        EXECUTE_PROCESS(COMMAND cmd /c dir /ad /b ${ALL_LIB_HOME_DIR}
            OUTPUT_VARIABLE ALL_LIB_DIR_LIST
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
    else()
        message("${CMAKE_CURRENT_FUNCTION} platform: unkonw ") 
    endif()
    set(dep_lib_dir ${ALL_LIB_DIR_LIST})
    add_dep_lib_dir("${dep_lib_dir}")
    set(DepLibs ${DepLibs} PARENT_SCOPE)
endfunction()

function(add_dep_lib_dir dep_lib_dir )
    message("[INFO] ${CMAKE_CURRENT_FUNCTION}")
    message("       ARGC ${ARGC}")
    message("       ARGV ${ARGV}")
    message("       ARGN ${ARGN}")
    string(REPLACE "\n" ";" LIB_DIR_LIST "${ALL_LIB_DIR_LIST}")
    set(index 0)
    foreach(LIB_DIR ${LIB_DIR_LIST})
        math(EXPR index "${index} + 1")
        include_directories(${ALL_LIB_HOME_DIR}/${LIB_DIR}/)
        include_directories(${ALL_LIB_HOME_DIR}/${LIB_DIR}/include)
        link_directories(${ALL_LIB_HOME_DIR}/${LIB_DIR}/lib)
        message("    ${index} ${ALL_LIB_HOME_DIR}/${LIB_DIR}/lib")
        if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
            file(GLOB cur_lib_name "${ALL_LIB_HOME_DIR}/${LIB_DIR}/lib/*.a")
            EXECUTE_PROCESS(COMMAND ls ${cur_lib_name} 
                TIMEOUT 5
                OUTPUT_VARIABLE CUR_LIB_NAMES
                OUTPUT_STRIP_TRAILING_WHITESPACE
                )
            
        elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
            EXECUTE_PROCESS(COMMAND cmd /c dir ${ALL_LIB_HOME_DIR}\\${LIB_DIR}\\lib\\*.lib /b 
                OUTPUT_VARIABLE CUR_LIB_NAMES
                OUTPUT_STRIP_TRAILING_WHITESPACE
                )
        endif()
        message("        CUR_LIB_NAMES: ${CUR_LIB_NAMES}")
        list(APPEND dep_libs  ${CUR_LIB_NAMES})
    endforeach()
    
    string(REPLACE ";" "\n" dep_libs "${dep_libs}")
    message("[INFO] ${CMAKE_CURRENT_FUNCTION} 1. dep_libs: ${dep_libs}")

    string(REPLACE "\n" ";" dep_libs "${dep_libs}")
    set(index 0)
    foreach(cur_lib ${dep_libs})
        math(EXPR index "${index} + 1")
        message("    ${index} cur_lib: ${cur_lib}")
        if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
        	string(REPLACE ".a" "" DepLib "${cur_lib}")
        	string(REPLACE ";" "\n" DepLib "${DepLib}")
        	string(REGEX REPLACE "^.*/" "" DepLib "${DepLib}")
        	string(REPLACE "lib" "-l" DepLib "${DepLib}")
        elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
        	string(REPLACE ".lib" "" DepLib "${cur_lib}")
        	string(REPLACE ";" "\n" DepLib "${DepLib}")
        	string(REPLACE "\n" ";" DepLib "${DepLib}")
        	string(REGEX REPLACE " $" "" DepLib "${DepLib}")
        endif()
        message("        DepLib: ${DepLib}")
        list(APPEND DepLibs  ${DepLib})
    endforeach()
    set(DepLibs ${DepLibs} PARENT_SCOPE)
    message("[INFO] ${CMAKE_CURRENT_FUNCTION} 2. DepLibs: ${DepLibs}")
endfunction()

function(generate_fcopy src_f dest_dir)
    add_custom_command(OUTPUT ${dest_dir}
                       COMMAND "${CMAKE_COMMAND}" -E remove "${dest_dir}"
                       COMMAND "${CMAKE_COMMAND}" -E copy "${src_f}" "${dest_dir}"
                       DEPENDS "${src_f}"
                       COMMENT "${CMAKE_COMMAND} -E copy ${src_f} ${dest_dir}" VERBATIM)
endfunction()

function(generate_dcopy src_d dest_dir)
    add_custom_command(OUTPUT ${dest_dir}
                       COMMAND "${CMAKE_COMMAND}" -E remove_directory "${dest_dir}"
                       COMMAND "${CMAKE_COMMAND}" -E copy_directory "${src_d}" "${dest_dir}"
                       DEPENDS "${src_d}"
                       COMMENT "${CMAKE_COMMAND} -E copy_directory ${src_d} ${dest_dir}" VERBATIM)
endfunction()

function(show_all_env_info)
    MESSAGE( STATUS "CALLING_CMAKE_FILE:       " ${CALLING_CMAKE_FILE} )
    MESSAGE( STATUS "CMAKE_CURRENT_LIST_LINE:  " ${CMAKE_CURRENT_LIST_LINE} )
    MESSAGE( STATUS "CMAKE_CURRENT_FUNCTION:   " ${CMAKE_CURRENT_FUNCTION} )
    MESSAGE( STATUS "PROJECT_NAME:             " ${PROJECT_NAME} )
    MESSAGE( STATUS "CMAKE_BINARY_DIR:         " ${CMAKE_BINARY_DIR} )
    MESSAGE( STATUS "CMAKE_CURRENT_BINARY_DIR: " ${CMAKE_CURRENT_BINARY_DIR} )
    MESSAGE( STATUS "CMAKE_SOURCE_DIR:         " ${CMAKE_SOURCE_DIR} )
    MESSAGE( STATUS "CMAKE_CURRENT_SOURCE_DIR: " ${CMAKE_CURRENT_SOURCE_DIR} )
    MESSAGE( STATUS "PROJECT_BINARY_DIR:       " ${PROJECT_BINARY_DIR} )
    MESSAGE( STATUS "PROJECT_SOURCE_DIR:       " ${PROJECT_SOURCE_DIR} )
    MESSAGE( STATUS "EXECUTABLE_OUTPUT_PATH:   " ${EXECUTABLE_OUTPUT_PATH} )
    MESSAGE( STATUS "LIBRARY_OUTPUT_PATH:      " ${LIBRARY_OUTPUT_PATH} )
    MESSAGE( STATUS "CMAKE_MODULE_PATH:        " ${CMAKE_MODULE_PATH} )
    MESSAGE( STATUS "CMAKE_COMMAND:            " ${CMAKE_COMMAND} )
    MESSAGE( STATUS "CMAKE_ROOT:               " ${CMAKE_ROOT} )
    MESSAGE( STATUS "CMAKE_CURRENT_LIST_DIR:   " ${CMAKE_CURRENT_LIST_DIR} )
    MESSAGE( STATUS "CMAKE_CURRENT_LIST_FILE:  " ${CMAKE_CURRENT_LIST_FILE} )
    MESSAGE( STATUS "CMAKE_CURRENT_LIST_LINE:  " ${CMAKE_CURRENT_LIST_LINE} )
    MESSAGE( STATUS "CMAKE_INCLUDE_PATH:       " ${CMAKE_INCLUDE_PATH} )
    MESSAGE( STATUS "CMAKE_LIBRARY_PATH:       " ${CMAKE_LIBRARY_PATH} )
    MESSAGE( STATUS "CMAKE_SYSTEM:             " ${CMAKE_SYSTEM} )
    MESSAGE( STATUS "CMAKE_SYSTEM_NAME:        " ${CMAKE_SYSTEM_NAME} )
    MESSAGE( STATUS "CMAKE_SYSTEM_VERSION:     " ${CMAKE_SYSTEM_VERSION} )
    MESSAGE( STATUS "CMAKE_SYSTEM_PROCESSOR:   " ${CMAKE_SYSTEM_PROCESSOR} )
    MESSAGE( STATUS "CMAKE_ARCHIVE_OUTPUT_DIRECTORY:   " ${CMAKE_ARCHIVE_OUTPUT_DIRECTORY} )
endfunction()

#gen_dep_lib_dir(all_dep_lib_dir )

#set(dep_libs ${DepLibs})
