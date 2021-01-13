# QMEE
## 2019 Apr 02 (Tue) JD _promises_ to simplify "radically" for 2021
# https://mac-theobio.github.io/QMEE/?version=123
# https://mac-theobio.github.io/QMEE/index.html

### Hooks for the editor to set the default target
current: target
-include target.mk

vim_session:
	bash -cl "vmt"

##################################################################

Sources += $(wildcard docs/*.html) $(wildcard docs/*/*.html)

######################################################################

## Root content

## index.html.docs:
## index.html: index.md

index: index.md
	$(MAKE) index.html.docs
	$(MAKE) docs/index.html.go

Sources += rweb.mk
-include rweb.mk

######################################################################

update_all: admin.update topics.update
push_all: all.time

## Subdirectories

%.update:
	cd $* && $(MAKE) update

## admin
## admin.update:
alldirs += admin

## topics
## topics.update:
alldirs += topics

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

Sources += Makefile README.md notes.txt TODO.md .gitignore

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

