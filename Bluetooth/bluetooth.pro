#-------------------------------------------------
#
# Project created by QtCreator 2016-08-04T15:55:53
#
#-------------------------------------------------

QT       += core gui
QT      += bluetooth
greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = HiAndroid
TEMPLATE = app


SOURCES += main.cpp\
        widget.cpp

HEADERS  += widget.h

FORMS    += widget.ui

CONFIG += mobility
MOBILITY = 

