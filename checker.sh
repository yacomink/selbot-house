#!/bin/bash

RUNNING=$(ps a | grep selenium2 | fgrep -v grep | head -1 | awk '{ print $NF }')
BRANCH=$(cd /buzzfeed/webapp ; git branch  | fgrep '*' | awk '{ print $NF }')
HOSTNAME=$(hostname)

if [ $RUNNING ]
then
	curl -s http://selbot-house.herokuapp.com/$HOSTNAME?running=$RUNNING\&branch=$BRANCH >> /dev/null
fi
