PROJECT_NAME=smm-vk


# colors
GREEN = $(shell tput -Txterm setaf 2)
YELLOW = $(shell tput -Txterm setaf 3)
WHITE = $(shell tput -Txterm setaf 7)
RESET = $(shell tput -Txterm sgr0)
GRAY = $(shell tput -Txterm setaf 6)
TARGET_MAX_CHAR_NUM = 20

# Common

all: run

init_dev:
	poetry install --no-root

pretty:
	poetry run black -l 120 -t py310 .

# Help

## Shows help.
help:
	@echo ''
	@echo 'Usage:'
	@echo ''
	@echo '  ${YELLOW}make${RESET} ${GREEN}<target>${RESET}'
	@echo ''
	@echo 'Targets:'
	@awk '/^[a-zA-Z\-]+:/ { \
		helpMessage = match(lastLine, /^## (.*)/); \
		if (helpMessage) { \
		    if (index(lastLine, "|") != 0) { \
				stage = substr(lastLine, index(lastLine, "|") + 1); \
				printf "\n ${GRAY}%s: \n\n", stage;  \
			} \
			helpCommand = substr($$1, 0, index($$1, ":")-1); \
			helpMessage = substr(lastLine, RSTART + 3, RLENGTH); \
			if (index(lastLine, "|") != 0) { \
				helpMessage = substr(helpMessage, 0, index(helpMessage, "|")-1); \
			} \
			printf "  ${YELLOW}%-$(TARGET_MAX_CHAR_NUM)s${RESET} ${GREEN}%s${RESET}\n", helpCommand, helpMessage; \
		} \
	} \
	{ lastLine = $$0 }' $(MAKEFILE_LIST)
	@echo ''

# Linters & tests

lint:
	poetry run flake8 --jobs 4 --statistics --show-source smm-vk
	poetry run black -l 120 -t py310 --check .


test:
	poetry run pytest -n 4 -vvv --trace-config -p no:warnings --cov=smm-vk --junitxml=junit.xml --cov-report xml:coverage.xml --cov-report term
	poetry run python3 -c "exec(\"from xml.etree import ElementTree\ntree = ElementTree.parse('./coverage.xml')\nsources = tree.find('sources')\nfor source in sources:source.text ='./'+ source.text.split('/')[-1]\ntree.write('./coverage.xml')\")"
