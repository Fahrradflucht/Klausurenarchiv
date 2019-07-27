node_modules: package.json
	npm i

deps: mix.exs
	mix deps.get

.PHONY: start
start: deps node_modules
	mix ecto.create
	mix ecto.migrate
	mix phoenix.server

.PHONY: test
test: deps
	mix test

.PHONY: docker_test
docker_test:
	docker-compose run --rm app make test

.PHONY: docker_start
docker_start:
	docker-compose up
