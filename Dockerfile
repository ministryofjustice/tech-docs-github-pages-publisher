#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required - Image does not run a web server
#checkov:skip=CKV_DOCKER_3: USER not required        - Image does not run in production, it is a utility

FROM docker.io/ruby:3.3.8-alpine3.22@sha256:73ee3f4ab883b972df42ff9e393627bd4c09befd3a4ee7ce08ca9bfd62791b0c

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="GitHub Community (github-community@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Tech Docs GitHub Pages Publisher" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/tech-docs-github-pages-publisher"

ARG BUNDLER_VERSION="2.6.9"

SHELL ["/bin/sh", "-e", "-u", "-o", "pipefail", "-c"]

COPY --chown="root:root" --chmod=0644 src/opt/publisher/ /opt/publisher/
COPY --chown="root:root" --chmod=0755 src/usr/local/bin/ /usr/local/bin/

WORKDIR /opt/publisher
RUN <<EOF
apk --update-cache --no-cache add \
  build-base==0.5-r3 \
  git==2.49.0-r0 \
  nodejs==22.16.0-r2

gem install bundler --version "${BUNDLER_VERSION}"

bundle install
EOF

WORKDIR /tech-docs-github-pages-publisher
ENTRYPOINT ["/bin/sh"]
