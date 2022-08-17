CMAKE_MINIMUM_REQUIRED(VERSION 3.16)

PROJECT(PoDoFo)

SET(PODOFO_VERSION_MAJOR "0" CACHE STRING "Major part of PoDoFo version number")
SET(PODOFO_VERSION_MINOR "9" CACHE STRING "Minor part of PoDoFo version number")
SET(PODOFO_VERSION_PATCH "7" CACHE STRING "Patchlevel part of PoDoFo version number")
SET(PODOFO_SOVERSION "${PODOFO_VERSION_MAJOR}.${PODOFO_VERSION_MINOR}.${PODOFO_VERSION_PATCH}")
SET(PODOFO_LIBVERSION "${PODOFO_SOVERSION}")

#
# Main includes
#
INCLUDE(CheckCXXSourceCompiles)
INCLUDE(CheckIncludeFile)
INCLUDE(CheckLibraryExists)
INCLUDE(TestBigEndian)
INCLUDE(CheckTypeSize)
#
# Setup CMake Policies
#

# Prefer files in CMAKE_MODULE_PATH over shipped ones in module directory
CMAKE_POLICY(SET CMP0017 NEW) # https://cmake.org/cmake/help/v3.0/policy/CMP0017.html
# Do not use export_library_dependencies() anymore
if(POLICY CMP0033)
CMAKE_POLICY(SET CMP0033 NEW) # https://cmake.org/cmake/help/v3.0/policy/CMP0033.html
endif()
if(POLICY CMP0075)
CMAKE_POLICY(SET CMP0075 NEW) # https://cmake.org/cmake/help/v3.0/policy/CMP0075.html
endif()

include(cmake/dep_freetype.cmake)
include(cmake/dep_harfbuzz.cmake)
include(cmake/dep_jpeg.cmake)
include(cmake/dep_lua.cmake)
include(cmake/dep_png.cmake)
#include(cmake/dep_tiff.cmake)
include(cmake/dep_zlib.cmake)

if(POLICY CMP0033)
CMAKE_POLICY(SET CMP0033 NEW) # https://cmake.org/cmake/help/v3.0/policy/CMP0033.html
endif()

SET(PODOFO_MAIN_CMAKELISTS_READ TRUE)
IF(NOT DEFINED PODOFO_BUILD_SHARED AND NOT DEFINED PODOFO_BUILD_STATIC)
    IF(WIN32)
        SET(PODOFO_BUILD_STATIC FALSE)
        SET(PODOFO_BUILD_SHARED TRUE)
    ELSE(WIN32)
        SET(PODOFO_BUILD_STATIC TRUE)
        SET(PODOFO_BUILD_SHARED FALSE)
    ENDIF(WIN32)
ENDIF(NOT DEFINED PODOFO_BUILD_SHARED AND NOT DEFINED PODOFO_BUILD_STATIC)
IF(DEFINED PODOFO_BUILD_SHARED AND NOT DEFINED PODOFO_BUILD_STATIC)
    IF(PODOFO_BUILD_SHARED)
        SET(PODOFO_BUILD_STATIC FALSE)
    ELSE(PODOFO_BUILD_SHARED)
        SET(PODOFO_BUILD_STATIC TRUE)
    ENDIF(PODOFO_BUILD_SHARED)
ENDIF(DEFINED PODOFO_BUILD_SHARED AND NOT DEFINED PODOFO_BUILD_STATIC)
IF(NOT DEFINED PODOFO_BUILD_SHARED AND DEFINED PODOFO_BUILD_STATIC)
    IF(PODOFO_BUILD_STATIC)
        SET(PODOFO_BUILD_SHARED FALSE)
    ELSE(PODOFO_BUILD_STATIC)
        SET(PODOFO_BUILD_SHARED TRUE)
    ENDIF(PODOFO_BUILD_STATIC)
ENDIF(NOT DEFINED PODOFO_BUILD_SHARED AND DEFINED PODOFO_BUILD_STATIC)

IF(DEFINED LIB_SUFFIX)
	SET(LIBDIRNAME "lib${LIB_SUFFIX}")
ELSE(DEFINED LIB_SUFFIX)

# Some 64 bit linux distros use /usr/lib64 for 64 bit libraries.
# on these platforms we must
IF(NOT DEFINED WANT_LIB64)
	# TODO: detect 64-bit build and existance of /usr/lib64 and set to TRUE.
	MESSAGE("WANT_LIB64 unset; assuming normal library directory names")
	SET(WANT_LIB64 FALSE)
ENDIF(NOT DEFINED WANT_LIB64)

IF(WANT_LIB64)
	SET(LIBDIRNAME "lib64")
ELSE(WANT_LIB64)
	SET(LIBDIRNAME "lib")
ENDIF(WANT_LIB64)

ENDIF(DEFINED LIB_SUFFIX)
# Some headers that tend to vary a bit
CHECK_INCLUDE_FILE("strings.h" PODOFO_HAVE_STRINGS_H) 
CHECK_INCLUDE_FILE("arpa/inet.h" PODOFO_HAVE_ARPA_INET_H) 
CHECK_INCLUDE_FILE("winsock2.h" PODOFO_HAVE_WINSOCK2_H) 
CHECK_INCLUDE_FILE("mem.h" PODOFO_HAVE_MEM_H) 
CHECK_INCLUDE_FILE("ctype.h" PODOFO_HAVE_CTYPE_H) 

# Do some type size detection and provide yet another set of typedefs for fixed
# font sizes. We can't use the c99 / c++0x uint32_t etc, because people use
# ancient compilers that don't and will never support the standard.

CHECK_INCLUDE_FILE("sys/types.h" PODOFO_HAVE_SYS_TYPES_H) 
CHECK_INCLUDE_FILE("stdint.h" PODOFO_HAVE_STDINT_H) 
# See: http://msdn.microsoft.com/en-us/library/aa384264(VS.85).aspx
CHECK_INCLUDE_FILE("BaseTsd.h" PODOFO_HAVE_BASETSD_H) 

CHECK_TYPE_SIZE("long int" SZ_LONG)
# We cache integer type detection results, and don't repeat them
# (and overwrite the user's manual changes) if they've been done already.
IF(NOT PDF_INT64_TYPENAME)
  # I hate old compilers.
  IF(PODOFO_HAVE_STDINT_H)
    SET(pdfint8 "int8_t")
    SET(pdfint16 "int16_t")
    SET(pdfint32 "int32_t")
    SET(pdfint64 "int64_t")
    SET(pdfuint8 "uint8_t")
    SET(pdfuint16 "uint16_t")
    SET(pdfuint32 "uint32_t")
    SET(pdfuint64 "uint64_t")
    CHECK_TYPE_SIZE("int64_t" SZ_INT64)
  ELSE(PODOFO_HAVE_STDINT_H)
    # No stdint.h . Try BaseTsd.h windows types.
    IF(PODOFO_HAVE_BASETSD_H)
       # We have BaseTsd.h, so use those types.
       SET(pdfint8  "signed char")
       SET(pdfint16 "short")
       SET(pdfint32 "INT32")
       SET(pdfint64 "INT64")
       SET(pdfuint8 "unsigned char")
       SET(pdfuint16 "unsigned short")
       SET(pdfuint32 "UINT32")
       SET(pdfuint64 "UINT64")
       CHECK_TYPE_SIZE("INT64" SZ_INT64)
    ELSE(PODOFO_HAVE_BASETSD_H)
       # No BaseTsd.h either. Assume the standard types, and go poking
       # for a sane 64-bit integer.
       #
       # First, though, make sure sizeof(int) = 4 and if not, scream, because
       # hopefully this case will never be hit and we'll never have to write
       # the horrible code check for
       CHECK_TYPE_SIZE("signed char"        SZ_TINY_INT)
       CHECK_TYPE_SIZE("unsigned char"      SZ_TINY_UINT)
       CHECK_TYPE_SIZE("short int"          SZ_SHORT_INT)
       CHECK_TYPE_SIZE("int"                SZ_INT)
       CHECK_TYPE_SIZE("unsigned short int" SZ_UINT)
       CHECK_TYPE_SIZE("unsigned int"       SZ_SHORT_UINT)
       SET(smallintsok SZ_INT == 4 AND SZ_UINT == 4 AND SZ_SHORT_INT == 2 AND SZ_SHORT_UINT == 2 AND SZ_TINY_INT == 1 AND SZ_TINY_UINT == 1)
       IF(NOT smallintsok)
         MESSAGE(FATAL "sizeof(int) != 4 and/or sizeof(short) != 2 and no stdint.h or BaseTsd.h found. We don't know how to cope with this.")
       ENDIF(NOT smallintsok)
       SET(pdfint8 "signed char")
       SET(pdfint16 "short")
       SET(pdfint32 "int")
       SET(pdfuint8 "unsigned char")
       SET(pdfuint16 "unsigned short")
       SET(pdfuint32 "unsigned int")
       # Now we just have to figure out what 64-bit integer type we can use.
       #
       # Do we have VC >= 6's __uint64 and __int64?
       # See: http://icfun.blogspot.com/2008/04/use-of-int64-variable-in-c.html
       CHECK_TYPE_SIZE("__int64" SZ___INT64)
       CHECK_TYPE_SIZE("__uint64"  SZ___UINT64)
       IF(SZ___INT64 == 8 AND SZ___UINT64 == 8)
         # MS compiler, VC6 or newer without BaseTsd.h in SDK
         SET(pdfint64 "__int64")
         SET(pdfuint64 "__uint64")
	 CHECK_TYPE_SIZE("__int64" SZ_INT64)
       ELSE(SZ___INT64 AND SZ___UINT64)
         # Still no luck. Old unix compiler, Borland, or some other monster?
         # Are we lucky and sizeof(long) == 8?
         CHECK_TYPE_SIZE("unsigned long int" SZ_ULONG)
         IF(SZ_LONG == 8 AND SZ_ULONG == 8)
           # Must be on a LP64 platform, sizeof(long) = 8
           SET(pdfint64 "long int")
           SET(pdfuint64 "unsigned long int")
	   CHECK_TYPE_SIZE("long int" SZ_INT64)
         ELSE(SZ_LONG == 8 AND SZ_ULONG == 8)
           # See if the compiler implements "long long int", int64_t, int64,
           # or _int64 (in this order, __int64 check already done)
           IF(PODOFO_HAVE_SYS_TYPES_H)
             SET(CMAKE_EXTRA_INCLUDE_FILES "sys/types.h")
           ENDIF(PODOFO_HAVE_SYS_TYPES_H)
           CHECK_TYPE_SIZE("long long int"          SZ_LONG_LONG)
           CHECK_TYPE_SIZE("unsigned long long int" SZ_UNSIGNED_LONG_LONG)
           IF(SZ_LONG_LONG == 8 AND SZ_UNSIGNED_LONG_LONG == 8)
             SET(pdfint64 "long long int")
             SET(pdfuint64 "unsigned long long int")
             CHECK_TYPE_SIZE("long long int" SZ_INT64)
           ELSE(SZ_LONG_LONG == 8 AND SZ_UNSIGNED_LONG_LONG == 8)
             # The standard type int64_t is normally found in stdint.h,
             # but use a type of this name anyway if present
             CHECK_TYPE_SIZE("int64_t"       SZ_INT64_T)
             CHECK_TYPE_SIZE("uint64_t"      SZ_UINT64_T)
             IF(SZ_INT64_T AND SZ_UINT64_T)
               SET(pdfint64 "int64_t")
               SET(pdfuint64 "uint64_t")
	       CHECK_TYPE_SIZE("int64_t" SZ_INT64)
             ELSE(SZ_INT64_T AND SZ_UINT64_T)
               CHECK_TYPE_SIZE("int64"                SZ_INT64)
               CHECK_TYPE_SIZE("uint64"               SZ_UINT64)
               IF(SZ_INT64 AND SZ_UINT64)
                 SET(pdfint64 "int64")
                 SET(pdfuint64 "uint64")
		 CHECK_TYPE_SIZE("int64" SZ_INT64)
               ELSE(SZ_INT64 AND SZ_UINT64)
                 CHECK_TYPE_SIZE("_int64"                SZ__INT64)
                 CHECK_TYPE_SIZE("_uint64"               SZ__UINT64)
                 IF(SZ__INT64 AND SZ__UINT64)
                   SET(pdfint64 "_int64")
                   SET(pdfuint64 "_uint64")
		   CHECK_TYPE_SIZE("_int64" SZ_INT64)
                 ELSE(SZ__INT64 AND SZ__UINT64)
                   MESSAGE("Oh my lord, your compiler doesn't seem to support any of the int64 type flavours we tried.")
                   MESSAGE(WARNING "You must set the PDF_INTxx_TYPENAME and PDF_UINTxx_TYPENAME variables manually")
                 ENDIF(SZ__INT64 AND SZ__UINT64)
               ENDIF(SZ_INT64 AND SZ_UINT64)
             ENDIF(SZ_INT64_T AND SZ_UINT64_T)
           ENDIF(SZ_LONG_LONG == 8 AND SZ_UNSIGNED_LONG_LONG == 8)
         ENDIF(SZ_LONG == 8 AND SZ_ULONG == 8)
       ENDIF(SZ___INT64 AND SZ___UINT64)
    ENDIF(PODOFO_HAVE_BASETSD_H)
  ENDIF(PODOFO_HAVE_STDINT_H)
  SET(CMAKE_EXTRA_INCLUDE_FILES)
ENDIF(NOT PDF_INT64_TYPENAME)
IF(NOT PDF_INT64_TYPENAME AND pdfint64)
  SET(PDF_INT64_TYPENAME  "${pdfint64}" CACHE STRING "Name of detected 64-bit signed integer type to use")
  SET(PDF_INT32_TYPENAME  "${pdfint32}" CACHE STRING "Name of detected 32-bit signed integer type to use")
  SET(PDF_INT16_TYPENAME  "${pdfint16}" CACHE STRING "Name of detected 16-bit signed integer type to use")
  SET(PDF_INT8_TYPENAME   "${pdfint8}" CACHE STRING "Name of detected 8-bit signed integer type to use")
  SET(PDF_UINT64_TYPENAME "${pdfuint64}" CACHE STRING "Name of detected 64-bit unsigned integer type to use")
  SET(PDF_UINT32_TYPENAME "${pdfuint32}" CACHE STRING "Name of detected 32-bit unsigned integer type to use")
  SET(PDF_UINT16_TYPENAME "${pdfuint16}" CACHE STRING "Name of detected 16-bit unsigned integer type to use")
  SET(PDF_UINT8_TYPENAME  "${pdfuint8}" CACHE STRING "Name of detected 8-bit unsigned integer type to use")
ENDIF(NOT PDF_INT64_TYPENAME AND pdfint64)

INCLUDE_DIRECTORIES(BEFORE # before toolchain include dir (to ignore installed)
    ${PoDoFo_SOURCE_DIR}/src   # order will be reversed, so this is the second dir
    ${PoDoFo_BINARY_DIR}   # because of BEFORE, this is the first include dir
    )

INCLUDE_DIRECTORIES(
    ${PoDoFo_SOURCE_DIR}/src/podofo
    ${FREETYPE_INCLUDE_DIR}
    ${ZLIB_INCLUDE_DIR}
    ${EXTRA_INCLUDES}
     )
LINK_DIRECTORIES(
    ${PoDoFo_BINARY_DIR}/src/podofo
    )

SET(PODOFO_LIB_DEPENDS
  ${ZLIB_LIBRARIES}
  ${LIBIDN_LIBRARIES}
  ${LIBCRYPTO_LDFLAGS}
  ${LIBCRYPTO_LIBRARIES}
  ${OPENSSL_LIBRARIES}
  ${LIBJPEG_LIBRARIES}
  ${PLATFORM_SYSTEM_LIBRARIES}
  ${stlport_libraries_if_use_stlport}
  ${FREETYPE_LIBRARIES}
  ${PNG_LIBRARIES}
  ${TIFF_LIBRARIES}
  ${UNISTRING_LIBRARY}
  ${HARFBUZZ_LIBRARIES}
  )
message("PODOFO_LIB_DEPENDS:${PODOFO_LIB_DEPENDS}")

IF(WIN32 OR PODOFO_BUILD_STATIC)
  SET(PODOFO_LIB
      podofo
     # ${PODOFO_LIB_DEPENDS}
      )
ELSE(WIN32 OR PODOFO_BUILD_STATIC)
  SET(PODOFO_LIB podofo
      ${stlport_libraries_if_use_stlport}
      )
ENDIF(WIN32 OR PODOFO_BUILD_STATIC)

#
# Setup directories we will need
#
SET(MANDIR "share/man/")
FILE(WRITE
     "${PoDoFo_BINARY_DIR}/PoDoFoConfig.cmake"
     "# CMake module for PoDoFo\n"
     )
FILE(APPEND 
     "${PoDoFo_BINARY_DIR}/PoDoFoConfig.cmake"
     "SET(PODOFO_INCLUDES ${PoDoFo_SOURCE_DIR}/src)\n"
     )

ADD_SUBDIRECTORY(src/podofo)
IF(NOT PODOFO_BUILD_LIB_ONLY)
ADD_SUBDIRECTORY(test)
ADD_SUBDIRECTORY(tools)
ADD_SUBDIRECTORY(examples)
ADD_SUBDIRECTORY(man)
ENDIF(NOT PODOFO_BUILD_LIB_ONLY)

# Generate our configure file
CONFIGURE_FILE(${PoDoFo_SOURCE_DIR}/podofo_config.h.in ${PoDoFo_BINARY_DIR}/podofo_config.h)
IF(PODOFO_BUILD_SHARED)
  EXPORT(TARGETS podofo_shared FILE "${CMAKE_CURRENT_BINARY_DIR}/PoDoFoConfig.cmake")
ENDIF(PODOFO_BUILD_SHARED)
IF(PODOFO_BUILD_STATIC)
  EXPORT(TARGETS podofo_static FILE "${CMAKE_CURRENT_BINARY_DIR}/PoDoFoConfig.cmake")
ENDIF(PODOFO_BUILD_STATIC)
