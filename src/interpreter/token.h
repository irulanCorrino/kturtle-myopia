/*
	SPDX-FileCopyrightText: 2003-2009 Cies Breijs <cies AT kde DOT nl>

    SPDX-License-Identifier: GPL-2.0-or-later
*/


#ifndef _TOKEN_H_
#define _TOKEN_H_

#include <QString>


/**
 * @short The Token object, represents a piece of TurtleScript as found by the Tokenizer.
 *
 * Because of the goals of KTurtle it this class very elaborate. Much info
 * about each token is kept so descriptive error messages can be printed,
 * and proper highlighting and context help made possible.
 *
 * Tokens are made by the Tokenizer according to the TurtleScript, then they are stored
 * in the node tree by the Parser or used by the Highlighter of for context help.
 *
 * A large potion of the code of this class (the Type enum) is generated code.
 *
 * @TODO investigate if it will be better to replace this class by a struct for speed.
 *
 * @author Cies Breijs
 */
class Token
{
	public:
		/**
		 * This is an enum for the different types a Token can have.
		 * The code for this enum is generated.
		 */
		enum Type
		{
			Error   = -2,  // when the Tokenizer finds something it cannot deal with (like a single dot)
			Unknown = -1,  // when the Translator found no translation (like when calling a learned function)
			NotSet  =  0,  // when Tokens are constructed without being initialized (needed for ErrorList)

//BEGIN GENERATED token_type_h CODE

/* The code between the line that start with "//BEGIN GENERATED" and "//END GENERATED"
 * is generated by "generate.rb" according to the definitions specified in
 * "definitions.rb". Please make all changes in the "definitions.rb" file, since all
 * all change you make here will be overwritten the next time "generate.rb" is run.
 * Thanks for looking at the code!
 */

			Root,
			Scope,
			WhiteSpace,
			EndOfLine,
			EndOfInput,
			VariablePrefix,
			Variable,
			FunctionCall,
			String,
			Number,
			True,
			False,
			Comment,
			StringDelimiter,
			ScopeOpen,
			ScopeClose,
			ParenthesisOpen,
			ParenthesisClose,
			ArgumentSeparator,
			DecimalSeparator,
			Exit,
			If,
			Else,
			Repeat,
			While,
			For,
			ForTo,
			To,
			Step,
			Break,
			Return,
			Wait,
			Assert,
			And,
			Or,
			Not,
			Equals,
			NotEquals,
			GreaterThan,
			LessThan,
			GreaterOrEquals,
			LessOrEquals,
			Addition,
			Subtraction,
			Multiplication,
			Division,
			Power,
			Assign,
			Learn,
			ArgumentList,
			Reset,
			Clear,
			Center,
			Go,
			GoX,
			GoY,
			Forward,
			Backward,
			Direction,
			TurnLeft,
			TurnRight,
			PenWidth,
			PenUp,
			PenDown,
			PenColor,
			CanvasColor,
			CanvasSize,
			SpriteShow,
			SpriteHide,
			Print,
			FontSize,
			Random,
			GetX,
			GetY,
			Message,
			Ask,
			Pi,
			Tan,
			Sin,
			Cos,
			ArcTan,
			ArcSin,
			ArcCos,
			Sqrt,
			Round,
			GetDirection,
			Mod

//END GENERATED token_type_h CODE

		};


		/**
		 * This is an enum for the different categories a Token can belong to.
		 * It is used by the highlighter to know how to highlight the code,
		 * and the mainwindow to determine the 'context help keyword'.
		 * The code for this enum is mostly generated.
		 */
		enum Category
		{
			UnknownCategory,

//BEGIN GENERATED token_category_h CODE

/* The code between the line that start with "//BEGIN GENERATED" and "//END GENERATED"
 * is generated by "generate.rb" according to the definitions specified in
 * "definitions.rb". Please make all changes in the "definitions.rb" file, since all
 * all change you make here will be overwritten the next time "generate.rb" is run.
 * Thanks for looking at the code!
 */

			CommandCategory,
			ControllerCommandCategory,
			NumberCategory,
			ParenthesisCategory,
			TrueFalseCategory,
			FunctionCallCategory,
			ExpressionCategory,
			ArgumentSeparatorCategory,
			MathOperatorCategory,
			CommentCategory,
			AssignmentCategory,
			BooleanOperatorCategory,
			ScopeCategory,
			VariableCategory,
			StringCategory,
			LearnCommandCategory

//END GENERATED token_category_h CODE

		};


		/**
		 * @short Constructor.
		 * Initialses a empty Token with Token::Type: Token::NotSet.
		 * This default constructor is needed for ErrorList (QValueList).
		 */
		Token();

		/**
		 * @short Constructor.
		 * Initialses a complete Token.
		 *
		 * @param type     type of the token, see also the @ref Type enum in this class
		 * @param look     the look of the Token as in the unicode string of the tokens
		 *                 appearance in the KTurtle code.
		 * @param startRow row position of the first character of this token in the code
		 * @param startCol column position of the first character of this token in the code
		 * @param endRow   row position of the last character of this token in the code
		 * @param endCol   column position of the last character of this token in the code
		 */
		Token(int type, const QString& look, int startRow, int startCol, int endRow, int endCol);

		virtual ~Token() {}


		const QString& look()
		               const { return _look; }
		int type()     const { return _type; }
		int category() const { return typeToCategory(_type); }
		int startRow() const { return _startRow; }
		int startCol() const { return _startCol; }
		int endRow()   const { return _endRow; }
		int endCol()   const { return _endCol; }

		void setType(int type)         { _type = type; }
		void setStartRow(int startRow) { _startRow = startRow; }
		void setStartCol(int startCol) { _startCol = startCol; }
		void setEndRow(int endRow)     { _endRow = endRow; }
		void setEndCol(int endCol)     { _endCol = endCol; }

		/// Compares 2 Tokens. Needed for ErrorList (QValueList) to compare ErrorMessages which contain Tokens.
		bool operator==(const Token&) const;

		/// Assigns a Token, it needs to compare ErrorMessages which contain Tokens.
		Token& operator=(const Token&);

		/// returns the category a type belongs to (generated)
		static int typeToCategory(int);


	private:
		int     _type;
		QString _look;
		int     _startRow, _startCol, _endRow, _endCol;
};


#endif  // _TOKEN_H_
