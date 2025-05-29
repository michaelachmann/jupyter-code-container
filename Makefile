DOCKER_REPO=chaichy/jupyter-code-container
PLATFORM=linux/amd64

build-cpu:
	docker build $(BUILD_ARGS) \
	  --platform $(PLATFORM) \
	  -f docker/Dockerfile.cpu \
	  -t $(DOCKER_REPO):cpu .

build-gpu:
	docker build $(BUILD_ARGS) \
	  --platform $(PLATFORM) \
	  -f docker/Dockerfile.gpu \
	  -t $(DOCKER_REPO):gpu .

push-cpu:
	docker push $(DOCKER_REPO):cpu

push-gpu:
	docker push $(DOCKER_REPO):gpu

all: build-cpu build-gpu push-cpu push-gpu