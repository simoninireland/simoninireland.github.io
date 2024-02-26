# Personal web site Makefile
#
# Copyright (c) 2022--2024 Simon Dobson <simoninireland@gmail.com>
#
# This is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This software  is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this software. If not, see <http://www.gnu.org/licenses/gpl.html>.

# ---------- Files ----------

# Files needing copying on an upgrade
UPGRADE_FILES = \
	~/personal/cv/short-cv.pdf \
	~/personal/cv/medium-cv.pdf \
	~/personal/notebook/online-citations.csl \
	~/personal/notebook/online-references.csl \
	~/.gnupg/publickey.gpg
UPGRADE_DIRS = \
	~/personal/dict/softcopy

# Files needing a refresh of their dynamic blocks
DB_REFRESH_FILES = \
	./pages/research/publications.org \
	./pages/research/publications-by-year.org

# Bibfiles
BIBFILES = ~/personal/dict/sd.bib


# ---------- Tools ----------

# Tools
PYTHON = python3
PIP = pip
NIKOLA = nikola
RM = rm -fr
ACTIVATE = . $(VENV)/bin/activate
MKDIR = mkdir
CHDIR = cd
GIT = git
SVN = svn
RSYNC = rsync -rav
ECHO = echo
CURL = curl
EMACS = emacs --batch -L elisp

# Python venv
VENV = venv3
REQUIREMENTS = requirements.txt

# Constructed directories
BUILD_DIR = output
CACHE_DIOR = cache
PLUGINS_DIR = plugins

# Constructed files
EXTRAS = \
	plugins/orgmode/conf.el

# Plug-ins to download
PLUGINS = \
	orgmode

# The git branch we're currently working on
GIT_BRANCH = $(shell $(GIT) rev-parse --abbrev-ref HEAD 2>/dev/null)


# ---------- Top-level targets ----------

# Default prints a help message
help:
	@make usage

# New post, using an org mode file
post: env
	$(ACTIVATE) && $(NIKOLA) new_post -d -f orgmode

# Run a live local server
live: env
	$(ACTIVATE) && $(NIKOLA) auto

# Build a static copy
build:  env
	$(ACTIVATE) && $(NIKOLA) build

# Check we're on the src branch before deploying
src-only:
	@if [ "$(GIT_BRANCH)" != "src" ]; then echo "Can only deploy from src branch"; exit 1; fi

# Update and upload
update: upgrade upload

upload: env src-only
	$(ACTIVATE) && $(NIKOLA) github_deploy

# Upgrade all static and generated files
upgrade: upgrade-files upgrade-dblocks upgrade-external

upgrade-files:
	$(foreach f, $(UPGRADE_FILES), $(RSYNC) $f files/$(shell basename $(f:.gpg=.asc));)
	$(foreach d, $(UPGRADE_DIRS), $(RSYNC) $d files/;)

upgrade-dblocks: env
	$(EMACS) -l "sd-update-dblocks.el" \
	$(foreach b, $(BIBFILES), --eval "(add-to-list 'bibtex-completion-bibliography (expand-file-name \"$b\"))") \
	$(foreach f, $(DB_REFRESH_FILES), --eval "(sd/update-dblocks-in-file (expand-file-name \"$f\"))")

upgrade-external: env
	$(ACTIVATE) && $(NIKOLA) continuous_import

# Build the environment
env: $(VENV) $(PLUGINS_DIR) $(PLUGINS_DIR)/continuous_import extras

$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)

$(PLUGINS_DIR):
	$(MKDIR) $(PLUGINS_DIR)
	$(foreach p, $(PLUGINS), $(ACTIVATE) && $(NIKOLA) plugin -i $p)

# Checkout the modified continuous_import plugin from the forked repo,
# until it gets merged with the main tree
# see https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo
$(PLUGINS_DIR)/continuous_import:
	$(CHDIR) $(PLUGINS_DIR) && $(SVN) checkout https://github.com/simoninireland/nikola-plugins/branches/categories-merged-tags/v7/continuous_import

extras: $(EXTRAS)

plugins/orgmode/conf.el: elisp/orgmode-conf.el
	$(RSYNC) $< $@

# Clean up the build, to force a complete re-build
.PHONY: clean
clean:
	$(RM) $(BUILD_DIR)

# Clean up the environment as well
.PHONY: reallyclean
reallyclean: clean
	$(RM) $(VENV) $(PLUGINS_DIR) $(EXTRAS) $(CACHE_DIR)


# ----- Usage -----

define HELP_MESSAGE
Available targets:
   make live         run a local test server
   make post         create a new post as an orgmode file
   make build        build the web site into output/
   make upgrade      copy files from home directory to web site
   make upload       upload local built copy of web site
   make update       upgrade and then upload
   make env          install Nikola etc
   make clean        delete local built copy
   make reallyclean  also delete venv, plugns, etc

endef
export HELP_MESSAGE

usage:
	@echo "$$HELP_MESSAGE"
