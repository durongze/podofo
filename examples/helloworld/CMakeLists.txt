# This is not a full standalone CMake configuration for the hello world
# example.
#
# To build it outside the PoDoFo source tree, you must set your build system
# make the PoDoFo headers available and must link to the PoDoFo library
# and any libraries it depends on (see the README,
#     "5. Using PoDoFo in Your Application") .
#
# Note that you don't need the headers for PoDoFo's dependencies in your
# header search path.

add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/source-charset:utf-8>")
add_compile_options("$<$<CXX_COMPILER_ID:MSVC>:/execution-charset:utf-8>")

ADD_EXECUTABLE(add_bookmark helloworld.cpp tinystr.cpp tinyxml.cpp tinyxmlerror.cpp tinyxmlparser.cpp )

target_compile_definitions(add_bookmark PRIVATE UNICODE;_UNICODE) 

SET_TARGET_PROPERTIES(add_bookmark PROPERTIES
	VERSION "${PODOFO_LIBVERSION}"
	SOVERSION "${PODOFO_SOVERSION}"
	COMPILE_FLAGS "${PODOFO_CFLAGS} -g"
)

TARGET_LINK_LIBRARIES(add_bookmark ${PODOFO_LIB} )
ADD_DEPENDENCIES(add_bookmark ${PODOFO_DEPEND_TARGET})
INCLUDE_DIRECTORIES(${PoDoFo_SOURCE_DIR})
