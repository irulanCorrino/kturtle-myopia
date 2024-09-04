/*
 * This file was generated by dbusxml2cpp version 0.6
 * Command line was: dbusxml2cpp -m -a interpreteradaptor -i interpreter/interpreter.h -l Interpreter
 * /home/cies/kturtle/working-kdeedu/kturtle/src/interpreter/org.kde.kturtle.Interpreter.xml
 *
 * dbusxml2cpp is SPDX-FileCopyrightText: 2008 Nokia Corporation and /or its subsidiary(-ies).
 *
 * This is an auto-generated file.
 * Do not edit! All changes made to it will be lost.
 */

#include "interpreteradaptor.h"
#include <QString>
#include <QStringList>

/*
 * Implementation of adaptor class InterpreterAdaptor
 */

InterpreterAdaptor::InterpreterAdaptor(Interpreter *parent)
    : QDBusAbstractAdaptor(parent)
{
    // constructor
    setAutoRelaySignals(true);
}

InterpreterAdaptor::~InterpreterAdaptor()
{
    // destructor
}

bool InterpreterAdaptor::encounteredErrors()
{
    // handle method call org.kde.kturtle.Interpreter.encounteredErrors
    return parent()->encounteredErrors();
}

QStringList InterpreterAdaptor::getErrorStrings()
{
    // handle method call org.kde.kturtle.Interpreter.getErrorStrings
    return parent()->getErrorStrings();
}

void InterpreterAdaptor::initialize(const QString &inputString)
{
    // handle method call org.kde.kturtle.Interpreter.initialize
    parent()->initialize(inputString);
}

void InterpreterAdaptor::interpret()
{
    // handle method call org.kde.kturtle.Interpreter.interpret
    parent()->interpret();
}

int InterpreterAdaptor::state()
{
    // handle method call org.kde.kturtle.Interpreter.state
    return parent()->state();
}

#include "interpreteradaptor.moc"

#include "moc_interpreteradaptor.cpp"
