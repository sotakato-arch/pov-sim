up:
	-include .env
	export OTLP_INSTANCE_ID OTLP_API_TOKEN OTLP_AUTH_TOKEN PROFILE_INSTANCE_ID PROFILE_API_TOKEN
	docker compose up --build

down:
	docker compose down

.PHONY: up down
