#!/bin/bash

set -e

echo "Checking Environment..."

command -v docker >/dev/null || { echo "Docker not installed"; exit 1; }
command -v terraform >/dev/null || { echo "Terraform not installed"; exit 1; }

echo "Environment ready"
