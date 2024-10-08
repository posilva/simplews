.PHONY: compose-logs compose-restartd compose-restart-forced compose-restart-force compose-restart compose-up compose-upd compose-down docker-build compose-build docker-build-force

compose-logs:
	docker compose logs -f 

compose-upd:
	docker compose up -d

compose-up: 
	docker compose up

compose-down:
	docker compose down 

compose-restart: compose-build compose-down compose-up

compose-restart-force: docker-build-force compose-down compose-up

compose-restartd: compose-build compose-down compose-upd

compose-restart-forced: docker-build-force compose-down compose-upd

compose-build:
	docker compose build 

docker-build-force:
	docker build --progress=plain --no-cache  -t simplews:latest --platform=linux/arm64 .

.PHONY: proto
proto: 
	mix protox.generate --output-path=./lib/simplews/proto/messages.ex --include-path=./proto ./proto/messages.proto
