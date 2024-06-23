#!/bin/bash

# Set stack names
VPC_STACK_NAME="MyVPCStack"
RDS_STACK_NAME="MyRDSStack"

# Set template file paths
VPC_TEMPLATE_FILE="vpc-subnets.yaml"
RDS_TEMPLATE_FILE="rds.yaml"

# Database parameters
DB_INSTANCE_IDENTIFIER="userdatabase-instance"
DB_NAME="userdatabase"
DB_USERNAME="admin"
DB_PASSWORD="password"

# Function to create stack
create_stack() {
  local stack_name=$1
  local template_file=$2
  shift 2
  local parameters=$@

  echo "Creating stack $stack_name with template $template_file..."
  aws cloudformation create-stack --stack-name "$stack_name" --template-body "file://$template_file" \
    --parameters $parameters \
    --capabilities CAPABILITY_IAM CAPABILITY_NAMED_IAM

  echo "Waiting for stack $stack_name to be created..."
  aws cloudformation wait stack-create-complete --stack-name "$stack_name"

  if [ $? -eq 0 ]; then
    echo "Stack $stack_name created successfully."
  else
    echo "Failed to create stack $stack_name."
    exit 1
  fi
}

# Create VPC and subnets stack
create_stack "$VPC_STACK_NAME" "$VPC_TEMPLATE_FILE"

# Get outputs from VPC stack to use in RDS stack
VPC_ID=$(aws cloudformation describe-stacks --stack-name "$VPC_STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='VPCId'].OutputValue" --output text)
PUBLIC_SUBNET_ID=$(aws cloudformation describe-stacks --stack-name "$VPC_STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='PublicSubnetId'].OutputValue" --output text)
PRIVATE_SUBNET_ID=$(aws cloudformation describe-stacks --stack-name "$VPC_STACK_NAME" --query "Stacks[0].Outputs[?OutputKey=='PrivateSubnetId'].OutputValue" --output text)

# Print the parameter values to verify they are being retrieved correctly
echo "VPC_ID: $VPC_ID"
echo "PUBLIC_SUBNET_ID: $PUBLIC_SUBNET_ID"
echo "PRIVATE_SUBNET_ID: $PRIVATE_SUBNET_ID"

# Check if parameter values are empty
if [ -z "$VPC_ID" ] || [ -z "$PUBLIC_SUBNET_ID" ] || [ -z "$PRIVATE_SUBNET_ID" ]; then
  echo "One or more required parameters are missing. Exiting."
  exit 1
fi

# Create RDS stack
create_stack "$RDS_STACK_NAME" "$RDS_TEMPLATE_FILE" \
  "ParameterKey=VPCId,ParameterValue=$VPC_ID" \
  "ParameterKey=PublicSubnetId,ParameterValue=$PUBLIC_SUBNET_ID" \
  "ParameterKey=PrivateSubnetId,ParameterValue=$PRIVATE_SUBNET_ID" \
  "ParameterKey=DBInstanceIdentifier,ParameterValue=$DB_INSTANCE_IDENTIFIER" \
  "ParameterKey=DBName,ParameterValue=$DB_NAME" \
  "ParameterKey=DBUsername,ParameterValue=$DB_USERNAME" \
  "ParameterKey=DBPassword,ParameterValue=$DB_PASSWORD"

echo "All stacks created successfully."
