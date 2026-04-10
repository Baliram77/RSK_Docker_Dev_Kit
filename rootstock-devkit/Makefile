.PHONY: up down logs ps wipe restart

up:
	docker compose up -d

down:
	docker compose down

logs:
	docker compose logs -f --tail=200

ps:
	docker compose ps

wipe:
	docker compose down -v

restart: down up

