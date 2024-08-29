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

#set(ALL_LIB_HOME_DIR "$ENV{HomeDir}")
function(gen_dep_lib_dir all_dep_lib_dir)
    message("[INFO] $0 platform: ${CMAKE_HOST_SYSTEM_NAME} HOME : $ENV{HomeDir} ALL_LIB_HOME_DIR : ${ALL_LIB_HOME_DIR} ")
    if(CMAKE_HOST_SYSTEM_NAME MATCHES "Linux")
        EXECUTE_PROCESS(COMMAND ls ${ALL_LIB_HOME_DIR}
            TIMEOUT 5
            OUTPUT_VARIABLE ALL_LIB_DIR_LIST
            OUTPUT_STRIP_TRAILING_WHITESPACE
            )
    elseif(CMAKE_HOST_SYSTEM_NAME MATCHES "Windows")
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
    message("${CMAKE_CURRENT_FUNCTION}")
    message("[INFO] ARGC ${ARGC}")
    message("[INFO] ARGV ${ARGV}")
    message("[INFO] ARGN ${ARGN}")
    string(REPLACE "\n" ";" LIB_DIR_LIST "${ALL_LIB_DIR_LIST}")
    foreach(LIB_DIR ${LIB_DIR_LIST})
        include_directories(${ALL_LIB_HOME_DIR}/${LIB_DIR}/)
        include_directories(${ALL_LIB_HOME_DIR}/${LIB_DIR}/include)
        link_directories(${ALL_LIB_HOME_DIR}/${LIB_DIR}/lib)
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
        message("[INFO] CUR_LIB_NAMES: ${CUR_LIB_NAMES}")
        list(APPEND dep_libs  ${CUR_LIB_NAMES})
    endforeach()
    
    string(REPLACE ";" "\n" dep_libs "${dep_libs}")
    message("[INFO] 1. dep_libs: ${dep_libs}")

    string(REPLACE "\n" ";" dep_libs "${dep_libs}")
    foreach(cur_lib ${dep_libs})
        message("[INFO] cur_lib: ${cur_lib}")
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
        message("[INFO] DepLib: ${DepLib}")
        list(APPEND DepLibs  ${DepLib})
    endforeach()
    set(DepLibs ${DepLibs} PARENT_SCOPE)
    message("[INFO] 2. DepLibs: ${DepLibs}")
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

#gen_dep_lib_dir(all_dep_lib_dir )

#set(dep_libs ${DepLibs})
