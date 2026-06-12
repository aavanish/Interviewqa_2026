#!/bin/bash

set -e

terraform init
terraform plan -out=tfplan

read -p "Apply changes? (y/n): " ans
if [ "$ans" = "y" ]; then
	terraform apply tfplan
else 
	echo "Aborted"
fi
