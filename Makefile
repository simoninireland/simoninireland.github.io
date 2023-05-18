# Personal web site Makefile
# Copyright (c) 2022 Simon Dobson <simoninireland@gmail.com>

# Files needing copying on an import
UPDATE_FILES = \
	~/personal/cv/short-cv.pdf \
	~/personal/cv/medium-cv.pdf \
	~/.gnupg/publickey.gpg
UPDATE_DIRS = \
	~/personal/dict/softcopy

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
RSYNC = rsync -rav
ECHO = echo
CURL = curl
EMACS = emacs --batch -L elisp

# Venv
VENV = venv3
REQUIREMENTS = requirements.txt

# Constructed diretories
BUILD_DIR = output
CACHE_DIOR = cache
PLUGINS_DIR = plugins

# Constructed files
EXTRAS = \
	plugins/orgmode/conf.el \
	themes/adolf/assets/css/fonts.css

# Plug-ins to download
PLUGINS = \
	orgmode \
	static_tag_cloud \
	accordion \
	category_prevnext \
	similarity

# Web fonts to include (from Google Fonts)
WEBFONTS = \
	"Libre+Baskerville" \
	"EB+Garamond" \
	"Varela+Round" \
	"Questrial" \
	"Alegreya"
WEBFONTS_API = "https://fonts.googleapis.com/css2?family="

# The git branch we're currently working on
GIT_BRANCH = $(shell $(GIT) rev-parse --abbrev-ref HEAD 2>/dev/null)

# New post, using an org mode file
post: env
	$(ACTIVATE) && $(NIKOLA) new_post -d -f org

# Run a live local server
live: env
	$(ACTIVATE) && $(NIKOLA) auto

# Build a static copy
build:  env
	$(ACTIVATE) && $(NIKOLA) build

# Upload to the Github remote
publish: upload

deploy: upload

# Possibly auto-update as well before deployment?
upload: env src-only
	$(ACTIVATE) && $(NIKOLA) github_deploy

# Check we're on the src branch before deploying
src-only:
	if [ "$(GIT_BRANCH)" != "src" ]; then echo "Can only deploy from src branch"; exit 1; fi

# Update all files that need it
update: update-files update-dblocks continuous-import

update-files:
	$(foreach f, $(UPDATE_FILES), $(RSYNC) $f files/$(shell basename $(f:.gpg=.asc));)
	$(foreach d, $(UPDATE_DIRS), $(RSYNC) $d files/;)

update-dblocks: env
	$(EMACS) -l "sd-update-dblocks.el" \
	$(foreach b, $(BIBFILES), --eval "(add-to-list 'bibtex-completion-bibliography (expand-file-name \"$b\"))") \
	$(foreach f, $(DB_REFRESH_FILES), --eval "(sd/update-dblocks-in-file (expand-file-name \"$f\"))")

continuous-import: env
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

themes/adolf/assets/css/fonts.css:
	$(ECHO) '' $@
	$(foreach f, $(WEBFONTS), $(CURL) $(WEBFONTS_API)$f >> $@;)

# Clean up the build, to force a complete re-build
.PHONY: clean
clean:
	$(RM) $(BUILD_DIR)

# Clean up the environment as well
.PHONY: reallyclean
reallyclean: clean
	$(RM) $(VENV) $(PLUGINS_DIR) $(EXTRAS) $(CACHE_DIR)
