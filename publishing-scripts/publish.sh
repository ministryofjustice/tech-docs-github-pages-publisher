#!/bin/sh

# Publish the site by compiling source markdown files into HTML in the `/docs`
# directory, and pushing them to the `gh-pages` branch of the repo.

set -euo pipefail

main() {
  compile_html
  set_git_credentials
  git_add_docs
  git_push
}

compile_html() {
  # Restore the stashed config.rb Gemfile and Gemfile.lock
  cp /stashed-files/* .

  bundle exec middleman build --build-dir docs --relative-links
  touch docs/.nojekyll
}

set_git_credentials() {
  git config --global user.email "tools@digital.justice.gov.uk"
  git config --global user.name "Github Action"
}

git_add_docs() {
  git checkout -b gh-pages
  git add -f docs
  git commit -m "Published at $(date)"
}

git_push() {
  git push origin gh-pages --force
}

main
