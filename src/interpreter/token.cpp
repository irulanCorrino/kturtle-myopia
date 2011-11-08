/*
	Copyright (C) 2003-2009 Cies Breijs <cies AT kde DOT nl>

    This program is free software; you can redistribute it and/or
    modify it under the terms of the GNU General Public
    License as published by the Free Software Foundation; either
    version 2 of the License, or (at your option) any later version.

	This program is distributed in the hope that it will be useful,
	but WITHOUT ANY WARRANTY; without even the implied warranty of
	MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
	GNU General Public License for more details.

	You should have received a copy of the GNU General Public
	License along with this program; if not, write to the Free
	Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
	Boston, MA 02110-1301, USA.
*/


#include "token.h"


Token::Token()
	: _type(Token::NotSet),
	  _look(""),
	  _startRow(0),
	  _startCol(0),
	  _endRow(0),
	  _endCol(0)
{
}


Token::Token(int type, const QString& look, int startRow, int startCol, int endRow, int endCol)
	: _type(type),
	  _look(look),
	  _startRow(startRow),
	  _startCol(startCol),
	  _endRow(endRow),
	  _endCol(endCol)
{
}


bool Token::operator==(const Token& n) const
{
	if (n.type()     == _type ||
	    n.look()     == _look ||
	    n.startRow() == _startRow ||
	    n.startCol() == _startCol ||
	    n.endRow()   == _endRow ||
	    n.endCol()   == _endCol) return true;
	return false;
}


Token& Token::operator=(const Token& n)
{
	_type     = n.type();
	_look     = n.look();
	_startRow = n.startRow();
	_startCol = n.startCol();
	_endRow   = n.endRow();
	_endCol   = n.endCol();
	return *this;
}


int Token::typeToCategory(int type)
{
	switch (type) {

//BEGIN GENERATED token_switch_cpp CODE

/* The code between the line that start with "//BEGIN GENERATED" and "//END GENERATED"
 * is generated by "generate.rb" according to the definitions specified in
 * "definitions.rb". Please make all changes in the "definitions.rb" file, since all
 * all change you make here will be overwritten the next time "generate.rb" is run.
 * Thanks for looking at the code!
 */

		case Mod:
		case Sin:
		case GoX:
		case GoY:
		case FontSize:
		case GetDirection:
		case Cos:
		case CanvasColor:
		case Tan:
		case Backward:
		case CanvasSize:
		case TurnRight:
		case Pi:
		case Forward:
		case Message:
		case Random:
		case Sqrt:
		case Go:
		case ArcSin:
		case Ask:
		case Assert:
		case PenUp:
		case Print:
		case Clear:
		case ArcCos:
		case SpriteHide:
		case TurnLeft:
		case PenWidth:
		case Direction:
		case ArcTan:
		case SpriteShow:
		case Center:
		case Round:
		case GetX:
		case GetY:
		case PenColor:
		case PenDown:
		case Reset:
			return CommandCategory;

		case Else:
		case Break:
		case Return:
		case While:
		case Step:
		case For:
		case Wait:
		case ForTo:
		case Repeat:
		case To:
		case Exit:
		case If:
			return ControllerCommandCategory;

		case Number:
			return NumberCategory;

		case ParenthesisOpen:
		case ParenthesisClose:
			return ParenthesisCategory;

		case True:
		case False:
			return TrueFalseCategory;

		case FunctionCall:
			return FunctionCallCategory;

		case GreaterThan:
		case LessOrEquals:
		case Equals:
		case LessThan:
		case GreaterOrEquals:
		case NotEquals:
			return ExpressionCategory;

		case ArgumentSeparator:
			return ArgumentSeparatorCategory;

		case Power:
		case Substracton:
		case Multiplication:
		case Division:
		case Addition:
			return MathOperatorCategory;

		case Comment:
			return CommentCategory;

		case Assign:
			return AssignmentCategory;

		case Or:
		case And:
		case Not:
			return BooleanOperatorCategory;

		case Scope:
		case ScopeOpen:
		case ScopeClose:
			return ScopeCategory;

		case Variable:
			return VariableCategory;

		case StringDelimiter:
		case String:
			return StringCategory;

		case Learn:
			return LearnCommandCategory;


//END GENERATED token_switch_cpp CODE

	}
	return UnknownCategory;
}




