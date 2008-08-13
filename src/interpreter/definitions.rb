#  Copyright (C) 2005-2006 by Cies Breijs
#
#  This program is free software; you can redistribute it and/or
#  modify it under the terms of version 2 of the GNU General Public
#  License as published by the Free Software Foundation.
#
#  This program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public
#  License along with this program; if not, write to the Free
#  Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
#  Boston, MA 02110-1301, USA.


# In this file commands/instuctions/keywords/symbols/etc can easily be added to kturtle.
# Changes can also be made here, but be carefull cauz the existing code may rely on stuff in here.
# Thanks for looking at the code...


# The following variables can be used:
#
# @type,    the internal name of the item
# @look,    the en_US look for the item
# @ali,     the alias (another en_US look)
# @args,    the specification of the arguments (:none, :bool, :number, :string)
#           if omitted no code for argument handling wil be generated (so you gotta DIY)
#           	examples:
#           		@args = [:number, :number, :number]
#           		@args = [:none]
#           		@args = [:number, :string]
# @p_def,   method definition for the parser
# @e_def,   method definition for the executer
# @funct,   the functionality the item should be given
# @cat,     the category the item belongs to
# @help,    .docbook formatted text for in a help file


# In the @funct variable, one or more catagories of the item can be put.
# These are the catagories and their descriptions:
#
# statement           the item is a statement and thus will be parsed as such
# constant            the item is a constant so does not need any execution
# auto-emit           the emit statement will be autogenerated works for many commands
# node                the item can exist in the node tree and


new_item()
# This is used for Tokens that are contructed without being initialized
@type  = "NotSet"
@cat   = "Meta"
parse_item()

new_item()
@type  = "Unknown"
@cat   = "Meta"
@funct = "statement, node"
@p_def =
<<EOS
	// this is usually a function call
	return parseFunctionCall();
EOS
@e_def =
<<EOS
	if (node->parent()->token()->type() == Token::Learn) {
		currentNode = node->parent();
		executeCurrent = true;
		return;
	}
EOS
parse_item()

new_item()
# This is used when a no token can be created
@type  = "Error"
parse_item()

new_item()
@type  = "Root"
@cat   = "Meta"
@funct = "node"
parse_item()

new_item()
@type  = "Scope"
@cat   = "Scope"
@funct = "node"
@e_def =
<<EOS
	// catch loops, they need to be managed...
	int parentTokenType = node->parent()->token()->type();
	if (parentTokenType == Token::If     ||
	    parentTokenType == Token::Repeat ||
	    parentTokenType == Token::While  ||
//	    parentTokenType == Token::ForIn  ||
	    parentTokenType == Token::ForTo) {
		currentNode = node->parent();
		executeCurrent = true;
		return;
	}
	if(parentTokenType == Token::Learn) {
		//We have the end of a Learn, so we should return
		returning = true;
		returnValue = 0;
		return;
	}
	newScope = node;
EOS
parse_item()

new_item()
@type  = "WhiteSpace"
@cat   = "WhiteSpace"
parse_item()

new_item()
@type  = "EndOfLine"
@cat   = "Meta"
parse_item()

new_item()
@type  = "EndOfInput"
@cat   = "Meta"
parse_item()

new_item()
@type  = "VariablePrefix"
@cat   = "Variable"
@look  = "$"
@localize = false
parse_item()

new_item()
@type  = "Variable"
@cat   = "Variable"
@funct = "statement, node"
@p_def =
<<EOS
	// This is called the the variable is the first token on a line.
	// There has to be an assignment token right after it...
	TreeNode* variableNode = new TreeNode(currentToken);
	nextToken();
	Token* remeberedToken = new Token(*currentToken);
	skipToken(Token::Assign, *variableNode->token());
	TreeNode* assignNode = new TreeNode(remeberedToken);
	assignNode->appendChild(variableNode);      // the LHV; the symbol
	assignNode->appendChild(parseExpression()); // the RHV; the expression
	return assignNode;
EOS
@e_def =
<<EOS
	bool aValueIsNeeded = true;
	// no need to look up when assigning (in a for loop statement)
	if (node->parent()->token()->type() == Token::ForTo)
		return;
	// we need to executeVariables in assignments for things like $x=$y to work
	if (node->parent()->token()->type() == Token::Assign) {
		// Test if we are in the LHS of the assignment
		if  (node == node->parent()->child(0)) {
			// In this case we do not need to be initialized, we will get a value in executeAssign
			aValueIsNeeded = false;
		}
	}
	if (!functionStack.isEmpty() && 
	    functionStack.top().variableTable->contains(node->token()->look())) {
		qDebug() << "exists locally";
		node->setValue( (*functionStack.top().variableTable)[node->token()->look()] );
	} else if (globalVariableTable.contains(node->token()->look())) {
		qDebug() << "exists globally";
		node->setValue(globalVariableTable[node->token()->look()]);
	} else if (aValueIsNeeded)
	{
		addError(i18n("The variable '%1' was used without first being assigned to a value", node->token()->look()), *node->token(), 0);
	}
EOS
parse_item()

new_item()
@type  = "FunctionCall"
@cat   = "FunctionCall"
@funct = "statement, node"
@p_def =
<<EOS
	// this method gets usually called through parseUnknown...
	TreeNode* node = new TreeNode(currentToken);
	node->token()->setType(Token::FunctionCall);
	nextToken();
	appendArguments(node);
	return node;
EOS
@e_def =
<<EOS
	if (returning) {  // if the function is already executed and returns now
		returnValue = 0;
		returning = false;
		qDebug() << "==> functionReturned!";
		return;
	}

	if (!functionTable.contains(node->token()->look())) {
		addError(i18n("An unknown function named '%1' was called", node->token()->look()), *node->token(), 0);
		return;
	}
	
	CalledFunction c;
	c.function      = node;
	c.variableTable = new VariableTable();
	functionStack.push(c);
	qDebug() << "==> functionCalled!";
	
	TreeNode* learnNode = functionTable[node->token()->look()];

	// if the parameter numbers are not equal...
	if (node->childCount() != learnNode->child(1)->childCount()) {
		addError(
			i18n("The function '%1' was called with %2, while it should be called with %3",
				node->token()->look(),
				i18np("1 parameter", "%1 parameters", node->childCount()),
				i18np("1 parameter", "%1 parameters", learnNode->child(1)->childCount())
			),
			*node->token(), 0);
		return;
	}
		
	for (uint i = 0; i < node->childCount(); i++) {
		functionStack.top().variableTable->insert(learnNode->child(1)->child(i)->token()->look(), node->child(i)->value());
		qDebug() << "inserted variable " << learnNode->child(1)->child(i)->token()->look() << " on function stack";
	}
	newScope = learnNode->child(2);
EOS
parse_item()

new_item()
@type  = "String"
@cat   = "String"
@funct = "node, constant"
parse_item()

new_item()
@type  = "Number"
@cat   = "Number"
@funct = "node, constant"
parse_item()



new_item()
@type  = "True"
@cat   = "TrueFalse"
@look  = "true"
@funct = "node, constant"
parse_item()

new_item()
@type  = "False"
@cat   = "TrueFalse"
@look  = "false"
@funct = "node, constant"
parse_item()



new_item()
@type  = "Comment"
@cat   = "Comment"
@look  = "#"
@localize = false
parse_item()



new_item()
# shouldnt thisone also be treated as a normal token
# so the code for fetching the whole string has t be in here
@type  = "StringDelimiter"
@cat   = "String"
@look  = "\""
@localize = false
parse_item()



new_item()
@type  = "ScopeOpen"
@cat   = "Scope"
@look  = "{"
@localize = false
@funct = "statement"
@p_def =
<<EOS
	TreeNode* scopeNode = new TreeNode(new Token(Token::Scope, "{...}", currentToken->startRow(), currentToken->startCol(), 0, 0));
	delete currentToken;
	nextToken();
	// cannot change the currentScope to this scope cauz we still have to work in the currentScope
	// so we set the newScope, which the currentScope will become after parsing the current statement
	newScope = scopeNode;
	return scopeNode;
EOS
parse_item()

new_item()
@type  = "ScopeClose"
@cat   = "Scope"
@look  = "}"
@localize = false
@funct = "statement"
@p_def =
<<EOS
	TreeNode* node = new TreeNode(currentToken);
	int endRow = currentToken->endRow();
	int endCol = currentToken->endCol();
	nextToken();
	while (currentToken->type() == Token::EndOfLine) {  // allow newlines before else
		delete currentToken;
		nextToken();
	}
	if (currentScope->parent() && 
		currentScope->parent()->token()->type() == Token::If && 
		currentToken->type() == Token::Else) {
		currentScope->parent()->appendChild(parseElse());
	}
	if (currentScope != rootNode) {
		// find the parent scope of this scope, and make it current
		TreeNode* parentScope = currentScope;
		do {
			parentScope = parentScope->parent();
		} while (parentScope != rootNode && parentScope->token()->type() != Token::Scope);
		currentScope->token()->setEndRow(endRow);
		currentScope->token()->setEndCol(endCol);
		currentScope = parentScope;
	}
	return node;
EOS
parse_item()



new_item()
@type  = "ParenthesisOpen"
@cat   = "Parenthesis"
@look  = "("
@localize = false
parse_item()

new_item()
@type  = "ParenthesisClose"
@cat   = "Parenthesis"
@look  = ")"
@localize = false
parse_item()



new_item()
@type  = "ArgumentSeparator"
@cat   = "ArgumentSeparator"
@look  = ","
parse_item()



new_item()
@type  = "DecimalSeparator"
@cat   = "DecimalSeparator"
@look  = "."
parse_item()



new_item()
@type  = "Exit"
@cat   = "ControllerCommand"
@look  = "exit"
@funct = "statement, node"
@args  = [:none]
@e_def =
<<EOS
	node = node; // stop the warnings
	finished = true;
EOS
parse_item()

new_item()
@type  = "If"
@cat   = "ControllerCommand"
@look  = "if"
@funct = "statement, node"
@p_def =
<<EOS
	TreeNode* node = new TreeNode(currentToken);
	nextToken();
	node->appendChild(parseExpression());
	if (currentToken->type() == Token::ScopeOpen) {
		node->appendChild(parseScopeOpen());  // if followed by a scope
	} else {
		node->appendChild(parseStatement());  // if followed by single statement
		if (currentToken->type() == Token::Else)
			node->appendChild(parseElse()); // parse else
	}
	return node;
EOS
@e_def =
<<EOS
	QString id = QString("__%1_%2").arg(node->token()->look()).arg((long)node);
	if (currentVariableTable()->contains(id)) {
		currentVariableTable()->remove(id);
		return;
	}
	
	if (node->child(0)->value()->boolean()) {
		// store a empty Value just to know we executed once
		currentVariableTable()->insert(id, Value());
		newScope = node->child(1);
	} else {
		if (node->childCount() >= 3) {
			currentVariableTable()->insert(id, Value());
			newScope = node->child(2); // execute the else part
		}
	}
EOS
parse_item()

new_item()
@type  = "Else"
@cat   = "ControllerCommand"
@look  = "else"
@funct = "node"
@p_def =
<<EOS
	nextToken();
	if (currentToken->type() == Token::ScopeOpen) {
		return parseScopeOpen();  // if followed by a scope
	}
	return parseStatement();    // if followed by single statement
EOS
@e_def =
<<EOS
	execute(node->child(0));  // execute the scope, that's all...
EOS
parse_item()


p_def_repeat_while =
<<EOS
	TreeNode* node = new TreeNode(currentToken);
	nextToken();
	node->appendChild(parseExpression());
	if (currentToken->type() == Token::ScopeOpen) {
		node->appendChild(parseScopeOpen());  // if followed by a scope
	} else {
		node->appendChild(parseStatement());  // if followed by single statement
	}
	return node;
EOS

new_item()
@type  = "Repeat"
@cat   = "ControllerCommand"
@look  = "repeat"
@funct = "statement, node"
@p_def = p_def_repeat_while
@e_def =
<<EOS
	QString id = QString("__%1_%2").arg(node->token()->look()).arg((long)node);

	if(breaking) {
		breaking = false;
		currentVariableTable()->remove(id);
		return;
	}

	// the iteration state is stored on the variable table
	if (currentVariableTable()->contains(id)) {
		int currentCount = ROUND2INT((*currentVariableTable())[id].number());
		if (currentCount > 0) {
			(*currentVariableTable())[id].setNumber(currentCount - 1);
		} else {
			currentVariableTable()->remove(id);
			return;
		}
	} else {
		currentVariableTable()->insert(id, Value((double)(ROUND2INT(node->child(0)->value()->number()) - 1)));
	}
	newScope = node->child(1);
EOS
parse_item()

new_item()
@type  = "While"
@cat   = "ControllerCommand"
@look  = "while"
@funct = "statement, node"
@p_def = p_def_repeat_while
@e_def =
<<EOS
	// first time this gets called the expression is already executed
	// after one iteration the expression is not automatically re-executed.
	// so we do the following on every call to executeWhile:
	//     exec scope, exec expression, exec scope, exec expression, ...

	QString id = QString("__%1_%2").arg(node->token()->look()).arg((long)node);

	if (breaking) {
		// We hit a break command while executing the scope
		breaking = false; // Not breaking anymore
		currentVariableTable()->remove(id); // remove the value (cleanup)
		return; // Move to the next sibbling
	}

	if (currentVariableTable()->contains(id)) {
		newScope = node; // re-execute the expression
		currentVariableTable()->remove(id);
		return;
	}
	currentVariableTable()->insert(id, Value()); // store a empty Value just to know we executed once

	if (node->child(0)->value()->boolean())
		newScope = node->child(1); // (re-)execute the scope
	else
		currentVariableTable()->remove(id); // clean-up, keep currenNode on currentNode so the next sibling we be run next
EOS
parse_item()

new_item()
@type  = "For"
@cat   = "ControllerCommand"
@look  = "for"
@funct = "statement, node"
@p_def =
<<EOS
	TreeNode* node = new TreeNode(currentToken);
	nextToken();
	Token* firstToken = currentToken;
	nextToken();
	if (firstToken->type() == Token::Variable && currentToken->type() == Token::Assign) {
		node->token()->setType(Token::ForTo);
		node->appendChild(new TreeNode(firstToken));
		nextToken();
		node->appendChild(parseExpression());
		skipToken(Token::To, *node->token());
		node->appendChild(parseExpression());
		if (currentToken->type() == Token::Step) {
			nextToken();
			node->appendChild(parseExpression());
		} else {
			TreeNode* step = new TreeNode(new Token(Token::Number, "1", 0,0,0,0));
			step->setValue(Value(1.0));
			node->appendChild(step);
		}
//	} else if (currentToken->type() == Token::In) {
//		// @TODO something for a for-in loop
	} else {
		addError(i18n("'for' was called wrongly"), *node->token(), 0);
		finished = true;  // abort after this error
		return node;
	}

	if (currentToken->type() == Token::ScopeOpen) {
		node->appendChild(parseScopeOpen());  // if followed by a scope
	} else {
		node->appendChild(parseStatement());  // if followed by single statement
	}

	return node;
EOS
@e_def =
<<EOS
	qCritical("Executer::executeFor(): should have been translated to Token::ForTo by the parser");
	node = node; // stop the warnings
EOS
parse_item()

new_item()
@type  = "ForTo"
@cat   = "ControllerCommand"
@funct = "node"
@e_def =
<<EOS
	// first time this gets called the expressions are already executed
	// after one iteration the expression is not re-executed.
	// so we do: exec scope, exec expressions, exec scope, exec expressions, ...

	bool firstIteration = false;
	if (functionStack.isEmpty() || functionStack.top().function != node) {
		// if this for loop is called for the first time...
		CalledFunction c;
		c.function      = node;
		c.variableTable = new VariableTable();
		functionStack.push(c);

		currentVariableTable()->insert(node->child(0)->token()->look(), Value(node->child(1)->value()->number()));
		firstIteration = true;
	}

	if(breaking) {
		breaking = false;
		delete functionStack.top().variableTable;
		functionStack.pop();
		return;
	}

	QString id = QString("__%1_%2").arg(node->token()->look()).arg((long)node);

	if (currentVariableTable()->contains(id)) {
		newScope = node; // re-execute the expressions
		currentVariableTable()->remove(id);
		return;
	}
	currentVariableTable()->insert(id, Value()); // store a empty Value just to know we executed once

	double currentCount   = (*currentVariableTable())[node->child(0)->token()->look()].number();
	double startCondition = node->child(1)->value()->number();
	double endCondition   = node->child(2)->value()->number();
	double step           = node->child(3)->value()->number();

	if (
 	(startCondition < endCondition && currentCount + step <= endCondition) ||
	    (startCondition > endCondition && currentCount - step >= endCondition && step<0) //negative loop sanity check, is it implemented?
		|| (startCondition==endCondition && firstIteration) // for expressions like for $n=1 to 1
	   ) {
	if (!firstIteration)
			(*currentVariableTable())[node->child(0)->token()->look()].setNumber(currentCount + step);
		newScope = node->child(4); // (re-)execute the scope
	} else {
		// cleaning up after last iteration...
		delete functionStack.top().variableTable;
		functionStack.pop();
	}
EOS
parse_item()

new_item()
@type  = "To"
@cat   = "ControllerCommand"
@look  = "to"
parse_item()

# # new_item()
# # @type  = "ForIn"
# # @funct = "node"
# # parse_item()
# #
# # new_item()
# # @type  = "In"
# # @look  = "in"
# # parse_item()

new_item()
@type  = "Step"
@cat   = "ControllerCommand"
@look  = "step"
parse_item()

new_item()
@type  = "Break"
@cat   = "ControllerCommand"
@look  = "break"
@funct = "statement, node"
@args  = [:none]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 0, 20000+Token::Break*100+90)) return;

	breaking = true;

	// Check for the first parent which is a repeat, while of for loop.
	// If found, switch the newScope to them so they can break.
	QList<int> tokenTypes;
	tokenTypes.append(Token::Repeat);
	tokenTypes.append(Token::While);
	tokenTypes.append(Token::ForTo);

	TreeNode* ns = getParentOfTokenTypes(node, &tokenTypes);

	if(ns!=0)
		newScope = ns;
	// If ns is 0 then very weird things are happening since we then couldn't find the correct parent
	// therefor it might be best to just let the executer continue.
EOS
parse_item()

new_item()
@type  = "Return"
@cat   = "ControllerCommand"
@look  = "return"
@funct = "statement, node"
@p_def =
<<EOS
	TreeNode* node = new TreeNode(currentToken);
	nextToken();
	appendArguments(node);
	skipToken(Token::EndOfLine, *node->token());
	return node;
EOS
@e_def =
<<EOS
	if(node->childCount()>0)
		returnValue = node->child(0)->value();
	else
		returnValue = 0;
	returning   = true;
EOS
parse_item()

new_item()
@type  = "Wait"
@cat   = "ControllerCommand"
@look  = "wait"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Wait*100+90)) return;
	if (!checkParameterType(node, Value::Number, 20000+Token::Wait*100+91) ) return;
	waiting = true;
	QTimer::singleShot((int)(1000*node->child(0)->value()->number()), this, SLOT(stopWaiting()));
EOS
parse_item()



new_item()
@type  = "And"
@cat   = "BooleanOperator"
@look  = "and"
@funct = "node"
@e_def =
<<EOS
	//Niels: See 'Not'
	if(node->childCount()!=2) {
		addError(i18n("'And' needs two variables"), *node->token(), 0);
		return;
	}
	node->value()->setBool(node->child(0)->value()->boolean() && node->child(1)->value()->boolean());
EOS
parse_item()

new_item()
@type  = "Or"
@cat   = "BooleanOperator"
@look  = "or"
@funct = "node"
@e_def =
<<EOS
	//Niels: See 'Not'
	if(node->childCount()!=2) {
		addError(i18n("'Or' needs two variables"), *node->token(), 0);
		return;
	}
	node->value()->setBool(node->child(0)->value()->boolean() || node->child(1)->value()->boolean());
EOS
parse_item()

new_item()
@type  = "Not"
@cat   = "BooleanOperator"
@look  = "not"
@funct = "node"
@e_def =
<<EOS
	// OLD-TODO: maybe add some error handling here...
	//Niels: Ok, now we check if the node has children. Should we also check whether the child value is a boolean?
	if(node->childCount()!=1) {
		addError(i18n("I need something to do a not on"), *node->token(), 0);
		return;
	}
	node->value()->setBool(!node->child(0)->value()->boolean());
EOS
parse_item()



def e_def_expression_creator(look)
	# since the looks for expressions are the same in TurtleScript and C++ we can take this shortcut...
	# all the logic doing the expressioning is in the Value class
	return "\tif(node->childCount()!=2) { \n\t\taddError(i18n(\"I cannot do a '#{look}' without 2 variables\"), *node->token(), 0);\n\t\treturn;\n\t}\n\tnode->value()->setBool(*node->child(0)->value() #{look} node->child(1)->value());\n"
end

new_item()
@type  = "Equals"
@cat   = "Expression"
@look  = "=="
@localize = false
@funct = "node"
@e_def = e_def_expression_creator(@look)
parse_item()

new_item()
@type  = "NotEquals"
@cat   = "Expression"
@look  = "!="
@localize = false
@funct = "node"
@e_def = e_def_expression_creator(@look)
parse_item()

new_item()
@type  = "GreaterThan"
@cat   = "Expression"
@look  = ">"
@localize = false
@funct = "node"
@e_def = e_def_expression_creator(@look)
parse_item()

new_item()
@type  = "LessThan"
@cat   = "Expression"
@look  = "<"
@localize = false
@funct = "node"
@e_def = e_def_expression_creator(@look)
parse_item()

new_item()
@type  = "GreaterOrEquals"
@cat   = "Expression"
@look  = ">="
@localize = false
@funct = "node"
@e_def = e_def_expression_creator(@look)
parse_item()

new_item()
@type  = "LessOrEquals"
@cat   = "Expression"
@look  = "<="
@localize = false
@funct = "node"
@e_def = e_def_expression_creator(@look)
parse_item()



new_item()
@type  = "Addition"
@cat   = "MathOperator"
@look  = "+"
@localize = false
@funct = "node"
@e_def =
<<EOS
	if(node->childCount()!=2) {
		addError(i18n("You need two numbers or string to do an addition"), *node->token(), 0);
		return;
	}
	if (node->child(0)->value()->type() == Value::Number && node->child(1)->value()->type() == Value::Number) {
		node->value()->setNumber(node->child(0)->value()->number() + node->child(1)->value()->number());
	} else {
		node->value()->setString(node->child(0)->value()->string().append(node->child(1)->value()->string()));
	}
EOS
parse_item()

new_item()
@type  = "Substracton"
@cat   = "MathOperator"
@look  = "-"
@localize = false
@funct = "node"
@e_def =
<<EOS
	if(node->childCount()!=2) {
		addError(i18n("You need two numbers to subtract"), *node->token(), 0);
		return;
	}
	if (node->child(0)->value()->type() == Value::Number && node->child(1)->value()->type() == Value::Number) {
		node->value()->setNumber(node->child(0)->value()->number() - node->child(1)->value()->number());
	} else {
		if (node->child(0)->value()->type() != Value::Number)
			addError(i18n("You tried to subtract from a non-number, '%1'", node->child(0)->token()->look()), *node->token(), 0);
		if (node->child(1)->value()->type() != Value::Number)
			addError(i18n("You tried to subtract a non-number, '%1'", node->child(1)->token()->look()), *node->token(), 0);
	}
EOS
parse_item()

new_item()
@type  = "Multiplication"
@cat   = "MathOperator"
@look  = "*"
@localize = false
@funct = "node"
@e_def =
<<EOS
	if(node->childCount()!=2) {
		addError(i18n("You need two numbers to multiplicate"), *node->token(), 0);
		return;
	}
	if (node->child(0)->value()->type() == Value::Number && node->child(1)->value()->type() == Value::Number) {
		node->value()->setNumber(node->child(0)->value()->number() * node->child(1)->value()->number());
	} else {
		if (node->child(0)->value()->type() != Value::Number)
			addError(i18n("You tried to multiplicate a non-number, '%1'", node->child(0)->token()->look()), *node->token(), 0);
		if (node->child(1)->value()->type() != Value::Number)
			addError(i18n("You tried to multiplicate by a non-number, '%1'", node->child(1)->token()->look()), *node->token(), 0);
	}
EOS
parse_item()

new_item()
@type  = "Division"
@cat   = "MathOperator"
@look  = "/"
@localize = false
@funct = "node"
@e_def =
<<EOS
	if(node->childCount()!=2) {
		addError(i18n("You need two numbers to divide"), *node->token(), 0);
		return;
	}
	if (node->child(0)->value()->type() == Value::Number && node->child(1)->value()->type() == Value::Number) {
		node->value()->setNumber(node->child(0)->value()->number() / node->child(1)->value()->number());
	} else {
		if (node->child(0)->value()->type() != Value::Number)
			addError(i18n("You tried to divide a non-number, '%1'", node->child(0)->token()->look()), *node->token(), 0);
		if (node->child(1)->value()->type() != Value::Number)
			addError(i18n("You tried to divide by a non-number, '%1'", node->child(1)->token()->look()), *node->token(), 0);
	}
EOS
parse_item()

new_item()
@type  = "Power"
@cat   = "MathOperator"
@look  = "^" # or **
@localize = false
@funct = "node"
@e_def =
<<EOS
	if(node->childCount()!=2) {
		addError(i18n("You need two numbers to raise a power"), *node->token(), 0);
		return;
	}
	if (node->child(0)->value()->type() == Value::Number && node->child(1)->value()->type() == Value::Number) {
		node->value()->setNumber(pow(node->child(0)->value()->number(), node->child(1)->value()->number()));
	} else {
		if (node->child(0)->value()->type() != Value::Number)
			addError(i18n("You tried to raise a non-number to a power, '%1'", node->child(0)->token()->look()), *node->token(), 0);
		if (node->child(1)->value()->type() != Value::Number)
			addError(i18n("You tried to raise the power of a non-number, '%1'", node->child(1)->token()->look()), *node->token(), 0);
	}
EOS
parse_item()



new_item()
@type  = "Assign"
@cat   = "Assignment"
@look  = "="
@localize = false
@funct = "node"
@e_def =
<<EOS
	if(node->childCount()!=2) {
	addError(i18n("You need one variable and a value or variable to do a '='"), *node->token(), 0);
		return;
	}
	if (!functionStack.isEmpty() && !globalVariableTable.contains(node->child(0)->token()->look())) // &&functionStack.top().variableTable->contains(node->token()->look())) 
	{
		qDebug() << "function scope";
		functionStack.top().variableTable->insert(node->child(0)->token()->look(), node->child(1)->value());
	} else {
		// inserts unless already exists then replaces
		globalVariableTable.insert(node->child(0)->token()->look(), node->child(1)->value());
	}
	qDebug() << "variableTable updated!";
	emit variableTableUpdated(node->child(0)->token()->look(), node->child(1)->value());
EOS
parse_item()



new_item()
@type  = "Learn"
@cat   = "LearnCommand"
@look  = "learn"
@funct = "statement, node"
@p_def =
<<EOS
	TreeNode* node = new TreeNode(currentToken);
	nextToken();
	node->appendChild(new TreeNode(new Token(*currentToken)));
	skipToken(Token::Unknown, *node->token());
	
	TreeNode* argumentList = new TreeNode(new Token(Token::ArgumentList, "arguments", 0, 0, 0, 0));
	while (currentToken->type() == Token::Variable) {
		// cannot just call appendArguments here because we're only appending Token::Variable tokens
		argumentList->appendChild(new TreeNode(currentToken));
		nextToken();
		if (currentToken->type() != Token::ArgumentSeparator) break;
		nextToken();
	}
	node->appendChild(argumentList);
	
	//Skip all the following EndOfLine's
	while (currentToken->type() == Token::EndOfLine) {
		delete currentToken;
		nextToken();
	}

	if (currentToken->type() == Token::ScopeOpen) {
		node->appendChild(parseScopeOpen());  // if followed by a scope
	} else {
		addError(i18n("Expected a scope after the 'learn' command"), *node->token(), 0);
	}
	return node;
EOS
@e_def =
<<EOS
	if(functionTable.contains(node->child(0)->token()->look())) {
		addError(i18n("The function '%1' is already defined!", node->child(0)->token()->look()), *node->token(), 0);
		return;
	}
	functionTable.insert(node->child(0)->token()->look(), node);
	qDebug() << "functionTable updated!";
	QStringList parameters;
	for (uint i = 0; i < node->child(1)->childCount(); i++)
		parameters << node->child(1)->child(i)->token()->look();
	emit functionTableUpdated(node->child(0)->token()->look(), parameters);
EOS
parse_item()

new_item()
@type  = "ArgumentList"
@cat   = "Meta"
@funct = "node"
parse_item()



new_item()
@type  = "Reset"
@cat   = "Command"
@look  = "reset"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "Clear"
@cat   = "Command"
@look  = "clear"
@ali   = "ccl"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "Center"
@cat   = "Command"
@look  = "center"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "Go"
@cat   = "Command"
@look  = "go"
@funct = "statement, node, auto-emit"
@args  = [:number, :number]
parse_item()

new_item()
@type  = "GoX"
@cat   = "Command"
@look  = "gox"
@ali   = "gx"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "GoY"
@cat   = "Command"
@look  = "goy"
@ali   = "gy"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "Forward"
@cat   = "Command"
@look  = "forward"
@ali   = "fw"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "Backward"
@cat   = "Command"
@look  = "backward"
@ali   = "bw"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "Direction"
@cat   = "Command"
@look  = "direction"
@ali   = "dir"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "TurnLeft"
@cat   = "Command"
@look  = "turnleft"
@ali   = "tl"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "TurnRight"
@cat   = "Command"
@look  = "turnright"
@ali   = "tr"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "PenWidth"
@cat   = "Command"
@look  = "penwidth"
@ali   = "pw"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

new_item()
@type  = "PenUp"
@cat   = "Command"
@look  = "penup"
@ali   = "pu"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "PenDown"
@cat   = "Command"
@look  = "pendown"
@ali   = "pd"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "PenColor"
@cat   = "Command"
@look  = "pencolor"
@ali   = "pc"
@funct = "statement, node, auto-emit"
@args  = [:number, :number, :number]
parse_item()

new_item()
@type  = "CanvasColor"
@cat   = "Command"
@look  = "canvascolor"
@ali   = "cc"
@funct = "statement, node, auto-emit"
@args  = [:number, :number, :number]
parse_item()

new_item()
@type  = "CanvasSize"
@cat   = "Command"
@look  = "canvassize"
@ali   = "cs"
@funct = "statement, node, auto-emit"
@args  = [:number, :number]
parse_item()

new_item()
@type  = "SpriteShow"
@cat   = "Command"
@look  = "spriteshow"
@ali   = "ss"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "SpriteHide"
@cat   = "Command"
@look  = "spritehide"
@ali   = "sh"
@funct = "statement, node, auto-emit"
@args  = [:none]
parse_item()

new_item()
@type  = "Print"
@cat   = "Command"
@look  = "print"
@funct = "statement, node, auto-emit"
@args  = [:string]
@e_def = # define ourself because print handles any argument type
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Print*100+90))
		return;
	qDebug() << "Printing: '" << node->child(0)->value()->string() << "'";
EOS
parse_item()

new_item()
@type  = "FontSize"
@cat   = "Command"
@look  = "fontsize"
@funct = "statement, node, auto-emit"
@args  = [:number]
parse_item()

# # new_item()
# # @type  = "WrapOn"
# # @cat   = "Command"
# # @look  = "wrapon"
# # @funct = "statement, node, auto-emit"
# # @args  = [:none]
# # parse_item()
# # 
# # new_item()
# # @type  = "WrapOff"
# # @cat   = "Command"
# # @look  = "wrapoff"
# # @funct = "statement, node, auto-emit"
# # @args  = [:none]
# # parse_item()


new_item()
@type  = "Random"
@cat   = "Command"
@look  = "random"
@ali   = "rnd"
@funct = "statement, node"
@args  = [:number, :number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 2, 20000+Token::Random*100+90)) return;
	TreeNode* nodeX = node->child(0);  // getting
	TreeNode* nodeY = node->child(1);
	execute(nodeX);  // executing
	execute(nodeY);
	
	if (!checkParameterType(node, Value::Number, 20000+Token::Random*100+91)) return;
	double x = nodeX->value()->number();
	double y = nodeY->value()->number();
	double r = (double)(KRandom::random()) / RAND_MAX;
	node->value()->setNumber(r * (y - x) + x);
EOS
parse_item()

new_item()
@type      = "GetX"
@cat       = "Command"
@look      = "getx"
@funct     = "statement, node"
@args      = [:none]
@e_def      =
<<EOS
	if (!checkParameterQuantity(node, 0, 20000+Token::GetX*100+90)) return;
	double value = 0;
	emit getX(value);
	node->value()->setNumber(value);
EOS
parse_item()

new_item()
@type      = "GetY"
@cat       = "Command"
@look      = "gety"
@funct     = "statement, node"
@args      = [:none]
@e_def      =
<<EOS
	if (!checkParameterQuantity(node, 0, 20000+Token::GetY*100+90)) return;
	double value = 0;
	emit getY(value);
	node->value()->setNumber(value);
EOS
parse_item()

# # new_item()
# # @type  = "Run"
# # @cat   = "Command"
# # @look  = "run"
# # @funct = "statement, node"
# # @args  = [:string]
# # parse_item()
# # 
new_item()
@type  = "Message"
@cat   = "Command"
@look  = "message"
@funct = "statement, node"
@args  = [:string]
@e_def      =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Message*100+90)) return;
	emit message(node->child(0)->value()->string());
EOS
parse_item()

new_item()
@type  = "Ask" # used to be "inputwindow"
@cat   = "Command"
@look  = "ask"
@funct = "statement, node"
@args  = [:string]
@e_def      =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Ask*100+90)) return;
	QString value = node->child(0)->value()->string();
	emit ask(value);
	
	bool convertOk;
	double d = value.toDouble(&convertOk);
	if(convertOk)
		node->value()->setNumber(d);
	else
		node->value()->setString(value);
EOS
parse_item()

new_item()
@type  = "Pi"
@cat   = "Command"
@look  = "pi"
@funct = "statement, node"
@args  = [:none]
@e_def =
<<EOS
	node->value()->setNumber(M_PI);
EOS
parse_item()

new_item()
@type  = "Tan"
@cat   = "Command"
@look  = "tan"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Tan*100+90)) return;
	
	double deg = node->child(0)->value()->number();
	node->value()->setNumber(tan(DEG2RAD(deg)));
EOS
parse_item()

new_item()
@type  = "Sin"
@cat   = "Command"
@look  = "sin"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Sin*100+90)) return;
	
	double deg = node->child(0)->value()->number();
	node->value()->setNumber(sin(DEG2RAD(deg)));
EOS
parse_item()

new_item()
@type  = "Cos"
@cat   = "Command"
@look  = "cos"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Cos*100+90)) return;
	
	double deg = node->child(0)->value()->number();
	node->value()->setNumber(cos(DEG2RAD(deg)));
EOS
parse_item()

new_item()
@type  = "ArcTan"
@cat   = "Command"
@look  = "arctan"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::ArcTan*100+90)) return;
	
	double deg = node->child(0)->value()->number();
	node->value()->setNumber(RAD2DEG(atan(deg)));
EOS
parse_item()

new_item()
@type  = "ArcSin"
@cat   = "Command"
@look  = "arcsin"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::ArcSin*100+90)) return;
	
	double deg = node->child(0)->value()->number();
	node->value()->setNumber(RAD2DEG(asin(deg)));
EOS
parse_item()

new_item()
@type  = "ArcCos"
@cat   = "Command"
@look  = "arccos"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::ArcCos*100+90)) return;
	
	double deg = node->child(0)->value()->number();
	node->value()->setNumber(RAD2DEG(acos(deg)));
EOS
parse_item()

new_item()
@type  = "Sqrt"
@cat   = "Command"
@look  = "sqrt"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Sqrt*100+90)) return;
	
	double val = node->child(0)->value()->number();
	node->value()->setNumber(sqrt(val));
EOS
parse_item()

new_item()
@type  = "Exp"
@cat   = "Command"
@look  = "exp"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
	if (!checkParameterQuantity(node, 1, 20000+Token::Exp*100+90)) return;
	
	double val = node->child(0)->value()->number();
	node->value()->setNumber(exp(val));
EOS
parse_item()

new_item()
@type  = "Round"
@cat   = "Command"
@look  = "round"
@funct = "statement, node"
@args  = [:number]
@e_def =
<<EOS
    if (!checkParameterQuantity(node, 1, 20000+Token::Round*100+90)) return;
   
    double val = node->child(0)->value()->number();
    node->value()->setNumber((double)ROUND2INT(val));
EOS
parse_item()

