init:
		docker compose down
		docker compose pull
		docker compose build
		docker compose up

down:
		docker compose down