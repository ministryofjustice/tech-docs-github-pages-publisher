FROM docker.io/ruby:3.3.0-alpine3.19

ENV BUNDLER_VERSION="2.5.6"

RUN apk --update-cache --no-cache add \
      build-base \
      git \
      nodejs

RUN gem install bundler --version "${BUNDLER_VERSION}"

# Adding package and preview scripts
COPY bin/ /usr/local/bin/

# Copy Gemfile and Gemfile.lock, install gems and store them for packaging and preview scripts
WORKDIR /opt/publisher

COPY src/opt/publisher/ /opt/publisher/

RUN bundle install

WORKDIR /app

ENTRYPOINT ["/bin/sh"]
