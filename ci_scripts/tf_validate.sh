#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "No argument supplied. Pass in terraform directory."
    exit 1
fi

TF_DIR = $1

terraform init ${TF_DIR}
terraform plan ${TF_VAR} -var="env=${CIRCLE_BRANCH}"
