.PHONY: all test

PERL6  = perl6
PREFIX = $(HOME)/.perl6
CP     = cp -p
MKDIR  = mkdir -p

all:

test: all
	prove -e '$(PERL6)' -r t/
