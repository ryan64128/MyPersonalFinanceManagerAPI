#!/bin/bash

read -p "Enter GitHub Owner: " GITHUB_OWNER
read -p "Enter GitHub Repo: " GITHUB_REPO
read -p "Enter GitHub Branch: " GITHUB_BRANCH
read -sp "Enter GitHub OAuth Token: " GITHUB_OAUTH_TOKEN
echo
LAMBDA_FUNCTION_NAME="financial-app-lambda"

aws cloudformation create-stack --stack-name MyPipelineStack \
  --template-body file://ci-cd-pipeline-stack.yaml \
  --parameters ParameterKey=GitHubOwner,ParameterValue=$GITHUB_OWNER \
               ParameterKey=GitHubRepo,ParameterValue=$GITHUB_REPO \
               ParameterKey=GitHubBranch,ParameterValue=$GITHUB_BRANCH \
               ParameterKey=GitHubOAuthToken,ParameterValue=$GITHUB_OAUTH_TOKEN \
               ParameterKey=LambdaFunctionName,ParameterValue=$LAMBDA_FUNCTION_NAME
