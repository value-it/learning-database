#!/bin/sh

CURRENT_DIR=$(cd $(dirname $0); pwd)

cd $CURRENT_DIR/docker/learning-db

docker-compose -f docker-compose.yml up
