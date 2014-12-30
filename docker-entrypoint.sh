#!/bin/bash
set -e

if [ "$1" = 'elasticsearch' ]; then
  chown -R elasticsearch:elasticsearch "$ESDATA"
  exec gosu elasticsearch "$@"
fi

exec "$@"
