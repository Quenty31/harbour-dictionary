CONFIG += sailfishapp
LIBS += -lz -lquazip -L../quazip/quazip

QT += sql core

DEPENDPATH += . ../quazip/quazip
INCLUDEPATH += . ../quazip/quazip
QMAKE_LFLAGS += -Wl,-rpath,\\$${LITERAL_DOLLAR}$${LITERAL_DOLLAR}ORIGIN/../share/harbour-dictionary/lib

INSTALLS += target
target.path = /usr/bin/

TARGET = harbour-dictionary
TEMPLATE = app

SOURCES += harbour-dictionary.cpp \
    databasemanager.cpp \
    heinzelnisseelement.cpp \
    heinzelnissemodel.cpp \
    dictccimportermodel.cpp \
    dictccimportworker.cpp \
    dictionarymodel.cpp \
    dictionarymetadata.cpp \
    dictccword.cpp \
    dictionarysearchworker.cpp

HEADERS += \
    heinzelnisseelement.h \
    databasemanager.h \
    heinzelnissemodel.h \
    dictccimportermodel.h \
    dictccimportworker.h \
    dictionarymodel.h \
    dictionarymetadata.h \
    dictccword.h \
    dictionarysearchworker.h \
