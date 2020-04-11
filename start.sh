#!/bin/sh
set -e

echo "wait 5 seconds for DB to be ready"
sleep 5

if [ "$APP_ENV" = "production" ] || [ "$APP_ENV" = "staging" ] ; then
  foreman start -f Procfile
else
  echo "We're in dev mode"

  echo "Starting dev server"
  # bundle exec puma  -p 3000 -C config/puma.rb
    echo "Starting Worker"
  # bundle exec sidekiq -C config/sidekiq.yml
  export RAILS_MAX_THREADS=25
  exec /usr/bin/supervisord
fi
