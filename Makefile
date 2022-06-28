.PHONY: build serve

DOCKER_IMAGE := thibaultmorin/zola:0.15.3
PROJECT_ROOT="$$(git rev-parse --show-toplevel)"
NETLIFY_SITE_ID := nimble-cendol-7b9d2e

.PHONY: serve
serve:
	docker run -u "$(id -u):$(id -g)" \
	-v ${PROJECT_ROOT}:/app \
	--workdir /app \
	-p 8080:8080 -p 1024:1024 \
	${DOCKER_IMAGE} serve --interface 0.0.0.0 --port 8080 --base-url localhost

.PHONY: build
build:
	docker run -u "$(id -u):$(id -g)" \
	-v ${PROJECT_ROOT}:/app \
	--workdir /app \
	${DOCKER_IMAGE} build


.PHONY: deploy
deploy:
	zip -r public.zip public
	curl -H "Content-Type: application/zip" \
	-H "Authorization: Bearer ${NETLIFY_AUTH_TOKEN}" \
	--data-binary "@public.zip" \
	https://api.netlify.com/api/v1/sites/${NETLIFY_SITE_ID}.netlify.com/deploys
