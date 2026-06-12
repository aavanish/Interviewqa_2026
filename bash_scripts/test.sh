#!/bin/bash
set -e 
echo "Checking Environment..."
command_version () {
	if ! command -v "$1" >/dev/null 2>&1; then
	 	echo "$1 is not installed"
		exit 1
	fi
       		echo "$1 is installed"
	}
command_version Docker
command_version Terraform


