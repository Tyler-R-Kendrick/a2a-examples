# A2A Examples Makefile
# Provides simple commands to run common tasks

.PHONY: help setup test local server all clean

# Default target
help:
	@echo "Available commands:"
	@echo "  make setup    - Install dependencies"
	@echo "  make test     - Run tests"
	@echo "  make local    - Run local agent test"
	@echo "  make server   - Start A2A server (localhost:10020)"
	@echo "  make all      - Run setup, tests, local test, then start server"
	@echo "  make clean    - Clean up cache files"
	@echo ""
	@echo "Server with custom host/port:"
	@echo "  make server HOST=0.0.0.0 PORT=8080"

# Install dependencies
setup:
	@echo "Installing dependencies..."
	python3 -m pip install -e .

# Run tests
test:
	@echo "Running tests..."
	python3 -m pip install pytest
	python3 -m pytest tests/ -v

# Run local agent test
local:
	@echo "Running local agent test..."
	python3 main.py

# Start server with optional host and port
HOST ?= localhost
PORT ?= 10020
server:
	@echo "Starting A2A server on $(HOST):$(PORT)..."
	python3 __main__.py --host $(HOST) --port $(PORT)

# Run everything in sequence
all: setup test local
	@echo "All checks passed! Starting server..."
	@$(MAKE) server

# Clean up cache files
clean:
	@echo "Cleaning up cache files..."
	find . -type d -name __pycache__ -exec rm -rf {} + 2>/dev/null || true
	find . -type f -name "*.pyc" -delete 2>/dev/null || true
	@echo "Cache files cleaned"
