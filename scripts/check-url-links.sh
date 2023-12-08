#!/usr/bin/env bash

set -x
set -euo pipefail

# Restore the stashed config.rb Gemfile and Gemfile.lock
cp /stashed-files/* .

# Compile source markdown files into HTML in the `/docs` directory
bundle exec middleman build --build-dir docs --relative-links --verbose

# Check all URLs 
htmlproofer \
  --log-level debug \
  --allow-missing-href true \
  --typhoeus '{"connecttimeout": 10, "timeout": 30, "accept_encoding": "zstd,br,gzip,deflate" }' \
  --ignore-files "/.\/docs\/search\/index.html/" \
  ./docs