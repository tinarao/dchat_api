start: docker
	run

docker:
	docker compose up -d

run:
	@export $$(cat .env | xargs) && \
	mix phx.server
