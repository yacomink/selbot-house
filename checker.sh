#!/bin/bash

set -u
set -e
# debug
#set -x

REPO_DIR='/buzzfeed/webapp'

# save everything after 'lib/header.js ' i.e. the args passed in to "runsel"
RUNNING=$(ps -a -o args| grep selenium2 | grep -v grep | head -1 | sed 's/.*lib\/header\.js \(.*\)/\1/')
BRANCH=$(cd $REPO_DIR && git symbolic-ref --short HEAD)
HOSTNAME=$(hostname -s)

if [ $RUNNING ]
then
    curl -s http://selbot-house.herokuapp.com/heartbeat/$HOSTNAME?running=$RUNNING\&branch=$BRANCH >> /dev/null
fi
