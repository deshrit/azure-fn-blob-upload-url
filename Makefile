.DEFAULT_GOAL := default

.PHONY: default
default:
	@echo "lint                 Lint function app code base"
	@echo "lint-fix             Lint fix function app code base"
	@echo "mypy                 Type check function app code base"
	@echo "format               Format function app code base"
	@echo "test                 Run function app test"


.PHONY: lint
lint:
	ruff check ./app

.PHONY: lint-fix
lint-fix:
	ruff check --fix ./app

.PHONY: mypy
mypy:
	mypy ./app

.PHONY: format
format:
	ruff format ./app

.PHONY: test
test:
	@echo "test"