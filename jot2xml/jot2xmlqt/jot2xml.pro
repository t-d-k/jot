QT = core

CONFIG += console
CONFIG -= app_bundle

TARGET = jot2xml
TEMPLATE = app

SOURCES += \
    ../jot2xml.cpp
SOURCES += \
    ../tokenizer.cpp


target.path = /home/tom/sync/Projects/jedit macros/jot_support/jot2xml/jot2xmlqt/
INSTALLS += target
