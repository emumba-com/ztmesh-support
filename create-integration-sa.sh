#!/bin/bash

PROJECT_ID=$1
ENV=$2

# Set project for command-line tool
gcloud config set project $PROJECT_ID

# Update Project-id
ENV=-$ENV
sed -i "s~INSERT_PROJECT_ID~$PROJECT_ID~g" service-account.yaml
sed -i "s~extreme-ztna-sa~extreme-ztna-sa$ENV~g" service-account.yaml

# Create deployment
gcloud deployment-manager deployments create ztmesh-deployment$ENV --config service-account.yaml
