.PHONY: up down logs ps reset deploy test wipe restart

up:
	docker compose up -d

down:
	docker compose down

reset:
	./scripts/reset.sh

deploy:
	./scripts/deploy.sh

test:
	cd foundry && forge build && forge test

logs:
	docker compose logs -f --tail=200

ps:
	docker compose ps

wipe:
	docker compose down -v

restart: down up

