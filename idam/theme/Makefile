
# The version of the build harness container to use
THEME_REPO := 127.0.0.1/defenseunicorns/uds-idam/theme
THEME_VERSION := 0.1

.PHONY: help
help: ## Show a list of all targets
	grep -E '^\S*:.*##.*$$' $(MAKEFILE_LIST) \
	| sed -n 's/^\(.*\): \(.*\)##\(.*\)/\1:\3/p' \
	| column -t -s ":"

.PHONY: build
build: ## Create a new jar file and a new container image with the jar file
	jar -cvf theme.jar META-INF theme
	docker build -t $(THEME_REPO):$(THEME_VERSION) .

.PHONY: build
push: build ## Push the image to the container registry
	docker push $(THEME_REPO):$(THEME_VERSION)

.PHONY: clean
clean: ## Remove the generated theme jar file
	rm -f theme.jar
