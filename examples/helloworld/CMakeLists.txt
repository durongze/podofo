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
SET(PODOFO_BASE_SOURCES
 ../../src/podofo/base/PdfArray.cpp
 ../../src/podofo/base/PdfCanvas.cpp
 ../../src/podofo/base/PdfColor.cpp
 ../../src/podofo/base/PdfContentsTokenizer.cpp
 ../../src/podofo/base/PdfData.cpp
 ../../src/podofo/base/PdfDataType.cpp
 ../../src/podofo/base/PdfOwnedDataType.cpp
 ../../src/podofo/base/PdfDate.cpp
 ../../src/podofo/base/PdfDictionary.cpp
 ../../src/podofo/base/PdfEncoding.cpp
 ../../src/podofo/base/PdfEncodingFactory.cpp
 ../../src/podofo/base/PdfEncrypt.cpp
 ../../src/podofo/base/PdfError.cpp
 ../../src/podofo/base/PdfFileStream.cpp
 ../../src/podofo/base/PdfFilter.cpp
 ../../src/podofo/base/PdfFiltersPrivate.cpp
 ../../src/podofo/base/PdfImmediateWriter.cpp
 ../../src/podofo/base/PdfInputDevice.cpp
 ../../src/podofo/base/PdfInputStream.cpp
 ../../src/podofo/base/PdfLocale.cpp
 ../../src/podofo/base/PdfMemStream.cpp
 ../../src/podofo/base/PdfMemoryManagement.cpp
 ../../src/podofo/base/PdfName.cpp
 ../../src/podofo/base/PdfObject.cpp
 ../../src/podofo/base/PdfObjectStreamParserObject.cpp
 ../../src/podofo/base/PdfOutputDevice.cpp
 ../../src/podofo/base/PdfOutputStream.cpp
 ../../src/podofo/base/PdfParser.cpp
 ../../src/podofo/base/PdfParserObject.cpp
 ../../src/podofo/base/PdfRect.cpp
 ../../src/podofo/base/PdfRefCountedBuffer.cpp
 ../../src/podofo/base/PdfRefCountedInputDevice.cpp
 ../../src/podofo/base/PdfReference.cpp
 ../../src/podofo/base/PdfStream.cpp
 ../../src/podofo/base/PdfString.cpp
 ../../src/podofo/base/PdfTokenizer.cpp
 ../../src/podofo/base/PdfVariant.cpp
 ../../src/podofo/base/PdfVecObjects.cpp
 ../../src/podofo/base/PdfWriter.cpp
 ../../src/podofo/base/PdfXRef.cpp
 ../../src/podofo/base/PdfXRefStream.cpp
 ../../src/podofo/base/PdfXRefStreamParserObject.cpp
  )

SET(PODOFO_DOC_SOURCES
 ../../src/podofo/doc/PdfAcroForm.cpp
 ../../src/podofo/doc/PdfAction.cpp
 ../../src/podofo/doc/PdfAnnotation.cpp
 ../../src/podofo/doc/PdfCMapEncoding.cpp
 ../../src/podofo/doc/PdfContents.cpp
 ../../src/podofo/doc/PdfDestination.cpp
 ../../src/podofo/doc/PdfDifferenceEncoding.cpp
 ../../src/podofo/doc/PdfDocument.cpp
 ../../src/podofo/doc/PdfElement.cpp
 ../../src/podofo/doc/PdfEncodingObjectFactory.cpp
 ../../src/podofo/doc/PdfExtGState.cpp
 ../../src/podofo/doc/PdfField.cpp
 ../../src/podofo/doc/PdfFileSpec.cpp
 ../../src/podofo/doc/PdfFont.cpp
 ../../src/podofo/doc/PdfFontCID.cpp
 ../../src/podofo/doc/PdfFontCache.cpp
 ../../src/podofo/doc/PdfFontConfigWrapper.cpp
 ../../src/podofo/doc/PdfFontFactory.cpp
 ../../src/podofo/doc/PdfFontMetrics.cpp
 ../../src/podofo/doc/PdfFontMetricsBase14.cpp
 ../../src/podofo/doc/PdfFontMetricsFreetype.cpp
 ../../src/podofo/doc/PdfFontMetricsObject.cpp
 ../../src/podofo/doc/PdfFontSimple.cpp
 ../../src/podofo/doc/PdfFontTTFSubset.cpp
 ../../src/podofo/doc/PdfFontTrueType.cpp
 ../../src/podofo/doc/PdfFontType1.cpp
 ../../src/podofo/doc/PdfFontType3.cpp
 ../../src/podofo/doc/PdfFontType1Base14.cpp
 ../../src/podofo/doc/PdfFunction.cpp
 ../../src/podofo/doc/PdfHintStream.cpp
 ../../src/podofo/doc/PdfIdentityEncoding.cpp
 ../../src/podofo/doc/PdfImage.cpp
 ../../src/podofo/doc/PdfInfo.cpp
 ../../src/podofo/doc/PdfMemDocument.cpp
 ../../src/podofo/doc/PdfNamesTree.cpp
 ../../src/podofo/doc/PdfOutlines.cpp
 ../../src/podofo/doc/PdfPage.cpp
 ../../src/podofo/doc/PdfPagesTree.cpp
 ../../src/podofo/doc/PdfPagesTreeCache.cpp
 ../../src/podofo/doc/PdfPainter.cpp
 ../../src/podofo/doc/PdfPainterMM.cpp
 ../../src/podofo/doc/PdfShadingPattern.cpp
 ../../src/podofo/doc/PdfSignOutputDevice.cpp
 ../../src/podofo/doc/PdfSignatureField.cpp
 ../../src/podofo/doc/PdfStreamedDocument.cpp
 ../../src/podofo/doc/PdfTable.cpp
 ../../src/podofo/doc/PdfTilingPattern.cpp
 ../../src/podofo/doc/PdfXObject.cpp
  )
  
message(STATUS "===========================================")
message(STATUS "${PODOFO_CFLAGS}")
message(STATUS "${PODOFO_BASE_SOURCES} ${PODOFO_DOC_SOURCES} ${PODOFO_HEADER_FILES} ")
message(STATUS "-------------------------------------------")
ADD_EXECUTABLE(helloworld helloworld.cpp  ${PODOFO_BASE_SOURCES} ${PODOFO_DOC_SOURCES} ${PODOFO_HEADER_FILES} tinystr.cpp tinyxml.cpp tinyxmlerror.cpp tinyxmlparser.cpp )

SET_TARGET_PROPERTIES(helloworld PROPERTIES
VERSION "${PODOFO_LIBVERSION}"
SOVERSION "${PODOFO_SOVERSION}"
COMPILE_FLAGS " -DBUILDING_PODOFO -DPODOFO_API -g -lz -lcrypto -lssl -lpthread -lfreetype -lpng"
)

TARGET_LINK_LIBRARIES(helloworld ${PODOFO_LIB} "-lz -lcrypto -lssl -lpthread -lfreetype -lpng")
# SET_TARGET_PROPERTIES(helloworld PROPERTIES COMPILE_FLAGS "${PODOFO_CFLAGS} -g")
ADD_DEPENDENCIES(helloworld ${PODOFO_DEPEND_TARGET})
INCLUDE_DIRECTORIES(${PoDoFo_SOURCE_DIR})
