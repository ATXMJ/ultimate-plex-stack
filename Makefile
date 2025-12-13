.PHONY: up up-d down restart logs clean pull build

# Start services (attached) - load config from .env.config
up:
	docker compose --env-file .env.config up

# Start services in background (detached)
up-d:
	docker compose --env-file .env.config up -d

# Stop services
down:
	docker compose --env-file .env.config down

# Restart services
restart:
	docker compose --env-file .env.config restart

# View logs
logs:
	docker compose --env-file .env.config logs -f

# Clean up containers and volumes
clean:
	docker compose --env-file .env.config down -v --remove-orphans

# Pull latest images
pull:
	docker compose --env-file .env.config pull

# Build custom images (if any)
build:
	docker compose --env-file .env.config build
