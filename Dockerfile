#checkov:skip=CKV_DOCKER_2: HEALTHCHECK not required - Image does not run a web server
#checkov:skip=CKV_DOCKER_3: USER not required        - Image does not run in production, it is a utility

FROM docker.io/ruby@sha256:67f025f28e6c8ecb3338e023fd44fe853ab86c88b04fe780e2ff138b997857cd

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Operations Engineering (operations-engineering@digital.justice.gov.uk)" \
      org.opencontainers.image.title="Tech Docs GitHub Pages Publisher" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/tech-docs-github-pages-publisher"

ARG BUNDLER_VERSION="2.5.23"

SHELL ["/bin/sh", "-e", "-u", "-o", "pipefail", "-c"]

COPY --chown="root:root" --chmod=0644 src/opt/publisher/ /opt/publisher/
COPY --chown="root:root" --chmod=0755 src/usr/local/bin/ /usr/local/bin/

WORKDIR /opt/publisher
RUN <<EOF
apk --update-cache --no-cache add \
  build-base==0.5-r3 \
  git==2.45.2-r0 \
  nodejs==20.15.1-r0

gem install bundler --version "${BUNDLER_VERSION}"

bundle install

# Removes rexml 3.3.6 to address CVE-2024-49761
gem uninstall rexml --version 3.3.6 --install-dir /usr/local/lib/ruby/gems/3.3.0 --force
EOF

WORKDIR /tech-docs-github-pages-publisher
ENTRYPOINT ["/bin/sh"]
