#!/bin/bash

set -o errexit

# Validate required env vars
if [ "${AWS_ACCESS_KEY_ID}" == "" ]; then
  echo "Input AWS_ACCESS_KEY_ID cannot be empty"
  exit 1
fi
if [ "${AWS_SECRET_ACCESS_KEY}" == "" ]; then
  echo "Input AWS_SECRET_ACCESS_KEY cannot be empty"
  exit 1
fi
if [ "${AWS_DEFAULT_REGION}" == "" ]; then
  echo "Input AWS_DEFAULT_REGION cannot be empty"
  exit 1
fi
if [ "${INPUT_CDK_ACTION}" == "" ]; then
  echo "Input INPUT_CDK_ACTION cannot be empty"
  exit 1
fi
if [ "${INPUT_CDK_ENV}" == "" ]; then
  echo "Input INPUT_CDK_ENV cannot be empty"
  exit 1
fi
# relative to the root of the repo
if [ "${INPUT_PATH}" == "" ]; then
  INPUT_PATH="packages/infra"
  echo "Input INPUT_PATH not set, using default '${INPUT_PATH}'"
fi

# echo "Installing AWS CLI ..."
# curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
# unzip awscliv2.zip
# ./aws/install

# Configure AWS cli
aws configure set aws_access_key_id "${AWS_ACCESS_KEY_ID}"
aws configure set aws_secret_access_key "${AWS_SECRET_ACCESS_KEY}"
aws configure set default.region "${AWS_DEFAULT_REGION}"

## Install AWS CDK
[[ -z "${INPUT_CDK_VERSION}" ]] && npm install -g aws-cdk || npm install -g aws-cdk@"${INPUT_CDK_VERSION}"

cd "${GITHUB_WORKSPACE}/${INPUT_PATH}"
pwd

echo "CDK version: $(cdk --version)"
echo "Region: ${AWS_DEFAULT_REGION}"
echo "Env: ${INPUT_CDK_ENV}"
echo "Stack: ${INPUT_CDK_STACK}"
echo "Action: ${INPUT_CDK_ACTION}"

echo "CDK Bootstraping..."
cdk bootstrap -c env=${INPUT_CDK_ENV}
echo "...DONE CDK Bootstraping..."

# Run cdk for a specific stack
if [[ "${INPUT_CDK_STACK}" != '' ]]; then
  echo "Running action ${INPUT_CDK_ACTION} on stack ${INPUT_CDK_STACK}..."
  cdk ${INPUT_CDK_ACTION} -c env=${INPUT_CDK_ENV} ${INPUT_CDK_STACK}
  exit 0;
fi

echo "Running action ${INPUT_CDK_ACTION} on default stack..."
cdk ${INPUT_CDK_ACTION} -c env=${INPUT_CDK_ENV} --all