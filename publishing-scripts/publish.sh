#!/bin/sh

# Publish the site by compiling source markdown files into HTML in the `/docs`
# directory, and pushing them to the `gh-pages` branch of the repo.

set -euo pipefail

# There are a couple of cases where links will appear to be broken:
#
# 1. There is a `View source` link on every page, which will be broken for any
#    files that have not yet been merged into the default branch of the
#    documentation repo.
# 2. If the documentation includes a link to any private repositories, those
#    links will seem to be broken, from the link-checker's POV.
#
# To avoid these problems, we tell the link-checker to ignore any links that
# point to MoJ GitHub entities.
MOJ_GITHUB=/https...github.com.ministryofjustice.*/

CONFIG_FILE=config/tech-docs.yml

CHROME_USER_AGENT="Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/88.0.4324.150 Safari/537.36"

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

  bundle exec middleman build --build-dir docs --relative-links
  
  touch docs/.nojekyll
}

check_for_broken_links() {
  bundle exec htmlproofer \
    --log-level debug \
    --ignore-status-codes 0,429,403 \
    --allow-hash-href \
    --ignore-urls "${MOJ_GITHUB},$(site_root)" \
    --swap-urls "$(url_swap):" \
    --typhoeus "{\"headers\":{\"User-Agent\":\"${CHROME_USER_AGENT}\"}}" \
    ./docs
}

# The site will usually have links to `/[repo name]` which will work when it's
# hosted on github pages, but not in the local HTML files. So, we need to
# exclude that string from the link checker.
# This will put // in front of the string for service_link in tech-docs.yml file.
# ie if it is /#[repo name] it becomes //[repo name]
# ie if it is /[repo name] it becomes //[repo name]
site_root() {
  grep ^service_link: ${CONFIG_FILE} | sed 's/service_link: //'
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
