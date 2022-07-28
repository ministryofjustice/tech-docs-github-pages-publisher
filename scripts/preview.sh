#!/bin/sh

# Allow documentation sites to preview what the site will look like when published.

set -euo pipefail

# Restore the stashed config.rb Gemfile and Gemfile.lock
cp /stashed-files/* .

bundle exec middleman serve
