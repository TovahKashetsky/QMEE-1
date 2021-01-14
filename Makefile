# QMEE
# https://mac-theobio.github.io/QMEE/?version=123

### Hooks for the editor to set the default target
current: target
-include target.mk

vim_session:
	bash -cl "vmt index.md rweb.mk"

##################################################################

Sources += $(wildcard docs/*.html) $(wildcard docs/*/*.html)
Sources += $(wildcard html/*.*)

######################################################################

## Root content

## docs/index.html: index.md

## Current is for stashing stuff that's not current now, but was current before
Sources += index.md current.md
Ignore += index.html

docs/index.html: index.md
	pandoc $< -o $@ --mathjax -s -B html/mainheader.html -A html/mainfooter.html --css html/qmee.css --self-contained

Sources += rweb.mk
-include rweb.mk

######################################################################

## Run things from lectures

lectures/docs/%.html: $(wildcard lectures/*.rmd)
	cd lectures && $(MAKE) $*

## lectures/docs/intro_Lecture_notes.slides.html: lectures/intro_Lecture_notes.rmd
## lectures/docs/intro_Lecture_notes.notes.html: lectures/intro_Lecture_notes.rmd

######################################################################

## Subdirectories

%.update:
	cd $* && $(MAKE) update

subdirs += admin topics
subdirs += lectures tips

######################################################################

Ignore += $(subdirs)
alldirs += $(subdirs)

update_all: makestuff $(subdirs:%=%.makestuff) $(subdirs:%=%.update) update

local_site: update_all
	$(MAKE) docs/index.html.go

old_site: gh-pages
	$(MAKE) gh-pages/index.html.go

push_all: all.time

dateup:
	touch docs/*.html docs/*/*.html

######################################################################

## Old content

## git mv source stuff from oldSource to where it's wanted
## arcScript: ; git mv $(oldscripts) oldSource ##

## Look around, or emergency rescue
Ignore += gh-pages
gh-pages:
	$(MAKE) $@.branchdir

##################################################################

## A bunch of confusing rmd rules
Sources += pages.mk

## Live sessions

Sources += live.mk

## Weird stuff

Sources += orphans.mk

######################################################################

### Makestuff

Sources += Makefile README.md notes.txt TODO.md

msrepo = https://github.com/dushoff
ms = makestuff

# -include $(ms)/perl.def

Ignore += $(ms)
## Sources += $(ms)
Makefile: $(ms)/Makefile
$(ms)/Makefile:
	git clone $(msrepo)/$(ms)

-include $(ms)/os.mk

-include makestuff/git.mk
-include makestuff/visual.mk

