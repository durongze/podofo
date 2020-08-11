/***************************************************************************
 *   Copyright (C) 2006 by Dominik Seichter                                *
 *   domseichter@web.de                                                    *
 *                                                                         *
 *   This program is free software; you can redistribute it and/or modify  *
 *   it under the terms of the GNU General Public License as published by  *
 *   the Free Software Foundation; either version 2 of the License, or     *
 *   (at your option) any later version.                                   *
 *                                                                         *
 *   This program is distributed in the hope that it will be useful,       *
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of        *
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the         *
 *   GNU General Public License for more details.                          *
 *                                                                         *
 *   You should have received a copy of the GNU General Public License     *
 *   along with this program; if not, write to the                         *
 *   Free Software Foundation, Inc.,                                       *
 *   59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.             *
 ***************************************************************************/


/*
 * Include the standard headers for cout to write
 * some output to the console.
 */
#include <iostream>

/*
 * Now include all podofo header files, to have access
 * to all functions of podofo and so that you do not have
 * to care about the order of includes.
 *
 * You should always use podofo.h and not try to include
 * the required headers on your own.
 */
#include <podofo/podofo.h>
#include "tinyxml.h"
/*
 * All podofo classes are member of the PoDoFo namespace.
 */
using namespace PoDoFo;

void PrintHelp()
{
    std::cout << "This is a example application for the PoDoFo PDF library." << std::endl
              << "It creates a small PDF file containing the text >Hello World!<" << std::endl
              << "Please see http://podofo.sf.net for more information" << std::endl << std::endl;
    std::cout << "Usage:" << std::endl;
    std::cout << "  examplehelloworld [outputfile.pdf]" << std::endl << std::endl;
}

void HelloWorld( const char* pszFilename )
{
    /*
     * PdfStreamedDocument is the class that can actually write a PDF file.
     * PdfStreamedDocument is much faster than PdfDocument, but it is only
     * suitable for creating/drawing PDF files and cannot modify existing
     * PDF documents.
     *
     * The document is written directly to pszFilename while being created.
     */
    PdfStreamedDocument document( pszFilename );

	/*
     * PdfPainter is the class which is able to draw text and graphics
     * directly on a PdfPage object.
     */
    PdfPainter painter;

	/*
     * This pointer will hold the page object later.
     * PdfSimpleWriter can write several PdfPage's to a PDF file.
     */
    PdfPage* pPage;

	/*
     * A PdfFont object is required to draw text on a PdfPage using a PdfPainter.
     * PoDoFo will find the font using fontconfig on your system and embedd truetype
     * fonts automatically in the PDF file.
     */
    PdfFont* pFont;

	try {
		/*
		 * The PdfDocument object can be used to create new PdfPage objects.
		 * The PdfPage object is owned by the PdfDocument will also be deleted automatically
		 * by the PdfDocument object.
		 *
		 * You have to pass only one argument, i.e. the page size of the page to create.
		 * There are predefined enums for some common page sizes.
		 */
		pPage = document.CreatePage( PdfPage::CreateStandardPageSize( ePdfPageSize_A4 ) );

		/*
		 * If the page cannot be created because of an error (e.g. ePdfError_OutOfMemory )
		 * a NULL pointer is returned.
		 * We check for a NULL pointer here and throw an exception using the RAISE_ERROR macro.
		 * The raise error macro initializes a PdfError object with a given error code and
		 * the location in the file in which the error ocurred and throws it as an exception.
		 */
		if( !pPage )
		{
			PODOFO_RAISE_ERROR( ePdfError_InvalidHandle );
		}

		/*
		 * Set the page as drawing target for the PdfPainter.
		 * Before the painter can draw, a page has to be set first.
		 */
		painter.SetPage( pPage );

		/*
		 * Create a PdfFont object using the font "Arial".
		 * The font is found on the system using fontconfig and embedded into the
		 * PDF file. If Arial is not available, a default font will be used.
		 *
		 * The created PdfFont will be deleted by the PdfDocument.
		 */
		pFont = document.CreateFont( "Arial" );

		/*
		 * If the PdfFont object cannot be allocated return an error.
		 */
		if( !pFont )
		{
			PODOFO_RAISE_ERROR( ePdfError_InvalidHandle );
		}

		/*
		 * Set the font size
		 */
		pFont->SetFontSize( 18.0 );

		/*
		 * Set the font as default font for drawing.
		 * A font has to be set before you can draw text on
		 * a PdfPainter.
		 */
		painter.SetFont( pFont );

		/*
		 * You could set a different color than black to draw
		 * the text.
		 *
		 * SAFE_OP( painter.SetColor( 1.0, 0.0, 0.0 ) );
		 */

		/*
		 * Actually draw the line "Hello World!" on to the PdfPage at
		 * the position 2cm,2cm from the top left corner.
		 * Please remember that PDF files have their origin at the
		 * bottom left corner. Therefore we substract the y coordinate
		 * from the page height.
		 *
		 * The position specifies the start of the baseline of the text.
		 *
		 * All coordinates in PoDoFo are in PDF units.
		 * You can also use PdfPainterMM which takes coordinates in 1/1000th mm.
		 *
		 */
		painter.DrawText( 56.69, pPage->GetPageSize().GetHeight() - 56.69, "Hello World!" );
		//painter.DrawGlyph();

		/*
		 * Tell PoDoFo that the page has been drawn completely.
		 * This required to optimize drawing operations inside in PoDoFo
		 * and has to be done whenever you are done with drawing a page.
		 */
		painter.FinishPage();

		/*
		 * Set some additional information on the PDF file.
		 */
		document.GetInfo()->SetCreator ( PdfString("examplahelloworld - A PoDoFo test application") );
		document.GetInfo()->SetAuthor  ( PdfString("Dominik Seichter") );
		document.GetInfo()->SetTitle   ( PdfString("Hello World") );
		document.GetInfo()->SetSubject ( PdfString("Testing the PoDoFo PDF Library") );
		document.GetInfo()->SetKeywords( PdfString("Test;PDF;Hello World;") );

		/*
		 * The last step is to close the document.
		 */
		document.Close();
	} catch ( PdfError & e ) {
		/*
		 * All PoDoFo methods may throw exceptions
		 * make sure that painter.FinishPage() is called
		 * or who will get an assert in its destructor
		 */
		try {
			painter.FinishPage();
		} catch( ... ) {
			/*
			 * Ignore errors this time
			 */
		}

		throw e;
	}
}

inline wchar_t* AnsiToUnicode(const char* szStr)
{
	int nLen = MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, szStr, -1, NULL, 0);
	if (nLen == 0)
	{
		return NULL;
	}
	wchar_t* pResult = new wchar_t[nLen];
	MultiByteToWideChar(CP_ACP, MB_PRECOMPOSED, szStr, -1, pResult, nLen);
	return pResult;
}

inline char* UnicodeToAnsi(const wchar_t* szStr)
{
	int nLen = WideCharToMultiByte(CP_ACP, 0, szStr, -1, NULL, 0, NULL, NULL);
	if (nLen == 0)
	{
		return NULL;
	}
	char* pResult = new char[nLen];
	WideCharToMultiByte(CP_ACP, 0, szStr, -1, pResult, nLen, NULL, NULL);
	return pResult;
}

void ShowOutLines(PdfMemDocument *mDoc, std::ostream& sOutStream, PoDoFo::PdfOutlineItem* pItem, int level)
{
	PoDoFo::PdfOutlines* pOutlines;
	int          i;

	if (!pItem)	{
		pOutlines = mDoc->GetOutlines(PoDoFo::ePdfDontCreateObject);
		if (!pOutlines || !pOutlines->First()) {
			sOutStream << "\tNone Found" << std::endl;
			return;
		}
		pItem = pOutlines->First();
	}

	for (i = 0; i<level; i++)
		sOutStream << "-";

	sOutStream << ">" << pItem->GetTitle().GetString();
	PoDoFo::PdfDestination* pDest = pItem->GetDestination(mDoc);
	if (pDest) {   // then it's a destination

		PoDoFo::PdfPage* pPage = pDest->GetPage(mDoc);
		if (pPage)
			sOutStream << "\tDestination: Page #" << pPage->GetPageNumber();
		else
			sOutStream << "\tDestination: Page #" << "???";

	}
	else {
		// then it's one or more actions
		sOutStream << "\tAction: " << "???";
		PdfAction* action = pItem->GetAction();
		PdfObject *object = action->GetObject();
		PdfDictionary dictionary = object->GetDictionary();
		//Getting Access violation error.
		if (dictionary.HasKey(PdfName("D")))
		{

		}
	}
	sOutStream << std::endl;

	if (pItem->First())
		ShowOutLines(mDoc, sOutStream, pItem->First(), level + 1);

	if (pItem->Next())
		ShowOutLines(mDoc, sOutStream, pItem->Next(), level);
}


int ShowDoc(PdfMemDocument *pdfDoc)
{
	PdfOutlines* outlines = pdfDoc->GetOutlines();
	PdfOutlineItem* outline = outlines->First();
	for (outline = outlines->First(); outline != NULL; outline = outline->Next())
	{
		PdfString title = outline->GetTitle();
		PdfDestination* des = outline->GetDestination(pdfDoc);
		if (des != NULL) {
			PdfPage* page = des->GetPage(&pdfDoc->GetObjects());
			if (page != NULL)
				int pageNo = page->GetPageNumber();
		} else {
			PdfAction* action = outline->GetAction();
			EPdfAction actionType = (EPdfAction)action->GetType();
			PdfObject *object = action->GetObject();
			PdfDictionary dictionary = object->GetDictionary();
			if (action->HasScript()) {
				PdfString script = action->GetScript();
			}
			if (action->HasURI()) {
				PdfString s = action->GetURI();
			}
		}
	}
	return 0;
}

int AddBookMarkBy(PdfMemDocument &doc, PdfOutlineItem*& bmRoot,
	TiXmlElement*& xmlRoot);

typedef struct {
	PdfString *str;
	PdfDestination *dest;
} PdfDestStr;

void FreeDestStr(PdfDestStr *dstStr)
{
	if (dstStr) {
		if (dstStr->str) { delete dstStr->str; }
		if (dstStr->dest) { delete dstStr->dest; }
		delete dstStr;
	}
}

PdfDestStr *CreateDestStr(PdfMemDocument&doc, TiXmlElement *xmlItem)
{
	int pNo = 0;
	PdfDestStr *dstStr = new PdfDestStr();
	TiXmlElement *xmlItemA = xmlItem->FirstChildElement();
	const char *itemText = NULL;
	const char *itemHref = NULL;
	itemHref = xmlItemA->Attribute("href");
	itemText = xmlItemA->GetText();
	if (itemText == NULL) {
		return NULL;
	}
	//if (strncmp(itemText, "Catalog", strlen("Catalog")) == 0) {
		pNo = atoi(itemHref);
	//}
	wchar_t* pStr = AnsiToUnicode(itemText);
	//wchar_t* pStr = (wchar_t*)(itemText);
	dstStr->str = new PdfString(pStr);
	delete[] pStr;

	dstStr->dest = new PdfDestination(doc.GetPage(pNo));
	doc.AddNamedDestination(*(dstStr->dest), *(dstStr->str));

	return dstStr;
}

int InitBookMark(PdfMemDocument&doc, PdfOutlineItem*& bmRoot, PdfOutlineItem*& bmItem,
	TiXmlElement*& xmlRoot, TiXmlElement*& xmlItem)
{
	if (xmlRoot == NULL) {
		bmItem = NULL;
		xmlItem = NULL;
		return -1;
	}
	TiXmlElement *xmlItemA = xmlRoot;
	PdfDestStr *dstStr = CreateDestStr(doc, xmlItemA);
	if (dstStr == NULL) {
		xmlItem = NULL;
		return -1;
	}
	bmItem = bmRoot->CreateChild(*(dstStr->str), *(dstStr->dest));
	TiXmlElement *xmlSubItem = NULL;
	xmlSubItem = xmlItemA->FirstChildElement();
	if (xmlSubItem) {
		xmlSubItem = xmlSubItem->NextSiblingElement();
		AddBookMarkBy(doc, bmItem, xmlSubItem);
	}
	xmlItem = xmlItemA->NextSiblingElement();
	FreeDestStr(dstStr);
	return 0;
}

int IncreaseBookMark(PdfMemDocument&doc, PdfOutlineItem*& bmItem,
	TiXmlElement*& xmlItem)
{
	if (bmItem == NULL || xmlItem == NULL) {
		return -1;
	}
	TiXmlElement *xmlItemA = xmlItem;
	PdfDestStr *dstStr = CreateDestStr(doc, xmlItemA);
	if (dstStr == NULL) {
		xmlItem = NULL;
		return -1;
	}
	bmItem = bmItem->CreateNext(*(dstStr->str), *(dstStr->dest));

	TiXmlElement *xmlSubItem = NULL;
	xmlSubItem = xmlItemA->FirstChildElement();
	if (xmlSubItem) {
		xmlSubItem = xmlSubItem->NextSiblingElement();
		AddBookMarkBy(doc, bmItem, xmlSubItem);
	}

	xmlItem = xmlItem->NextSiblingElement();
	FreeDestStr(dstStr);
	return 0;
}

int AddBookMarkBy(PdfMemDocument &doc, PdfOutlineItem*& bmRoot,
	TiXmlElement*& xmlRoot)
{
	if (bmRoot == NULL || xmlRoot == NULL) {
		return -1;
	}
	PdfOutlineItem* bmItem = NULL;
	TiXmlElement *xmlItem = NULL;
	TiXmlElement *xmlItemA = NULL;
	for (InitBookMark(doc, bmRoot, bmItem, xmlRoot, xmlItem);
		bmItem != NULL && xmlItem != NULL;
		IncreaseBookMark(doc, bmItem, xmlItem)) {
		const char *itemText = NULL;
		const char *itemHref = NULL;
		xmlItemA = xmlItem->FirstChildElement();
		itemHref = xmlItemA->Attribute("href");
		itemText = xmlItemA->GetText();
		LogInfo("Text:%s\n", itemText);
	}
	return 0;
}

int AddBookMark(PdfMemDocument &docFirst, const char *bm)
{
	const char *xmlBookHref = NULL;
	docFirst.DumpInfo();
	TiXmlDocument xmlBm;
	
	xmlBm.LoadFile(bm);
	TiXmlElement *xmlHtml = xmlBm.FirstChildElement("html");
	TiXmlElement *xmlBody = xmlHtml->FirstChildElement("body");

	PdfOutlines* bMarks = docFirst.GetOutlines();
	PdfOutlineItem*	bmRoot = bMarks->CreateRoot(bm);

	TiXmlElement *xmlRoot = NULL;
	for (xmlRoot = xmlBody->FirstChildElement(); 
		xmlRoot != NULL && xmlRoot->FirstChildElement() == NULL;
		xmlRoot = xmlRoot->NextSiblingElement()) {
		LogInfo("%s\n", xmlRoot->GetText());
	}
	
	AddBookMarkBy(docFirst, bmRoot, xmlRoot);

	return 0;
}

int MergeDoc(const char *firstFile, const char *secondFile, const char *doc, const char *bm)
{
	PdfMemDocument docFirst(firstFile);
	PdfMemDocument docSecond(secondFile);

	docFirst.DumpInfo();

	docFirst.Append(docSecond);

	AddBookMark(docFirst, bm);

#ifdef TEST_FULL_SCREEN
	input1.SetUseFullScreen();
#else
	docFirst.SetPageMode(ePdfPageModeUseBookmarks);
	docFirst.SetHideToolbar();
	docFirst.SetPageLayout(ePdfPageLayoutTwoColumnLeft);
#endif

	docFirst.Write(doc);
	return 0;
}

void DumpXmlDeclaration(TiXmlDeclaration *decl)
{
	if (NULL != decl)
	{
		std::cout << decl->Version() << std::endl;
		std::cout << decl->Standalone() << std::endl;
		std::cout << decl->Encoding() << std::endl;
	}
}

void DumpXmlNode(TiXmlElement* name)
{

	if (NULL != name)
	{
		if (NULL != name->Value())
			std::cout << "Value:" << name->Value() << " ";
		if (NULL != name->GetText())
			std::cout << "Text:" << name->GetText() << " ";
		std::cout << std::endl;
		TiXmlElement *aXml = name->FirstChildElement();
		DumpXmlNode(aXml);
	}
}

TiXmlElement *FindChapter(TiXmlElement* body, const char *chapter)
{
	if (body == NULL) return NULL;
	TiXmlElement* chapterXml = NULL;
	chapterXml = body->FirstChildElement();
	DumpXmlNode(chapterXml);
	return chapterXml;
}

TiXmlElement *FindLastChapter(TiXmlElement* body, const char *chapter)
{
	if (body == NULL) return NULL;
	TiXmlElement* chapterXml = NULL;
	chapterXml = body->FirstChildElement();
	for (; chapterXml != NULL && chapterXml->NextSiblingElement() != NULL; chapterXml = (TiXmlElement*)chapterXml->NextSiblingElement()) {}
	DumpXmlNode(chapterXml);
	return chapterXml;
}

TiXmlElement *AppendChapter(TiXmlElement* body, const char *chapter, const char *pageno)
{
	TiXmlElement *n = new TiXmlElement("div");
	n->SetAttribute("class", "kindle-cn-toc-level-1");
	TiXmlElement *a = new TiXmlElement("a");
	a->SetAttribute("href", pageno);
	TiXmlText newText(chapter);
	a->LinkEndChild(&newText);
	n->InsertEndChild(*a);
	body->InsertEndChild(*n);
	return FindLastChapter(body, NULL);
}

TiXmlElement *FindSection(TiXmlElement* chapter, const char *section)
{
	if (chapter == NULL) return NULL;
	TiXmlElement* sectionXml = NULL;
	sectionXml = chapter->FirstChildElement();
	sectionXml = sectionXml->NextSiblingElement();
	DumpXmlNode(sectionXml);
	return sectionXml;
}

TiXmlElement *FindLastSection(TiXmlElement* chapter, const char *section)
{
	if (chapter == NULL) return NULL;
	TiXmlElement* sectionXml = NULL;
	sectionXml = chapter->FirstChildElement();
	int idx = 0;
	for (; sectionXml != NULL && sectionXml->NextSiblingElement() != NULL; sectionXml = sectionXml->NextSiblingElement()) {
		idx++;
	}
	if (idx == 0) {
		return NULL;
	} else {
		DumpXmlNode(sectionXml);
		return sectionXml;
	}
}

TiXmlElement *AppendSection(TiXmlElement* chapter, const char *section, const char *pageno)
{
	TiXmlElement *n = new TiXmlElement("div");
	n->SetAttribute("class", "kindle-cn-toc-level-2");
	TiXmlElement *a = new TiXmlElement("a");
	a->SetAttribute("href", pageno);
	TiXmlText newText(section);
	a->LinkEndChild(&newText);
	n->InsertEndChild(*a);
	chapter->InsertEndChild(*n);
	return FindLastSection(chapter, NULL);
}

TiXmlElement *FindLesson(TiXmlElement* section, const char *lesson)
{
	if (section == NULL) return NULL;
	TiXmlElement* lessonXml = NULL;
	lessonXml = section->FirstChildElement();
	lessonXml = lessonXml->NextSiblingElement();
	DumpXmlNode(lessonXml);
	return lessonXml;
}

TiXmlElement *FindLastLesson(TiXmlElement* section, const char *lesson)
{
	if (section == NULL) return NULL;
	TiXmlElement* lessonXml = NULL;
	lessonXml = (TiXmlElement*)section->FirstChildElement();
	int idx = 0;
	for (; lessonXml != NULL && lessonXml->NextSiblingElement() != NULL; lessonXml = lessonXml->NextSiblingElement()) {
		idx++;
	}
	if (idx == 0) {
		return NULL;
	} else {
		DumpXmlNode(lessonXml);
		return lessonXml;
	}
}

TiXmlElement *AppendLesson(TiXmlElement* section, const char *lesson, const char *pageno)
{
	TiXmlElement *n = new TiXmlElement("div");
	n->SetAttribute("class", "kindle-cn-toc-level-3");
	TiXmlElement *a = new TiXmlElement("a");
	a->SetAttribute("href", pageno);
	TiXmlText newText(lesson);
	a->LinkEndChild(&newText);
	n->InsertEndChild(*a);
	section->InsertEndChild(*n);
	return FindLastSection(section, NULL);
}

TiXmlElement *AppendChapterByBody(TiXmlElement* body, const char *chapter, const char *pageno)
{
	if (body == NULL) {
		return NULL;
	}
	return AppendChapter(body, chapter, pageno);
}

TiXmlElement *AppendSectionByBody(TiXmlElement* body, const char *section, const char *pageno)
{
	if (body == NULL) {
		return NULL;
	}
	TiXmlElement *chapter = FindLastChapter(body, NULL);
	if (chapter == NULL) {
		return AppendSection(body, section, pageno);
	}
	return AppendSection(chapter, section, pageno);
}

TiXmlElement *AppendLessonByBody(TiXmlElement* body, const char *lesson, const char *pageno)
{
	if (body == NULL) {
		return NULL;
	}
	TiXmlElement *chapter = FindLastChapter(body, NULL);
	if (chapter == NULL) {
		return AppendSection(body, lesson, pageno);
	}
	TiXmlElement *section = FindLastSection(chapter, NULL);
	if (section == NULL) {
		return AppendSection(chapter, lesson, pageno);
	}
	return AppendSection(section, lesson, pageno);
}

int GenXmlDoc(const char* docName, int type, const char *title, const char *pageno)
{
	TiXmlDocument doc;
	doc.LoadFile(docName);

	if (docName == NULL || title == NULL || pageno == NULL) {
		return 0;
	}
	/*<?xml version="1.0" standalone="yes"?>,
	声明对象具有三个属性值，版本，编码和独立文件声明 */
	TiXmlNode * node = doc.FirstChild();
	if (NULL != node) {
		TiXmlDeclaration *decl = node->ToDeclaration();
		DumpXmlDeclaration(decl);
	}

	TiXmlElement* root = doc.RootElement();
	TiXmlElement* body = NULL;
	if (NULL != root) {
		TiXmlElement* head = root->FirstChildElement();
		DumpXmlNode(head);
		if (head) {
			body = head->NextSiblingElement();
			DumpXmlNode(body);
		}
	}
	if (type == 1) {
		TiXmlElement *chpater = AppendChapterByBody(body, title, pageno);
	} else if (type == 2) {
		TiXmlElement *section = AppendSectionByBody(body, title, pageno);
	} else {
		TiXmlElement *lesson = AppendLessonByBody(body, title, pageno);
	}
	doc.SaveFile(docName);
	return 0;
}

int main( int argc, char* argv[] )
{
	SetConsoleOutputCP(CP_WINUNICODE);
	
	// SetConsoleOutputCP(CP_UTF8);
	// SetConsoleOutputCP(CP_ACP);
	PdfMemDocument doc("lang_wen.pdf");
	doc.DumpInfo();
	// AddBookMark(doc, "lang_wen.xml");
	doc.Write("lang_wen_bm.pdf");

	// MergeDoc("a1-without-bookmarks.pdf", "a1-without-bookmarks.pdf", "a1-with-bookmarks.pdf");
	// MergeDoc("a1-with-bookmarks.pdf", "a1-with-bookmarks.pdf", "two-with-bookmarks.pdf");
	//MergeDoc("two-with-bookmarks.pdf", "two-with-bookmarks.pdf", "multi-with-bookmarks.pdf", "bookmark.xml");
    /*
     * Check if a filename was passed as commandline argument.
     * If more than 1 argument or no argument is passed,
     * a help message is displayed and the example application
     * will quit.
     */
    if( argc != 2 )
    {
        PrintHelp();
        return -1;
    }

    /*
     * All podofo functions will throw an exception in case of an error.
     *
     * You should catch the exception to either fix it or report
     * back to the user.
     *
     * All exceptions podofo throws are objects of the class PdfError.
     * Thats why we simply catch PdfError objects.
     */
    try {
        /*
         * Call the drawing routing which will create a PDF file
         * with the filename of the output file as argument.
         */
         HelloWorld( argv[1] );
    } catch( PdfError & eCode ) {
        /*
         * We have to check if an error has occurred.
         * If yes, we return and print an error message
         * to the commandline.
         */
        eCode.PrintErrorMsg();
        return eCode.GetError();
    }


    try {
        /**
         * Free global memory allocated by PoDoFo.
         * This is normally not necessary as memory
         * will be free'd when the application terminates.
         *
         * If you want to free all memory allocated by
         * PoDoFo you have to call this method.
         *
         * PoDoFo will reallocate the memory if necessary.
         */
        PdfEncodingFactory::FreeGlobalEncodingInstances();
    } catch( PdfError & eCode ) {
        /*
         * We have to check if an error has occurred.
         * If yes, we return and print an error message
         * to the commandline.
         */
        eCode.PrintErrorMsg();
        return eCode.GetError();
    }

    /*
     * The PDF was created sucessfully.
     */
    std::cout << std::endl
              << "Created a PDF file containing the line \"Hello World!\": " << argv[1] << std::endl << std::endl;

    return 0;
}
