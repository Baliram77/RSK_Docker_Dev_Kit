.PHONY: up down logs ps reset deploy test wipe restart up-lite down-lite reset-lite logs-lite ps-lite

PROFILE ?= full

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

