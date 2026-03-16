.PHONY: help build serve clean test

# Default target
.DEFAULT_GOAL := help

# Hugo command (use 'hugo' if installed via package manager)
HUGO := hugo

# Build directory
PUBLIC_DIR := public

help: ## Show this help message
	@echo "Available targets:"
	@echo "  make build  - Build the static site (generates files in $(PUBLIC_DIR)/)"
	@echo "  make serve  - Start Hugo development server (default: http://localhost:1313)"
	@echo "  make test   - Run test suite (starts server, tests links, stops server)"
	@echo "  make clean  - Remove generated files in $(PUBLIC_DIR)/"
	@echo "  make help   - Show this help message"

build: ## Build the static site
	@echo "Building Hugo site..."
	@$(HUGO)
	@echo "Build complete! Files generated in $(PUBLIC_DIR)/"

serve: ## Start Hugo development server
	@echo "Starting Hugo development server..."
	@echo "Server will be available at http://localhost:1313"
	@$(HUGO) server

test: ## Run test suite
	@./scripts/test_site.sh

clean: ## Remove generated files
	@echo "Cleaning $(PUBLIC_DIR)/ directory..."
	@rm -rf $(PUBLIC_DIR)
	@echo "Cleaning Hugo lock file..."
	@rm -f .hugo_build.lock
	@echo "Clean complete!"
