#!/bin/bash

PROJECT_ID=$1
ENV=$2
WORKSPACE_ID=$3

GREEN="\e[32m"
RED="\e[31m"
ENDCOLOR="\e[0m"

# Set project for command-line tool
gcloud config set project $PROJECT_ID

# Update Project-id
SUBDOMAIN=$ENV
ENV=-$ENV

# Create bucket
if `gcloud storage buckets list | grep -Fq extreme-zta-bucket$ENV-${WORKSPACE_ID}`
then
  echo -e  "${GREEN}Cloud Bucket \"extreme-zta-bucket$ENV-${WORKSPACE_ID}\" already exists. Please proceeed with the next steps...${ENDCOLOR}"
else
  if `gcloud deployment-manager deployments list --filter 'STATUS: DONE' | grep -Fq extreme-zta-bucket$ENV-${WORKSPACE_ID}`
  then
    echo -e  "${RED}Deployment \"extreme-zta-bucket$ENV-${WORKSPACE_ID}\" already exists. Please check the deployment status from Deployment Manager section. Delete deployment if status is \"FAILED\"! ${ENDCOLOR}"
  else
    sed -i "s~extreme-zta-bucket$~extreme-zta-bucket$ENV-${WORKSPACE_ID}~g" create-bucket.yaml
    gcloud deployment-manager deployments create extreme-zta-bucket$ENV-${WORKSPACE_ID} --config create-bucket.yaml
    sed "s~webhook-domain-here~$SUBDOMAIN~g" webhook-function.py > main.py
    zip function-code.zip main.py requirements.txt
    gsutil cp function-code.zip gs://extreme-zta-bucket$ENV-${WORKSPACE_ID}/
    gsutil acl ch -u AllUsers:R gs://extreme-zta-bucket$ENV-${WORKSPACE_ID}/function-code.zip
    echo -e  "${GREEN}ZIP Archive URL: gs://extreme-zta-bucket$ENV-${WORKSPACE_ID}/function-code.zip${ENDCOLOR}"
  fi
fi
