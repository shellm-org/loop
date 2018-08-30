.PHONY: rmdoc

BINDIR := bin
LIBDIR := lib
MANDIR := man
WIKIDIR := wiki

SCRIPTS := $(sort $(shell cd $(BINDIR) && ls))
LIBRARIES := $(sort $(shell cd $(LIBDIR) && ls))

MANPAGES := $(addprefix $(MANDIR)/,$(addsuffix .1,$(SCRIPTS)) $(addsuffix .3,$(LIBRARIES)))
WIKIPAGES := $(addprefix $(WIKIDIR)/,$(addprefix Scripts/,$(addsuffix .md,$(SCRIPTS))) $(addprefix Library/,$(addsuffix .md,$(LIBRARIES))))

ifeq ($(PREFIX), )
PREFIX := /usr/local
endif

all: doc

install:
	@./install.sh $(PREFIX)

$(MANDIR)/%.1: $(BINDIR)/%
	@shellman -tmanpage $< -o $@

$(MANDIR)/%.sh.3: $(LIBDIR)/%.sh
	@shellman -tmanpage $< -o $@

$(WIKIDIR)/Scripts/%.md: $(BINDIR)/%
	@shellman -twikipage $< -o $@

$(WIKIDIR)/Library/%.sh.md: $(LIBDIR)/%.sh
	@shellman -twikipage $< -o $@

man: $(MANPAGES)

wiki: $(WIKIPAGES)
	@shellman -tpath:templates/wiki_home.md -o wiki/home.md \
		--context project=loop \
							scripts="$(SCRIPTS)" \
							libraries="$(LIBRARIES)"

doc: man wiki

rmdoc:
	@rm man/* wiki/Scripts/* wiki/Library/*
