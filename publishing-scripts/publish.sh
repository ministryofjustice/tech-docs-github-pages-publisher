#!/bin/sh

# Publish the site by compiling source markdown files into HTML in the `/docs`
# directory, and pushing them to the `gh-pages` branch of the repo.

set -euo pipefail

main() {
  # Restore the stashed config.rb Gemfile and Gemfile.lock
  cp /stashed-files/* .

  compile_html
  check_for_broken_links
  set_git_credentials
  git_add_docs
  git_push
}

compile_html() {
  bundle exec middleman build --build-dir docs --relative-links
  touch docs/.nojekyll
}

check_for_broken_links() {
  # The site will usually have links to /[repo name] which will work when it's
  # hosted on github pages, but not in the local HTML files. So, we need to
  # exclude that string from the link checker.
  local readonly site_root=$(grep service_link config/tech-docs.yml | sed 's/service_link: //')

  bundle exec htmlproofer \
    --http-status-ignore 429 \
    --allow-hash-href \
    --url-ignore ${site_root} \
    ./docs
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
