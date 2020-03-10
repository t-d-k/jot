CC=gcc
CXX=g++
RM=rm -f
CPPFLAGS=-g -c -pthread -Wall
LDFLAGS=-g -lm -ldl
LDLIBS=

SRCS=tokenizer.cpp jot2xml.cpp

OBJS=$(subst .cpp,.o,$(SRCS))

all: jot2xml

jot2xml: $(OBJS)
	$(CXX) $(LDFLAGS) -o jot2xml $(OBJS) $(LDLIBS) 

jot2xml.o: jot2xml.cpp tokenizer.h

tokenizer.o: tokenizer.h tokenizer.cpp

clean:
	$(RM) $(OBJS)

distclean: clean
	$(RM) jot2xml