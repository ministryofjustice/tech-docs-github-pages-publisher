FROM ruby:2.6-alpine

# These are needed to support building native extensions during
# bundle install step
RUN apk --update add --virtual build_deps build-base git

# Required at runtime by middleman
RUN apk add --no-cache nodejs

WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

# patch the installed gems
# see: https://github.com/alphagov/tech-docs-gem/issues/191
COPY gem-patches/*.patch /tmp/
RUN patch /usr/local/bundle/gems/middleman-search-gds-0.11.1/lib/middleman-search/search-index-resource.rb -i /tmp/search-index-resource.rb.patch
RUN patch /usr/local/bundle/gems/govuk_tech_docs-2.0.12/lib/assets/javascripts/_modules/search.js -i /tmp/search.js.patch
RUN mv /usr/local/bundle/gems/govuk_tech_docs-2.0.12/lib/assets/javascripts/_modules/search.js /usr/local/bundle/gems/govuk_tech_docs-2.0.12/lib/assets/javascripts/_modules/search.js.erb

# Stash a copy of the config.rb, Gemfile and Gemfile.lock We will need these
# later, because documentation repos won't have them.
RUN mkdir /stashed-files
COPY config.rb Gemfile Gemfile.lock /stashed-files/

RUN mkdir /publishing-scripts
COPY publishing-scripts/* /publishing-scripts/

