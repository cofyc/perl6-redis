.PHONY: all test

PERL6  = perl6
PREFIX = $(HOME)/.perl6
P6LIB  = $(PWD)/lib:$(PERL6LIB)
CP     = cp -p
MKDIR  = mkdir -p

all:

test: all
	env PERL6LIB=$(P6LIB) prove -e '$(PERL6)' -r t/
