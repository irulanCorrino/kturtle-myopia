/*
    Copyright (C) 2003 by Walter Schreppers 
    Copyright (C) 2004 by Cies Breijs
 
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
 

#ifndef _VALUE_H_
#define _VALUE_H_

#include <qstring.h>
#include <qtextstream.h>


enum valueType
{
	boolType,
	numberType,
	stringType
};

class Value
{
	public:
	Value();
	Value(const Value&);
	~Value() {}


	int Type() const;
	void setType(int);

	void setBool(bool);
	bool Bool() const;

	double Number() const;
	void setNumber(double);
	bool setNumber(QString);

	QString String() const;
	void setString(double);
	void setString(QString);

	Value& operator=(const Value&);
	Value& operator=(const QString&);
	Value& operator=(double);

	Value& operator+(const Value&);
	Value& operator-(const Value&);
	Value& operator*(const Value&);
	Value& operator/(const Value&);

	bool operator==(const Value&) const;
	bool operator!=(const Value&) const;
	bool operator< (const Value&) const;
	bool operator<=(const Value&) const;
	bool operator> (const Value&) const;
	bool operator>=(const Value&) const;
	
	
	private:
	void init();
	
	int      type;
	bool     m_bool;
	double   m_double;
	QString  m_string;
};

#endif // _VALUE_H_
