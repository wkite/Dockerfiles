#!/bin/bash
set -ex
export DEBUG=${DEBUG:-false}
export ENTER_ENV=${ENTER_ENV:-false}
export PASSWORD=${PASSWORD:-default-password}
export RUN_AFTER_BUILD=${RUN_AFTER_BUILD:-false}

find $(dirname "$0")/alpine* -type f -name build.sh | while read SCRIPT; do
  $SCRIPT
done
