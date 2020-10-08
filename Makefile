.PHONY: dockerfile
dockerfile: docker-wazo-rtpe

.PHONY: docker-wazo-rtpe
docker-wazo-rtpe:
	docker build -t wazoplatform/wazo-rtpe:latest -f Dockerfile .
