#!/usr/bin/env bash
# exit on error
set -o errexit

bundle install
# Build Tailwind CSS
bundle exec rails tailwindcss:build

# Precompile assets
bundle exec rails assets:precompile
bundle exec rails assets:clean
bundle exec rails db:migrate
