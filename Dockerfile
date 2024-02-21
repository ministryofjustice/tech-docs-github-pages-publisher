FROM public.ecr.aws/docker/library/ruby:3.2.3-alpine3.19

LABEL org.opencontainers.image.vendor="Ministry of Justice" \
      org.opencontainers.image.authors="Operations Engineering" \
      org.opencontainers.image.title="Tech Docs GitHub Pages Publisher" \
      org.opencontainers.image.description="Container for build and packaging tech-docs" \
      org.opencontainers.image.url="https://github.com/ministryofjustice/tech-docs-github-pages-publisher"

ENV CONTAINER_GID="1000" \
    CONTAINER_GROUP="publisher" \
    CONTAINER_UID="1000" \
    CONTAINER_USER="publisher" \
    CONTAINER_HOME="/publisher" \
    BUNDLER_VERSION="2.5.6" \
    LYCHEE_VERSION="0.14.3"

RUN addgroup \
      --gid ${CONTAINER_GID} \
      --system \
      ${CONTAINER_GROUP} \
    && adduser \
      --uid ${CONTAINER_UID} \
      --ingroup ${CONTAINER_GROUP} \
      --disabled-password \
      ${CONTAINER_USER} \
    && install -dD -o ${CONTAINER_USER} -g ${CONTAINER_GROUP} -m 700 ${CONTAINER_HOME}

RUN apk --update-cache --no-cache add \
      build-base \
      curl \
      git \
      nodejs

RUN gem install bundler --version ${BUNDLER_VERSION} \
    && bundle config

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

WORKDIR ${CONTAINER_HOME}

USER ${CONTAINER_USER}

ENTRYPOINT ["/bin/sh"]
