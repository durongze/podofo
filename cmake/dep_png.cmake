if(NOT TARGET png)
  set(LIBNAME png)
  set(${LIBNAME}_DIR ${CMAKE_CURRENT_LIST_DIR}/../thirdparty/${LIBNAME})
  message("${LIBNAME}_DIR:${${LIBNAME}_DIR}")
  if(CMAKE_SYSTEM_NAME MATCHES "Windows")
    add_compile_definitions(-DDYZ)
  endif()
  add_subdirectory(${${LIBNAME}_DIR}/)
endif()

include_directories(${${LIBNAME}_DIR}/include ${${LIBNAME}_DIR}/ ${CMAKE_BINARY_DIR}/thirdparty/${LIBNAME})

set(PNG_LIBRARY png)
set(PNG_LIBRARIES $<TARGET_OBJECTS:png_static>)
