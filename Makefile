.PHONY: up up-d down restart logs clean pull build check

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

# Validate environment configuration files
check:
	@echo "==> Checking environment configuration files"
	@if [ ! -f .env.config ]; then echo "ERROR: .env.config is missing (copy from .env.config.example)"; exit 1; fi
	@if [ ! -f .env.secrets ]; then echo "ERROR: .env.secrets is missing (copy from .env.secrets.example and NEVER commit it)"; exit 1; fi
	@echo "==> Validating required keys in .env.config"
	@failed=0; \
	for var in PUID PGID TZ MEDIA_ROOT DOWNLOAD_ROOT CONFIG_ROOT VPN_PROVIDER VPN_ENABLED VPN_DNS VPN_PROTOCOL VPN_PORT VPN_KILL_SWITCH DOMAIN ACME_EMAIL; do \
	  if ! grep -Eq "^$$var=" .env.config; then \
	    echo "MISSING in .env.config: $$var"; failed=1; \
	  fi; \
	done; \
	if [ "$$failed" -ne 0 ]; then \
	  echo "Environment check FAILED for .env.config"; exit 1; \
	else \
	  echo ".env.config looks OK"; \
	fi
	@echo "==> Validating expected keys in .env.secrets"
	@failed=0; \
	for var in OPENVPN_USER OPENVPN_PASSWORD PLEX_CLAIM PROWLARR_API_KEY PROWLARR_AUTH_USERNAME PROWLARR_AUTH_PASSWORD RADARR_API_KEY SONARR_API_KEY QBITTORRENT_USERNAME QBITTORRENT_PASSWORD; do \
	  if ! grep -Eq "^$$var=" .env.secrets; then \
	    echo "MISSING in .env.secrets: $$var"; failed=1; \
	  fi; \
	done; \
	if [ "$$failed" -ne 0 ]; then \
	  echo "Environment check FAILED for .env.secrets"; exit 1; \
	else \
	  echo ".env.secrets looks OK (values not displayed)"; \
	fi
	@echo "==> Environment checks completed successfully"
