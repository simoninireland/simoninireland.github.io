# Personal web site Makefile

# Tools
PYTHON = python3
PIP = pip
NIKOLA = nikola
RM = rm -fr
ACTIVATE = . $(VENV)/bin/activate
MKDIR = mkdir

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
	continuous_import \
	static_tag_cloud \
	accordion \
	category_prevnext \
	similarity

# Datestamp of last import from Goodreads
IMPORTED = imported.txt

# New post
post:
	$(ACTIVATE) && $(NIKOLA) new_post -d -f markdown

# Run a live local server
live:
	$(ACTIVATE) && $(NIKOLA) auto

# Upload to github remote
upload:
	$(ACTIVATE) && $(NIKOLA) github_deploy

# Run the continuous import job to refresh from other sites
import: env
	$(ACTIVATE) && $(NIKOLA) continuous_import
	echo `date` >$(IMPORTED)

# Build the environment
env: $(VENV) $(THEMES_DIR) $(PLUGINS_DIR)

$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)

$(THEMES_DIR):
	$(MKDIR) $(THEMES_DIR)
	$(foreach t, $(THEMES), $(ACTIVATE) && $(NIKOLA) theme -i $t)

$(PLUGINS_DIR):
	$(MKDIR) $(PLUGINS_DIR)
	$(foreach t, $(PLUGINS), $(ACTIVATE) && $(NIKOLA) plugin -i $t)


# Clean up the build, to force a complete re-build
.PHONY: clean
clean:
	$(RM) $(BUILD_DIR)

# Clean up the environment as well (expensive to re-build)
.PHONY: reallyclean
reallyclean: clean
	$(RM) $(VENV) $(THEMES_DIR) $(PLUGINS_DIR)
