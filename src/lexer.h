/*
    This program is free software; you can redistribute it and/or
    modify it under the terms of version 2 of the GNU General Public
    License as published by the Free Software Foundation.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program; if not, write to the Free Software
    Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

// This file is originally written by Walter Scheppers, but allmost
// every aspect of it is slightly changed by Cies Breijs.

    
#ifndef _LEXER_H_
#define _LEXER_H_

#include "number.h"

using namespace std;

enum types {
	tokIf=-40,
	tokElse,
	tokWhile,
	tokFor,
	tokTo,
	tokStep,
	tokNumber,
	tokString,
	tokId,
	tokProcId,
	tokBegin,
	tokEnd,
		
	tokOr,
	tokAnd,
	tokNot,
	
	tokGe,
	tokGt,
	tokLe,
	tokLt,
	tokNe,
	tokEq,
	tokAssign,

	tokReturn,
	tokBreak,

	tokForEach,
	tokIn,
		
	tokRun,
	tokEof,
	tokError,
	
	tokLearn,
	
	tokClear,
	tokGo,
	tokGoX,
	tokGoY,
	tokForward,
	tokBackward,
	tokDirection,
	tokTurnLeft,
	tokTurnRight,
	tokCenter,
	tokSetPenWidth,
	tokPenUp,
	tokPenDown,
	tokSetFgColor,
	tokSetBgColor,
	tokResizeCanvas,
	tokSpriteShow,
	tokSpriteHide,
	tokSpritePress,
	tokSpriteChange,
	
	tokDo, // this is a dummy command

	tokMessage,
	tokInputWindow,
	tokPrint,
	tokFontType,
	tokFontSize,
	tokRepeat,
	tokRandom,
	tokWait,
	tokWrapOn,
	tokWrapOff,
	tokReset
};


struct token {
	Number  val;
	QString str;
	int     type;
	uint    row;
	uint    col;
};


class Lexer {
	public:
	//constructor and destructor
	Lexer(QTextIStream&);
	~Lexer() {}

	//public members
	token lex(); // returns a complete token
	// uint getRow() { return row; }
	// uint getCol() { return col; }
	QString translateCommand(QString s);
	
	private:
	//private members
	QChar getChar();
	void ungetChar(QChar);
	void skipComment();
	void skipWhite();
	void loadKeywords();
	void getToken(token&);
	int getNumber(Number&);
	int getName(QString&);
	void getStringConstant(token& t);

	//private locals
	QTextIStream    *inputStream;
	unsigned int     row, col, prevCol;
	QChar            putBackChar;
	
	typedef QMap<QString, QString> StringMap;
	StringMap        KeyMap;
	StringMap        AliasMap;
	StringMap        ReverseAliasMap;
};


#endif // _LEXER_H_


