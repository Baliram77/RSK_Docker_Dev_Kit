.PHONY: help up down logs ps reset deploy test wipe restart up-lite down-lite reset-lite logs-lite ps-lite

PROFILE ?= full

help:
	@echo "Rootstock devkit (docker compose profile: $$(PROFILE), default: full)"
	@echo ""
	@echo "  make up|down|logs|ps|restart   - compose lifecycle"
	@echo "  make reset                     - ./scripts/reset.sh (same profile)"
	@echo "  make deploy                    - Foundry deploy script"
	@echo "  make test                      - forge build + test"
	@echo "  make wipe CONFIRM=yes        - DESTRUCTIVE: docker compose down -v (removes chain + Blockscout DB)"
	@echo "  make up-lite / down-lite / ... - PROFILE=lite shortcuts"
	@echo ""

up:
	docker compose --profile $(PROFILE) up -d

down:
	docker compose --profile $(PROFILE) down

reset:
	./scripts/reset.sh

deploy:
	./scripts/deploy.sh

test:
	cd foundry && forge build && forge test

logs:
	docker compose --profile $(PROFILE) logs -f --tail=200

ps:
	docker compose --profile $(PROFILE) ps

wipe:
ifneq ($(CONFIRM),yes)
	$(error Refusing to wipe volumes without CONFIRM=yes — this deletes RSKj chain data and Blockscout Postgres. Run: make wipe CONFIRM=yes)
endif
	docker compose --profile $(PROFILE) down -v

restart: down up

up-lite:
	$(MAKE) up PROFILE=lite

down-lite:
	$(MAKE) down PROFILE=lite

reset-lite:
	./scripts/reset.sh lite

logs-lite:
	$(MAKE) logs PROFILE=lite

ps-lite:
	$(MAKE) ps PROFILE=lite

