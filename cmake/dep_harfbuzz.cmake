if(NOT TARGET harfbuzz)
  set(LIBNAME harfbuzz)
  set(${LIBNAME}_DIR ${CMAKE_CURRENT_LIST_DIR}/../thirdparty/${LIBNAME})
  message("${LIBNAME}_DIR:${${LIBNAME}_DIR}")
  if(CMAKE_SYSTEM_NAME MATCHES "Linux")
    add_compile_definitions(DYZ)
  endif()
  add_subdirectory(${${LIBNAME}_DIR}/)
endif()

include_directories(${${LIBNAME}_DIR}/include ${${LIBNAME}_DIR}/ ${CMAKE_BINARY_DIR}/thirdparty/${LIBNAME})

set(HARFBUZZ_LIBRARY $<TARGET_OBJECTS:harfbuzz> $<TARGET_OBJECTS:harfbuzz-subset>)
set(HARFBUZZ_LIBRARIES $<TARGET_OBJECTS:harfbuzz> $<TARGET_OBJECTS:harfbuzz-subset>)
