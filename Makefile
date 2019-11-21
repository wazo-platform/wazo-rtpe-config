.PHONY: dockerfile
dockerfile: docker-wazo-rtpe

.PHONY: docker-wazo-rtpe
docker-wazo-rtpe:
	docker build -t wazopbx/wazo-rtpe:latest -f Dockerfile .
