#!/bin/bash

PROJECT_ID=$1
ENV=$2

GREEN="\e[32m"
RED="\e[31m"
ENDCOLOR="\e[0m"

# Set project for command-line tool
gcloud config set project $PROJECT_ID

# Update Project-id
ENV=-$ENV

# Create deployment
if `gcloud iam service-accounts list | grep -Fq ext-zta-sa$ENV`
then
  echo -e  "${GREEN}Service Account \"ext-zta-sa$ENV\" already exists. Please proceeed with the next steps...${ENDCOLOR}"
else
  if `gcloud deployment-manager deployments list --filter 'STATUS: DONE' | grep -Fq ztmesh-deployment$ENV`
  then
    echo -e  "${RED}Deployment \"ztmesh-deployment$ENV\" already exists. Please check the deployment status from Deployment Manager section. Delete deployment if status is \"FAILED\"! ${ENDCOLOR}"
  else
    sed -i "s~INSERT_PROJECT_ID~$PROJECT_ID~g" service-account.yaml
    sed -i "s~extreme-ztna-sa$~ext-zta-sa$ENV~g" service-account.yaml
    gcloud deployment-manager deployments create ztmesh-deployment$ENV --config service-account.yaml
  fi
fi
