ADD_EXECUTABLE(CreationTest CreationTest.cpp)
TARGET_LINK_LIBRARIES(CreationTest ${PODOFO_LIB} )
SET_TARGET_PROPERTIES(CreationTest PROPERTIES COMPILE_FLAGS "${PODOFO_CFLAGS}")
ADD_DEPENDENCIES(CreationTest ${PODOFO_DEPEND_TARGET})

# Copy the test samples over to the build tree
ADD_CUSTOM_COMMAND(
    TARGET CreationTest
    POST_BUILD
    #COMMAND "${CMAKE_COMMAND}" -E copy_directory "${CMAKE_CURRENT_SOURCE_DIR}/resources" "${CMAKE_CURRENT_BINARY_DIR}/resources"
    COMMAND "${CMAKE_COMMAND}" -E create_symlink "${CMAKE_CURRENT_SOURCE_DIR}/resources" "${CMAKE_CURRENT_BINARY_DIR}/resources"
    )
