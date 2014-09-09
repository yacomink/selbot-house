#!/bin/bash

set -u
set -e
# debug
#set -x

REPO_DIR='/buzzfeed/webapp'

# TODO fix inaccurate results
# XXX only shows the last test in the list passed to runsel
RUNNING=$(ps a | grep selenium2 | fgrep -v grep | head -1 | awk '{ print $NF }')
BRANCH=$(cd $REPO_DIR && git symbolic-ref --short HEAD)
HOSTNAME=$(hostname -s)

if [ $RUNNING ]
then
    curl -s http://selbot-house.herokuapp.com/heartbeat/$HOSTNAME?running=$RUNNING\&branch=$BRANCH >> /dev/null
fi
