.PHONY: up up-d down restart logs clean pull build

# Start services (attached)
up:
	docker compose up

# Start services in background (detached)
up-d:
	docker compose up -d

# Stop services
down:
	docker compose down

# Restart services
restart:
	docker compose restart

# View logs
logs:
	docker compose logs -f

# Clean up containers and volumes
clean:
	docker compose down -v --remove-orphans

# Pull latest images
pull:
	docker compose pull

# Build custom images (if any)
build:
	docker compose build
