#!/bin/bash
set -e


if [ "$1" = "$NAME" ]; then
  NAME='elasticsearch'

  MAX_OPEN_FILES=65535

  # From the elasticsearch init files
  ES_HOME=/usr/share/$NAME
  LOG_DIR="$ES_DATA/log"
  DATA_DIR="$ES_DATA/data"

  # Those are just defaults, they can be overriden with -Des.config=...
  CONF_DIR=/etc/$NAME
  CONF_FILE=$CONF_DIR/elasticsearch.yml

  WORK_DIR=/tmp/$NAME

  OPTS="--default.config=$CONF_FILE --default.path.home=$ES_HOME --default.path.logs=$LOG_DIR --default.path.data=$DATA_DIR --default.path.work=$WORK_DIR --default.path.conf=$CONF_DIR"
  mkdir -p "$LOG_DIR" "$DATA_DIR" "$WORK_DIR" && chown -R "$ES_USER":"$ES_GROUP" "$LOG_DIR" "$DATA_DIR" "$WORK_DIR"

  if [ -n "$MAX_OPEN_FILES" ]; then
    ulimit -n $MAX_OPEN_FILES
  fi

  shift
  exec gosu "$ES_USER:$ES_GROUP" "$NAME" $OPTS "$@"
fi

exec "$@"
