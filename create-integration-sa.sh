#!/bin/bash

PROJECT_ID=$1

# Set project for command-line tool
gcloud config set project $PROJECT_ID

# Update Project-id
sed -i "s~INSERT_PROJECT_ID~$PROJECT_ID~g" service-account.yaml

# Create deployment
gcloud deployment-manager deployments create ztmesh-deployment --config service-account.yaml
