FROM ruby:2.7.6-alpine3.15

# These are needed to support building native extensions during
# bundle install step
RUN apk --update add --virtual build_deps build-base git

RUN addgroup -g 1000 -S appgroup \
  && adduser -u 1000 --system appuser \
  && adduser appuser appgroup \
  && gem install bundler \
  && bundle config

# Required at runtime by middleman
RUN apk add --no-cache nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

# Stash a copy of the config.rb, Gemfile and Gemfile.lock Middleman need these
# later, because documentation repos won't have them.
RUN mkdir /stashed-files
COPY config.rb Gemfile Gemfile.lock /stashed-files/

RUN mkdir /publishing-scripts
COPY scripts/* /scripts/
