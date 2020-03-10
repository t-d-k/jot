#if defined(_MSC_VER)
#include "stdafx.h"
#endif

#include "tokenizer.h"

#include <assert.h>
#include <codecvt>
#include <exception>
#include <iostream>
#include <regex>
#include <stdexcept>

using namespace std;

// regexes are compiled when declared
// https://stackoverflow.com/questions/40427152/compiletime-build-up-of-stdregex
// line containing a |, with no [ before it
static wregex rxPipe(LR"(([^\|\[]+)\| *(.*))");

// match up to next non | ] [ = "
// regex =  ([^\[\]\|=" ]*( *)(.*))
// static  wregex rxIdent(L"([^\\[\\]\\|=\" ]+)( *)(.*)");

// token names - could also use macros
const wstring TOK_NAMES[] = {L"Ident",
                             L"Increment Indent",
                             L"Decrement Indent",
                             L"Tag Line",
                             L"Right Brace",
                             L"Left Brace",
                             L"Pipe",
                             L"Dot",
                             L"Quote",
                             L"Equals",
                             L"NewLine",
                             L"Unknown",
                             L"Tag Block",
                             L"Right Curly Brace",
                             L"Left Curly Brace"};

uint countStripIndent(wstring &line) {
  uint count = 0;
  while (line[count++] == '\t')
    ;

  line = line.substr(--count);
  if ((line.length() > 0) && (line[0] == ' '))
    throw SyntaxError(L"Line starts with space");

  return count;
}

// taken from http://stackoverflow.com/questions/2896600/how-to-replace-all-occurrences-of-a-character-in-string
std::wstring ReplaceAll(std::wstring str, const std::wstring &from, const std::wstring &to) {
  size_t start_pos = 0;
  assert(from.length() > 0);
  while ((start_pos = str.find(from, start_pos)) != std::string::npos) {
    str.replace(start_pos, from.length(), to);
    start_pos += to.length(); // Handles case where 'to' is a substring of 'from'
  }
  return str;
}

/* special chars are: []|="{} TAB space
 * chosen as rarely used as special chars in other languages or prose
 * ~ used as escape char
 * sequences are:  ~~ == ~, ~[ == [. ~| == | etc. ~anything else = literal,
 *
 * */

wstring escapeText(const wstring line) {
  /* simply replacing in order doesnt cope with combo escape seqs eg  "[rb][rb]" - need 2 stage replace for these.
      line strings should not have \7 (bel) in, but cope with anyway
      */
  // sequence is x07 followed by ascii + 0x80
  wstring res = ReplaceAll(line, L"\x7", L"\x7\x87");
  res = ReplaceAll(res, L"~[", L"\x7\xDB");
  res = ReplaceAll(res, L"~]", L"\x7\xDD");
  res = ReplaceAll(res, L"~~", L"\x7\xFE");
  res = ReplaceAll(res, L"~|", L"\x7\xFC");
  res = ReplaceAll(res, L"~\"", L"\x7\xA2");
  res = ReplaceAll(res, L"~\t", L"\x7\x89");
  res = ReplaceAll(res, L"~ ", L"\x7\xA0");
  res = ReplaceAll(res, L"~}", L"\x7\xFD");
  res = ReplaceAll(res, L"~{", L"\x7\xFB");

  res = ReplaceAll(res, L"[left-bracket]", L"\x7\xDB");
  res = ReplaceAll(res, L"[right-bracket]", L"\x7\xDD");
  res = ReplaceAll(res, L"[left-curly]", L"\x7\xFB");
  res = ReplaceAll(res, L"[right-curly]", L"\x7\xFD");

  res = ReplaceAll(res, L"[rb]", L"\x7\xDD");
  res = ReplaceAll(res, L"[lb]", L"\x7\xDB");

  res = ReplaceAll(res, L"[pipe]", L"\x7\xFC");
  res = ReplaceAll(res, L"[tab]", L"\x7\x89");
  res = ReplaceAll(res, L"[space]", L"\x7\xA0");
  res = ReplaceAll(res, L"[quote]", L"\x7\xA2");
  res = ReplaceAll(res, L"[tilde]", L"\x7\xFE");

  return res;
}

// need to unescape jot special chars - '|', '[', \t
// also escape  <, > and &, as these are not valid in xml
//  /* */, // etc comments are NOT skipped - use '|' style tag + xslt to remove
wstring unescapeText(const wstring line) {
  wstring res = line;

  // unescape jot chars
  // ReplaceAll simpler than regex
  res = ReplaceAll(res, L"\x7\xDB", L"[");
  res = ReplaceAll(res, L"\x7\xDD", L"]");

  res = ReplaceAll(res, L"\x7\xFD", L"}");
  res = ReplaceAll(res, L"\x7\xFB", L"{");

  res = ReplaceAll(res, L"\x7\xFC", L"|");
  res = ReplaceAll(res, L"\x7\xFE", L"~");

  res = ReplaceAll(res, L"\x7\x89", L"\t");
  res = ReplaceAll(res, L"\x7\xA0", L" ");
  res = ReplaceAll(res, L"\x7\xA2", L"\"");

  res = ReplaceAll(res, L"\x7\x87", L"\x7");

  // escape xml chars
  res = ReplaceAll(res, L"&", L"&amp;");
  res = ReplaceAll(res, L"<", L"&lt;");
  res = ReplaceAll(res, L">", L"&gt;");

  return res;
}

/***************
utils
**************/
const string StripUnicode(const wstring ws) {
  std::string s(ws.begin(), ws.end());
  return s;
}

/***************
SyntaxError
**************/
SyntaxError::SyntaxError(const wstring &message) : runtime_error(StripUnicode(message).c_str()) {}

/***************
tokenizer
**************/
bool tokenizer::eof() { return jotStream.eof(); }

wstring tokenizer::tokType2str(tokType type) { return TOK_NAMES[type]; }

void tokenizer::rewind() {
  lineNum = 0;
  fLastIndent = 0;
  linePos = 0;
}

indLine tokenizer::getNextLine() {
  indLine line;
  wstring str;
  getline(jotStream, str);

  // on unix getline does not strip CRs
  ulong sz = str.size();
  if ((sz > 0) && (str[sz - 1] == L'\r'))
    str.resize(sz - 1);
  line.line = str;
  lineNum++;
  line.indent = static_cast<int>(countStripIndent(line.line));
  line.line = escapeText(line.line);

  /* for usability, blank lines are treated as indented to the same level as the line above   */
  if (line.line == L"") {
    line.indent = fLastIndent;
  }
  fLastIndent = line.indent;
  if (!eof()) {
    if (jotStream.fail())
      throw SyntaxError(L"Error reading line");
  }
  // fEof = false;

  return line;
}

token tokenizer::getNextToken() {

  if (pendingIndents < 0) {
    curTok.type = eDecIndent;
    pendingIndents++;
    return curTok;
  }
  if (pendingIndents > 0) {
    curTok.type = eIncIndent;
    pendingIndents--;
    return curTok;
  }

  // if last token = dec indent, next is newline
  if (curTok.type == eDecIndent) {
    curTok.type = eNewLine;
    return curTok;
  }

  curTok.type = eUnknown;
  curTok.after = L"";
  curTok.str = L"";
  int thisIndent = curLine.indent;
  // if exhausted line, go to next
  if (curLine.line.length() == 0) {
    lineStart = true;

    curLine = getNextLine();
    linePos = curLine.indent; // skip tabs
    curTok.indent = curLine.indent;

    if (eof()) {
      curTok.type = eDecIndent;
      throw EofExcept();
    }

    int indentsDiff = curLine.indent - thisIndent;
    if (indentsDiff != 0) {

      if (indentsDiff > 0) {
        curTok.type = eIncIndent;
        indentsDiff--;
      } else {
        curTok.type = eDecIndent;
        indentsDiff++;
      }
      pendingIndents = indentsDiff;
    } else {
      curTok.type = eNewLine;
    }
  } // if( curLine.line.length() == 0)

  // if no indent change found
  if (curTok.type == eUnknown) {
    /*
                    grammar LL(infinite) as "\na b=c d=e ... |\n" is treated differently from "\na b=c d=e ...\n"
                    coped with by having contrived 'tagline' token at start of line
                    */

    // check for taglines if looking at start of line, else tagline may already be reported
    if (lineStart) {
      // line containing a |, with no [ before it
      match_results<std::wstring::const_iterator> mr;

      if (regex_match(curLine.line, mr, rxPipe)) {
        if (mr[2].length() > 0) {
          curTok.type = eTagLine; // eg abc d=e|xyz\n

        } else {
          curTok.type = eTagBlock; // eg abc|\n
        }
      }
    }
    lineStart = false;

    if (curTok.type == eUnknown) {

      // escape seqs eg [space] already removed
      wchar_t nextCh = curLine.line[0];

      switch (nextCh) {
      case ']':
        curTok.type = eRightBrace;
        break;
      case '[':
        curTok.type = eLeftBrace;
        break;
      case '}':
        curTok.type = eRightCurly;
        break;
      case '{':
        curTok.type = eLeftCurly;
        break;
      case '|':
        curTok.type = ePipe;
        break;
      case '"':
        curTok.type = eQuote;
        break;
      case '.':
        curTok.type = eDot;
        break;
      case '=':
        curTok.type = eEquals;
        break;
      default:

        break;
      } // switch

      // if is single character, inc position
      if (curTok.type != eUnknown) {
        curLine.line = curLine.line.substr(1);
        linePos++;
        curTok.str = nextCh;
        // add spaces
        while (curLine.line[0] == ' ') {
          curLine.line = curLine.line.substr(1);
          linePos++;
          curTok.after += L" ";
        }
      } else {
        // check for identifier
        // match up to next non: |, ], [, =, ", space, {}
        size_t pos = curLine.line.find_first_of(L"[]| =\"{}");
        if (pos == wstring::npos) {
          pos = curLine.line.length();
        }
        curTok.type = eIdent;
        curTok.str = curLine.line.substr(0, pos);
        curLine.line = curLine.line.substr(pos);
        curTok.after = L"";
        while (curLine.line[0] == ' ') {
          curTok.after += ' ';
          curLine.line = curLine.line.substr(1);
        }
        linePos += curTok.str.length() + curTok.after.length();
        /* regex v. slow
        //regex =  ([^\[\]\|=" ]*( *)(.*))
        match_results<wstring::const_iterator> mr2;
        if(regex_match(curLine.line, mr2, rxIdent)){
        curTok.type = eIdent;
        curTok.str = mr2[1];
        curTok.after = mr2[2];
        curLine.line = mr2[3];
        linePos+= curTok.str.length() + curTok.after.length();

        }else{
        assert(false);
        }
        */
      }

    } // if(res.type == eUnknown)
  }   // if(res.type == eUnknown){

  return curTok;
} // getNextToken

tokenizer::tokenizer(wistream &jotStream) : jotStream(jotStream) {
  jotStream.imbue(locale(jotStream.getloc(), new codecvt_utf8_utf16<wchar_t>));

  // ensure when start parsing - first line is treated as indented
  curLine.indent = -1;
  pendingIndents = 0;
  curTok.type = eUnknown;
} // ctor

tokenizer::~tokenizer() {} // dtor
