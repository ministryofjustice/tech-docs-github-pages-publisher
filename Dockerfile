FROM docker.io/ruby:2.7.8-bullseye

ARG BUNDLE_RUBYGEMS__PKG__GITHUB__COM
ENV CONTAINER_USER="nonroot" \
  CONTAINER_UID="10000" \
  CONTAINER_GROUP="nonroot" \
  CONTAINER_GID="10000" \
  CONTAINER_HOME="/app" \
  DEBIAN_FRONTEND="noninteractive" \
  NODE_MAJOR="18"

RUN apt-get update && apt-get install -y build-essential git

RUN groupadd \
      --gid ${CONTAINER_GID} \
      --system \
      ${CONTAINER_GROUP} \
    && useradd \
      --uid ${CONTAINER_UID} \
      --gid ${CONTAINER_GROUP} \
      ${CONTAINER_USER} \
    && mkdir --parents ${CONTAINER_HOME} \
    && chown --recursive ${CONTAINER_USER}:${CONTAINER_GROUP} ${CONTAINER_HOME}

RUN apt-get install -y ca-certificates curl gnupg \
    && mkdir -p /etc/apt/keyrings \
    && echo "deb [signed-by=/etc/apt/keyrings/nodesource.gpg] https://deb.nodesource.com/node_$NODE_MAJOR.x nodistro main" | tee /etc/apt/sources.list.d/nodesource.list \
    && curl -fsSL https://deb.nodesource.com/gpgkey/nodesource-repo.gpg.key | gpg --dearmor -o /etc/apt/keyrings/nodesource.gpg \
    && apt-get update \
    && apt-get install -y nodejs

WORKDIR ${CONTAINER_HOME}

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Stash a copy of the config.rb, Gemfile and Gemfile.lock Middleman need these
# later, because documentation repos won't have them.
RUN mkdir /stashed-files
COPY config.rb Gemfile Gemfile.lock /stashed-files/

COPY scripts/* /scripts/
