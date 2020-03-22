#!/usr/bin/env bash

if [ -z "$1" ]; then
    echo "No argument supplied. Pass in terraform directory."
    exit 1
fi

TF_DIR = $1

# Install TFLint
curl -L "$(curl -Ls https://api.github.com/repos/terraform-linters/tflint/releases/latest | grep -o -E "https://.+?_linux_amd64.zip")" -o tflint.zip && unzip tflint.zip && rm tflint.zip

terraform init ${TF_DIR}
terraform validate ${TF_DIR}
tflint ${TF_DIR}
