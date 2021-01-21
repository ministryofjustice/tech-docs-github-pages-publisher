#!/bin/sh

# Publish the site by compiling source markdown files into HTML in the `/docs`
# directory, and pushing them to the `gh-pages` branch of the repo.

set -euo pipefail

CONFIG_FILE=config/tech-docs.yml

main() {
  # Restore the stashed config.rb Gemfile and Gemfile.lock
  cp /stashed-files/* .

  compile_html
  check_for_broken_links
  if [ "${COMMIT_CHANGES}" == "yes" ]; then
    set_git_credentials
    git_add_docs
    git_push
  fi
}

compile_html() {
  # Export the ROOT_DOCPATH env. var which is required by the patched tech-docs
  # gem code
  export ROOT_DOCPATH=$(site_root)

  bundle exec middleman build --build-dir docs --relative-links
  touch docs/.nojekyll
}

check_for_broken_links() {

  bundle exec htmlproofer \
    --http-status-ignore 429 \
    --allow-hash-href \
    --url-ignore "$(site_root)" \
    --url-swap "$(url_swap):" \
    ./docs
}

# The site will usually have links to `/[repo name]` which will work when it's
# hosted on github pages, but not in the local HTML files. So, we need to
# exclude that string from the link checker.
site_root() {
  grep ^service_link: ${CONFIG_FILE} | sed 's/service_link: //'
}

# Convert the `host` value from `config/tech-docs.yml` to the form required in
# the --url-swap command-line parameter to htmlproofer
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

COMMIT_CHANGES=${1:-yes} # pass anything except "yes" to skip changes to the repo

main
