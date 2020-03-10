#if (_MSC_VER )
#include "stdafx.h"
#endif

#include <string> 
#include <fstream>
#include <stdexcept>

/*  hack in tokenizer to make LL(1) */

using namespace std;

struct indLine{
	wstring line;
	int indent;
};


enum tokType {eIdent,eIncIndent,eDecIndent,eTagLine/* a tag without a [, ending in | with non-white space after it, */,
            /*   eTagLineEmpty a tag without = in it, without a [, ending in | with non-white space after it, */
               eRightBrace,eLeftBrace,ePipe,eDot,
	eQuote,eEquals,eNewLine,eUnknown,eTagBlock/* a tag without a [ ending in | on line on own */,
               eLeftCurly,eRightCurly};

struct token{
	tokType type ;
	wstring str,after/* white space after*/;
	int indent;
};
 
class tokenizer{
private:
	int fLastIndent;
			int pendingIndents; // when indents change by > 1, store pending indent changes

	indLine curLine;
	bool lineStart;
        wistream& jotStream;
	indLine getNextLine () ;
public:
	int linePos;

	token curTok;
	bool eof() ;
	token getNextToken();

	void rewind();
	int lineNum;

        tokenizer(	wistream& jotStream);
	~tokenizer();
	wstring tokType2str(tokType type);
private:
	//disable copying bc wifstream can't be copied - see 
	tokenizer(const tokenizer&) ;
	tokenizer& operator=(const tokenizer&) ;
};



class EofExcept : public exception {};

class SyntaxError : public runtime_error {
public:
	SyntaxError(const wstring& message);
};

wstring unescapeText(const wstring line);
