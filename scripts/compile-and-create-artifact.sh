#!/bin/sh

# Compile source markdown files into HTML in the `/docs` directory

set -x
set -euo pipefail

CONFIG_FILE=config/tech-docs.yml

main() {
  # Restore the stashed config.rb Gemfile and Gemfile.lock
  cp /stashed-files/* .

  bundle exec middleman build --build-dir docs --relative-links --verbose
  
  touch docs/.nojekyll
  
  bundle exec htmlproofer \
    --log-level debug \
    --allow-missing-href true \
    --swap-urls "$(url_swap):" \
    --ignore-urls "/https...github.com.ministryofjustice.*/" \
    ./docs

  tar --dereference --directory docs -cvf artifact.tar --exclude=.git --exclude=.github .
}


# Convert the `host` value from `config/tech-docs.yml` to the form required in
# the --swap-urls command-line parameter to htmlproofer
#
# e.g. https://ministryofjustice.github.io/modernisation-platform
#   => https?\:\/\/ministryofjustice\.github\.io\/modernisation-platform
#
# This is to prevent the link-checker from complaining about any links to pages
# which aren't yet published in the live version of the documentation website.
url_swap() {
  grep ^host: ${CONFIG_FILE} \
    | sed 's/host: //' \
    | sed 's/^http.*:/https\?\\:/' \
    | sed 's/\./\\./g' \
    | sed 's/\//\\\//g'
}

main
