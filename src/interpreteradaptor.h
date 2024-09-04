/*
 * This file was generated by dbusxml2cpp version 0.6
 * Command line was: dbusxml2cpp -m -a interpreteradaptor -i interpreter/interpreter.h -l Interpreter
 * /home/cies/kturtle/working-kdeedu/kturtle/src/interpreter/org.kde.kturtle.Interpreter.xml
 *
 * dbusxml2cpp is SPDX-FileCopyrightText: 2008 Nokia Corporation and /or its subsidiary(-ies).
 *
 * This is an auto-generated file.
 * This file may have been hand-edited. Look for HAND-EDIT comments
 * before re-generating it.
 */

#ifndef INTERPRETERADAPTOR_H_1243976287
#define INTERPRETERADAPTOR_H_1243976287

#include "interpreter/interpreter.h"
#include <QObject>
template<class T>
class QList;
template<class Key, class Value>
class QMap;
class QString;
class QStringList;

/*
 * Adaptor class for interface org.kde.kturtle.Interpreter
 */
class InterpreterAdaptor : public QDBusAbstractAdaptor
{
    Q_OBJECT
    Q_CLASSINFO("D-Bus Interface", "org.kde.kturtle.Interpreter")
    Q_CLASSINFO("D-Bus Introspection",
                ""
                "  <interface name=\"org.kde.kturtle.Interpreter\" >\n"
                "    <signal name=\"parsing\" />\n"
                "    <signal name=\"executing\" />\n"
                "    <signal name=\"finished\" />\n"
                "    <method name=\"interpret\" />\n"
                "    <method name=\"state\" >\n"
                "      <arg direction=\"out\" type=\"i\" />\n"
                "    </method>\n"
                "    <method name=\"initialize\" >\n"
                "      <arg direction=\"in\" type=\"s\" name=\"inputString\" />\n"
                "    </method>\n"
                "    <method name=\"encounteredErrors\" >\n"
                "      <arg direction=\"out\" type=\"b\" />\n"
                "    </method>\n"
                "    <method name=\"getErrorStrings\" >\n"
                "      <arg direction=\"out\" type=\"as\" />\n"
                "    </method>\n"
                "  </interface>\n"
                "")
public:
    InterpreterAdaptor(Interpreter *parent);
    virtual ~InterpreterAdaptor();

    inline Interpreter *parent() const
    {
        return static_cast<Interpreter *>(QObject::parent());
    }

public: // PROPERTIES
public Q_SLOTS: // METHODS
    bool encounteredErrors();
    QStringList getErrorStrings();
    void initialize(const QString &inputString);
    void interpret();
    int state();
Q_SIGNALS: // SIGNALS
    void executing();
    void finished();
    void parsing();
};

#endif
