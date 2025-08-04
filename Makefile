# Makefile for MeshbotWeatherContainer

.PHONY: help build run stop logs clean fetch-source setup

# Default target
help:
	@echo "Available commands:"
	@echo "  setup        - Initial setup (fetch source, create settings.yaml)"
	@echo "  build        - Build Docker image"
	@echo "  run          - Run container with docker-compose"
	@echo "  stop         - Stop container"
	@echo "  logs         - Show container logs"
	@echo "  clean        - Remove container and image"
	@echo "  fetch-source - Fetch latest source from original repo"
	@echo "  shell        - Open shell in running container"

# Initial setup
setup: fetch-source
	@if [ ! -f settings.yaml ]; then \
		echo "Creating settings.yaml from example..."; \
		cp settings.yaml.example settings.yaml; \
		echo "Please edit settings.yaml with your configuration"; \
	else \
		echo "settings.yaml already exists"; \
	fi

# Fetch source code from original repository
fetch-source:
	@echo "Fetching latest source from Meshbot_weather repository..."
	@./scripts/fetch-source.sh

# Build Docker image
build:
	@echo "Building Docker image..."
	docker build -t meshbot-weather .

# Run container
run:
	@echo "Starting container..."
	docker-compose up -d

# Stop container
stop:
	@echo "Stopping container..."
	docker-compose down

# Show logs
logs:
	@echo "Showing container logs..."
	docker-compose logs -f

# Clean up
clean:
	@echo "Cleaning up..."
	docker-compose down --rmi all --volumes --remove-orphans
	docker rmi meshbot-weather 2>/dev/null || true

# Open shell in running container
shell:
	@echo "Opening shell in container..."
	docker-compose exec meshbot-weather /bin/bash

# Build and run in one command
build-run: build run

# Restart container
restart: stop run

# Show container status
status:
	@echo "Container status:"
	docker-compose ps 