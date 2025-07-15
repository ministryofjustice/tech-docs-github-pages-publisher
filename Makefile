.PHONY: build test package preview scan copy-gemlock exec

IMAGE_NAME ?= ghcr.io/ministryofjustice/tech-docs-github-pages-publisher
IMAGE_TAG  ?= local

TRIVY_DB_REPOSITORY ?= public.ecr.aws/aquasecurity/trivy-db:2
TRIVY_JAVA_DB_REPOSITORY ?= public.ecr.aws/aquasecurity/trivy-java-db:1

build:
	@ARCH=`uname --machine`; \
	case $$ARCH in \
	aarch64 | arm64) \
		echo "Building on $$ARCH architecture"; \
		docker build --platform linux/amd64 --file Dockerfile --tag $(IMAGE_NAME):$(IMAGE_TAG) . ;; \
	*) \
		echo "Building on $$ARCH architecture"; \
		docker build --file Dockerfile --tag $(IMAGE_NAME):$(IMAGE_TAG) . ;; \
	esac

test: build
	container-structure-test test --platform linux/amd64 --config test/container-structure-test.yml --image $(IMAGE_NAME):$(IMAGE_TAG)

exec: build
	docker run -it --rm $(IMAGE_NAME):$(IMAGE_TAG)

package: build
	docker run --rm \
	    --name tech-docs-github-pages-publisher \
	    --volume $(PWD)/test/test-docs-example/config:/tech-docs-github-pages-publisher/config \
		--volume $(PWD)/test/test-docs-example/source:/tech-docs-github-pages-publisher/source \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		/usr/local/bin/package

preview: build
	docker run -it --rm \
	    --name tech-docs-github-pages-publisher-preview \
	    --volume $(PWD)/test/test-docs-example/config:/tech-docs-github-pages-publisher/config \
		--volume $(PWD)/test/test-docs-example/source:/tech-docs-github-pages-publisher/source \
		--publish 4567:4567 \
		$(IMAGE_NAME):$(IMAGE_TAG) \
		/usr/local/bin/preview

scan: build
	trivy image --platform linux/amd64 --severity HIGH,CRITICAL $(IMAGE_NAME):$(IMAGE_TAG)

copy-gemlock: build
	docker create --name tech-docs-github-pages-publisher-tmp $(IMAGE_NAME):$(IMAGE_TAG)
	docker container cp tech-docs-github-pages-publisher-tmp://opt/publisher/Gemfile.lock src/opt/publisher/Gemfile.lock
	docker rm tech-docs-github-pages-publisher-tmp
