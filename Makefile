.PHONY: all test

PERL6  = perl6
PREFIX = $(HOME)/.perl6
BLIB   = blib
P6LIB  = $(PWD)/$(BLIB)/lib:$(PWD)/lib
CP     = cp -p
MKDIR  = mkdir -p
BLIB_PIRS = $(BLIB)/lib/Redis.pir

all: $(BLIB_PIRS)

$(BLIB)/lib/Redis.pir: lib/Redis.pm
	$(MKDIR) $(BLIB)/lib/
	PERL6LIB=$(BLIB) $(PERL6) --target=pir --output=$@ $^

test: all
	env PERL6LIB=$(P6LIB) prove -e '$(PERL6)' -r t/
