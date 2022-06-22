#-------------------------------------------------
#
# Project created by QtCreator 2020-05-19T09:51:07
#
#-------------------------------------------------

QT       += core gui
QT       += webengine webenginewidgets

LIBS += -lts

greaterThan(QT_MAJOR_VERSION, 5) | equals(QT_MAJOR_VERSION, 5) {
	greaterThan(QT_MINOR_VERSION, 6) | equals(QT_MINOR_VERSION, 6) {
		QT += webenginewidgets
	} else {
		QT += webkit
		QT += webkitwidgets
	}
} else {
		QT += webkit
		QT += webkitwidgets
}

greaterThan(QT_MAJOR_VERSION, 4): QT += widgets

TARGET = exe_map
TEMPLATE = app


SOURCES += main.cpp\
        MyMainWindow.cpp

HEADERS  += MyMainWindow.h
