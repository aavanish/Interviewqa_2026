#!/bin/bash

CONTAINER="flask-api"

if ! docker ps | grep $CONTAINER; then
	echo "Container down, restarting..."
	docker start $CONTAINER

fi
