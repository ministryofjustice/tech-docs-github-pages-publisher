FROM docker.io/ruby:3.3.5-alpine3.20

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Operations Engineering (operations-engineering@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Tech Docs GitHub Pages Publisher" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/tech-docs-github-pages-publisher"

ARG BUILD_BASE_VERSION="0.5-r3"
ARG GIT_VERSION="2.45.2-r0"
ARG NODEJS_VERSION="20.15.1-r0"
ARG BUNDLER_VERSION="2.5.22"

SHELL ["/bin/sh", "-e", "-u", "-o", "pipefail", "-c"]

COPY --chown="root:root" --chmod=0644 src/opt/publisher/ /opt/publisher/
COPY --chown="root:root" --chmod=0755 src/usr/local/bin/ /usr/local/bin/

WORKDIR /opt/publisher
RUN <<EOF
apk --update-cache --no-cache add \
  "build-base==${BUILD_BASE_VERSION}" \
  "git==${GIT_VERSION}" \
  "nodejs==${NODEJS_VERSION}"

gem install bundler --version "${BUNDLER_VERSION}"

bundle install
EOF
RUN

WORKDIR /tech-docs-github-pages-publisher
ENTRYPOINT ["/bin/sh"]
