FROM public.ecr.aws/docker/library/ruby:3.2.3-alpine3.19

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Operations Engineering" \
      org.opencontainers.image.title="Tech Docs GitHub Pages Publisher" \
      org.opencontainers.image.description="Container for build and packaging tech-docs" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/tech-docs-github-pages-publisher"

ENV PUBLISHER_DIRECTORY="/publisher" \
    BUNDLER_VERSION="2.5.6" \
    LYCHEE_VERSION="0.14.3"


# Install dependencies
RUN apk --update-cache --no-cache add \
      build-base \
      curl \
      git \
      nodejs

RUN install -dD -o root -g root -m 700 "${PUBLISHER_DIRECTORY}"

RUN gem install bundler --version "${BUNDLER_VERSION}"

RUN curl --location --fail-with-body \
      "https://github.com/lycheeverse/lychee/releases/download/v${LYCHEE_VERSION}/lychee-v${LYCHEE_VERSION}-x86_64-unknown-linux-musl.tar.gz" \
      --output lychee.tar.gz \
    && tar -xzf lychee.tar.gz \
    && install -o root -g root -m 775 lychee /usr/local/bin/lychee \
    && rm -f lychee.tar.gz

COPY src/usr/local/bin/ /usr/local/bin/

WORKDIR /opt/publisher

COPY src/opt/publisher/ /opt/publisher/

RUN bundle install

WORKDIR ${PUBLISHER_DIRECTORY}

ENTRYPOINT ["/bin/sh"]
