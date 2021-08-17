/*
    SPDX-FileCopyrightText: 2003-2006 Cies Breijs <cies AT kde DOT nl>

    SPDX-License-Identifier: GPL-2.0-or-later
*/


#ifndef _ECHOER_H_
#define _ECHOER_H_


#include "executer.h"

#include <QDebug>


/**
 * @short Echoes signals to a QTextStream
 *
 * Just echos the signals it gets.
 * Useful for creating UnitTests.
 *
 * @author Cies Breijs
 */
class Echoer : public QObject
{
	Q_OBJECT

	public:
		/**
		 * Default Constructor
		 */
		explicit Echoer(QObject* parent = 0) { setParent(parent); }

		/**
		 * Default Destructor
		 */
		virtual ~Echoer() {}

		/**
		 * Connects all its slots to the signals of the Executer
		 */
		void connectAllSlots(Executer* executer) {
			// these connect calls connect all the Executers signals to this class' slots

//BEGIN GENERATED echoer_connect_h CODE

/* The code between the line that start with "//BEGIN GENERATED" and "//END GENERATED"
 * is generated by "generate.rb" according to the definitions specified in
 * "definitions.rb". Please make all changes in the "definitions.rb" file, since all
 * all change you make here will be overwritten the next time "generate.rb" is run.
 * Thanks for looking at the code!
 */

			connect(executer, &Executer::reset,
				this, &Echoer::reset);
			connect(executer, &Executer::clear,
				this, &Echoer::clear);
			connect(executer, &Executer::center,
				this, &Echoer::center);
			connect(executer, &Executer::go,
				this, &Echoer::go);
			connect(executer, &Executer::goX,
				this, &Echoer::goX);
			connect(executer, &Executer::goY,
				this, &Echoer::goY);
			connect(executer, &Executer::forward,
				this, &Echoer::forward);
			connect(executer, &Executer::backward,
				this, &Echoer::backward);
			connect(executer, &Executer::direction,
				this, &Echoer::direction);
			connect(executer, &Executer::turnLeft,
				this, &Echoer::turnLeft);
			connect(executer, &Executer::turnRight,
				this, &Echoer::turnRight);
			connect(executer, &Executer::penWidth,
				this, &Echoer::penWidth);
			connect(executer, &Executer::penUp,
				this, &Echoer::penUp);
			connect(executer, &Executer::penDown,
				this, &Echoer::penDown);
			connect(executer, &Executer::penColor,
				this, &Echoer::penColor);
			connect(executer, &Executer::canvasColor,
				this, &Echoer::canvasColor);
			connect(executer, &Executer::canvasSize,
				this, &Echoer::canvasSize);
			connect(executer, &Executer::spriteShow,
				this, &Echoer::spriteShow);
			connect(executer, &Executer::spriteHide,
				this, &Echoer::spriteHide);
			connect(executer, &Executer::print,
				this, &Echoer::print);
			connect(executer, &Executer::fontSize,
				this, &Echoer::fontSize);

//END GENERATED echoer_connect_h CODE
		}


	public Q_SLOTS:
		// the generated code is a set of slots that are covering all the Executers signals...

//BEGIN GENERATED echoer_slots_h CODE

/* The code between the line that start with "//BEGIN GENERATED" and "//END GENERATED"
 * is generated by "generate.rb" according to the definitions specified in
 * "definitions.rb". Please make all changes in the "definitions.rb" file, since all
 * all change you make here will be overwritten the next time "generate.rb" is run.
 * Thanks for looking at the code!
 */

		void reset() { qDebug() << "SIG> " << "reset" << "(" << ")"; }
		void clear() { qDebug() << "SIG> " << "clear" << "(" << ")"; }
		void center() { qDebug() << "SIG> " << "center" << "(" << ")"; }
		void go(double arg0, double arg1) { qDebug() << "SIG> " << "go" << "(" << arg0 << "," << arg1 << ")"; }
		void goX(double arg0) { qDebug() << "SIG> " << "goX" << "(" << arg0 << ")"; }
		void goY(double arg0) { qDebug() << "SIG> " << "goY" << "(" << arg0 << ")"; }
		void forward(double arg0) { qDebug() << "SIG> " << "forward" << "(" << arg0 << ")"; }
		void backward(double arg0) { qDebug() << "SIG> " << "backward" << "(" << arg0 << ")"; }
		void direction(double arg0) { qDebug() << "SIG> " << "direction" << "(" << arg0 << ")"; }
		void turnLeft(double arg0) { qDebug() << "SIG> " << "turnLeft" << "(" << arg0 << ")"; }
		void turnRight(double arg0) { qDebug() << "SIG> " << "turnRight" << "(" << arg0 << ")"; }
		void penWidth(double arg0) { qDebug() << "SIG> " << "penWidth" << "(" << arg0 << ")"; }
		void penUp() { qDebug() << "SIG> " << "penUp" << "(" << ")"; }
		void penDown() { qDebug() << "SIG> " << "penDown" << "(" << ")"; }
		void penColor(double arg0, double arg1, double arg2) { qDebug() << "SIG> " << "penColor" << "(" << arg0 << "," << arg1 << "," << arg2 << ")"; }
		void canvasColor(double arg0, double arg1, double arg2) { qDebug() << "SIG> " << "canvasColor" << "(" << arg0 << "," << arg1 << "," << arg2 << ")"; }
		void canvasSize(double arg0, double arg1) { qDebug() << "SIG> " << "canvasSize" << "(" << arg0 << "," << arg1 << ")"; }
		void spriteShow() { qDebug() << "SIG> " << "spriteShow" << "(" << ")"; }
		void spriteHide() { qDebug() << "SIG> " << "spriteHide" << "(" << ")"; }
		void print(const QString& arg0) { qDebug() << "SIG> " << "print" << "(" << qPrintable(arg0) << ")"; }
		void fontSize(double arg0) { qDebug() << "SIG> " << "fontSize" << "(" << arg0 << ")"; }

//END GENERATED echoer_slots_h CODE

};

#endif  // _ECHOER_H_


