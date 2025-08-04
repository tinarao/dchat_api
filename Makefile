run: docker
	mix phx.server

docker:
	docker compose up -d
