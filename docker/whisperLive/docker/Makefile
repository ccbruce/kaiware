all: build

help:
		@echo ""
		@echo "-- Help Menu"
		@echo ""
		@echo "   1. make build		- build the whisper-live image"
		@echo "   2. make quickstart   - start whisper-live"
		@echo "   3. make stop		 - stop whisper-live"
		@echo "   4. make logs		 - view logs"
		@echo "   5. make purge		- stop and remove the container"

build:
		@docker build --tag=kingasiagroup/whisper-live:$(shell cat VERSION) . \
				--build-arg BUILD_DATE="$(shell date +"%Y-%m-%d %H:%M:%S%:z")" \
				--build-arg VCS_REF=$(shell git rev-parse --short HEAD)
		@docker push kingasiagroup/whisper-live:$(shell cat VERSION)

release: build
		@docker build --tag=kingasiagroup/whisper-live:$(shell cat VERSION) . \
				--build-arg BUILD_DATE="$(shell date +"%Y-%m-%d %H:%M:%S%:z")" \
				--build-arg VCS_REF=$(git describe --tags --always)
		@docker push kingasiagroup/whisper-live:$(shell cat VERSION)

quickstart:
		@echo "Starting postgresql container..."
		@docker run --name=gitlab-postgresql -d \
				--env='DB_NAME=gitlabhq_production' \
				--env='DB_USER=gitlab' --env='DB_PASS=password' \
				kingasiagroup/postgresql:latest
		@echo "Starting redis container..."
		@docker run --name=gitlab-redis -d \
				kingasiagroup/redis:latest
		@echo "Starting gitlab container..."
		@docker run --name='gitlab-demo' -d \
				--link=gitlab-postgresql:postgresql --link=gitlab-redis:redisio \
				--publish=10022:22 --publish=10080:80 \
				--env='GITLAB_PORT=10080' --env='GITLAB_SSH_PORT=10022' \
				kingasiagroup/gitlab:latest
		@echo "Please be patient. This could take a while..."
		@echo "GitLab will be available at http://localhost:10080"
		@echo "Type 'make logs' for the logs"

stop:
		@echo "Stopping gitlab..."
		@docker stop gitlab-demo >/dev/null
		@echo "Stopping redis..."
		@docker stop gitlab-redis >/dev/null
		@echo "Stopping postgresql..."
		@docker stop gitlab-postgresql >/dev/null

purge: stop
		@echo "Removing stopped containers..."
