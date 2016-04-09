CC=gcc
CFLAGS=-c -Wall -Wno-unused-function -O0 -g -I..
COPTS=
LDFLAGS= -lm
SOURCES=../intspan.c test.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=test

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) ${COPTS} $(OBJECTS) $(LDFLAGS) -o $@

.c.o:
	$(CC) ${COPTS} $(CFLAGS) $< -o $@

clean:
	-rm $(OBJECTS) $(EXECUTABLE)
