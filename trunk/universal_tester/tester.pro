TEMPLATE	= app
LANGUAGE	= C++

CONFIG	+= qt warn_on debug

LIBS	+= -lbluetooth -lkdeui -lserial -L/opt/kde/lib

INCLUDEPATH	+= /opt/kde/include

HEADERS	+= aircableOS.h \
	rfcomm.h \
	aircableUSB.h \
	aircableSerial.h

SOURCES	+= main.cpp \
	aircableOS.cpp \
	rfcomm.cpp \
	aircableUSB.cpp \
	aircableSerial.cpp

FORMS	= qtaircablemainform.ui \
	qtabout.ui

IMAGES	= images/usb.jpg \
	images/serial.jpg \
	images/serial-os.jpg

unix {
  UI_DIR = .ui
  MOC_DIR = .moc
  OBJECTS_DIR = .obj
}


