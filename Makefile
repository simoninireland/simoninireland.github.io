# Personal web site Makefile
# Copyright (c) 2022 Simon Dobson <simoninireland@gmail.com>

# Files needing copying on an import
UPDATE_FILES = \
	~/personal/cv/short-cv.pdf \
	~/personal/cv/medium-cv.pdf

# Files needing a refresh of their dynamic blocks
DB_REFRESH_FILES = \
	./pages/research/publications.org \
	./pages/research/publications-by-year.org

# Bibfiles
BIBFILES = ~/personal/dict/sd.bib

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
CP = cp
EMACS = emacs --batch -L elisp

# Venv
VENV = venv3
REQUIREMENTS = requirements.txt

# Constructed diretories
BUILD_DIR = output
THEMES_DIR = themes
PLUGINS_DIR = plugins

# Plug-ins to download
PLUGINS = \
	orgmode \
	static_tag_cloud \
	accordion \
	category_prevnext \
	similarity

# New post, using an org mode file
post: env
	$(ACTIVATE) && $(NIKOLA) new_post -d -f org

# Run a live local server
live: env
	$(ACTIVATE) && $(NIKOLA) auto

# Upload to the Github remote
publish: upload

release: upload

upload: env
	$(ACTIVATE) && $(NIKOLA) github_deploy

# Update all files that need it
update: update-files update-dblocks continuous-import

continuous-import: env
	$(ACTIVATE) && $(NIKOLA) continuous_import

update-files:
	$(foreach f, $(UPDATE_FILES), $(CP) $f files/)

update-dblocks:
	$(EMACS) -l "sd-update-dblocks.el" \
	$(foreach b, $(BIBFILES), --eval "(add-to-list 'bibtex-completion-bibliography (expand-file-name \"$b\"))") \
	$(foreach f, $(DB_REFRESH_FILES), --eval "(sd/update-dblocks-in-file (expand-file-name \"$f\"))")

# Build the environment
env: $(VENV) $(PLUGINS_DIR) $(PLUGINS_DIR)/continuous_import extras

$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)

$(PLUGINS_DIR):
	$(MKDIR) $(PLUGINS_DIR)
	$(foreach p, $(PLUGINS), $(ACTIVATE) && $(NIKOLA) plugin -i $p)
	$(CP) elisp/orgmode-conf.el plugins/orgmode/conf.py

# Checkout the modified continuous_import plugin from the forked repo,
# until it gets merged with the main tree
# see https://stackoverflow.com/questions/7106012/download-a-single-folder-or-directory-from-a-github-repo
$(PLUGINS_DIR)/continuous_import:
	$(CHDIR) $(PLUGINS_DIR) && $(SVN) checkout https://github.com/simoninireland/nikola-plugins/branches/categories-merged-tags/v7/continuous_import

extras: plugins/orgmode/conf.el

plugins/orgmode/conf.el: elisp/orgmode-conf.el
	$(CP) $< $@

# Clean up the build, to force a complete re-build
.PHONY: clean
clean:
	$(RM) $(BUILD_DIR)

# Clean up the environment as well
.PHONY: reallyclean
reallyclean: clean
	$(RM) $(VENV) $(PLUGINS_DIR)
