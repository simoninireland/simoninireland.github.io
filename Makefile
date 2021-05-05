# Personal web site Makefile

PYTHON = python3
PIP = pip
NIKOLA = nikola
RM = rm -fr
ACTIVATE = . $(VENV)/bin/activate

VENV = venv3
REQUIREMENTS = requirements.txt
BUILD_DIR = output

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
env: $(VENV)

$(VENV):
	$(PYTHON) -m venv $(VENV)
	$(ACTIVATE) && $(PIP) install -U pip wheel && $(PIP) install -r $(REQUIREMENTS)

# Clean up the build, to force a complete re-build
clean:
	$(RM) $(BUILD_DIR)

# Clean up the environment as well (expensive to re-build)
reallyclean: clean
	$(RM) $(VENV)
