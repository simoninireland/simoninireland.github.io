# Personal web site Makefile
# Copyright (c) 2022 Simon Dobson <simoninireland@gmail.com>

# Files needing copying on an import
UPDATE_FILES = \
	~/personal/cv/short-cv.pdf \
	~/personal/cv/medium-cv.pdf

# Files needing a refresh of their dynamic blocks
DB_REFRESH_FILES = \
	pages/research/publications.org \
	pages/research/publications-by-year.org

# Tools
PYTHON = python3
PIP = pip
NIKOLA = nikola
RM = rm -fr
ACTIVATE = . $(VENV)/bin/activate
MKDIR = mkdir
CP = cp
EMACS = emacs --batch -L elisp

# Venv
VENV = venv3
REQUIREMENTS = requirements.txt

# Constructed diretories
BUILD_DIR = output
THEMES_DIR = themes
PLUGINS_DIR = plugins

# Themes and plug-ins
THEMES = \
	bootstrap3-jinja \
	zen-jinja \
	canterville
PLUGINS = \
	orgmode \
	continuous_import \
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
	$(EMACS) --eval "(require sd-parsebib)" $(foreach f, $(DB_REFRESH_FILES), --eval "(find-file $f)(org-update-all-dblocks)")

# Build the environment
env: $(VENV) $(THEMES_DIR) $(PLUGINS_DIR) extras

$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)

$(THEMES_DIR):
	$(MKDIR) $(THEMES_DIR)
	$(foreach t, $(THEMES), $(ACTIVATE) && $(NIKOLA) theme -i $t)

$(PLUGINS_DIR):
	$(MKDIR) $(PLUGINS_DIR)
	$(foreach p, $(PLUGINS), $(ACTIVATE) && $(NIKOLA) plugin -i $p)
	$(CP) elisp/orgmode-conf.py plugins/orgmode/conf.py

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
	$(RM) $(VENV) $(THEMES_DIR) $(PLUGINS_DIR)
