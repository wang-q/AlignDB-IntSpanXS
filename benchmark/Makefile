CC=gcc
CFLAGS=-c -Wall -Wno-unused-function -O0 -g -I..
COPTS=
LDFLAGS= -lm
SOURCES=../intspan.c test_c.c
OBJECTS=$(SOURCES:.c=.o)
EXECUTABLE=test_c

all: $(SOURCES) $(EXECUTABLE)

$(EXECUTABLE): $(OBJECTS)
	$(CC) ${COPTS} $(OBJECTS) $(LDFLAGS) -o $@

.c.o:
	$(CC) ${COPTS} $(CFLAGS) $< -o $@

clean:
	-rm $(OBJECTS) $(EXECUTABLE)
