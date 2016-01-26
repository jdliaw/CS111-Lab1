# CS 111 Lab 1a
# Makefile for simpsh
# make builds the simpsh program
# make clean removes the program and all other temp files/object files
# make check tests the simpsh program on test cases you design (at least 3)
# make dist makes a tarball lab1-yourname.tar.gz and does some testing
# all files in tarball should be named lab1-yourname/... and lab1-yourname/Makefile
# tarball should include: main.c, Makefile, test.sh, README

OPTIMIZE = -O2

CC = gcc
CFLAGS = $(OPTIMIZE) -g -Wall -Wextra -Wno-unused
LAB = 1
DISTDIR = lab1-jenniferliawbrandonliu

default: simpsh

simpsh: main.c
	$(CC) $(CFLAGS) main.c -o $@

check:
	./test.sh

dist: $(DISTDIR).tar.gz

SOURCES = README Makefile main.c test.sh
$(DISTDIR).tar.gz: $(SOURCES) check-dist
	rm -fr $(DISTDIR)
	tar -czf $@.tmp --transform='s,^,$(DISTDIR)/,' $(SOURCES)
	./check-dist $(DISTDIR)
	mv $@.tmp $@

clean:
	rm -fr *.o *~ *.tar.gz *.tmp core *.core simpsh $(DISTDIR)

.PHONY: all dist check clean

