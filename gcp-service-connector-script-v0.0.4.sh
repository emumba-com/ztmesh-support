#!/bin/bash

IDENTIFIER=$1
SERVICE_CONNECTOR_VERSION=$2
HOST_AGENT_INSTALL_SCRIPT_URL=$3
INSTALL_MONITORING_TOOLS=$4
LOG_LEVEL=$5

FILEPATH=/root/.host-agent

apt update -y

echo "Creating config.json in path: ${FILEPATH}"

mkdir -p $FILEPATH

cat >$FILEPATH/config.json << EOL
{
"id": "value_1",
"name": "value_2",
"login_config": {
    "access_key_id": "value_3",
    "secret_access_key": "value_4"
  },
"relay_config": {
    "relay": "value_5",
    "endpoint": "value_6",
    "id" : "value_8"   
  },
"site_config": {
    "id": "value_7"
  },
"status": false,
"logging": {
  "level": "${LOG_LEVEL}",
  "max_age": "",
  "max_size": "",
  "max_backups": "",
  "compress": ""
  },
"wc_url": "value_9",
"version": "${SERVICE_CONNECTOR_VERSION}",
"build_env": "value_10",
"aws_s3_bucket": "value_11"
}
EOL


sed -i "s~\"value_1\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-id)\"~g" $FILEPATH/config.json
sed -i "s~\"value_2\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-name)\"~g" $FILEPATH/config.json
sed -i "s~\"value_3\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-access-key-id)\"~g" $FILEPATH/config.json
sed -i "s~\"value_4\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-secret-access-key)\"~g" $FILEPATH/config.json
sed -i "s~\"value_5\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-relay-attach)\"~g" $FILEPATH/config.json
sed -i "s~\"value_6\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-relay-address)\"~g" $FILEPATH/config.json
sed -i "s~\"value_7\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-site-id)\"~g" $FILEPATH/config.json
sed -i "s~\"value_8\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-relay-id)\"~g" $FILEPATH/config.json
sed -i "s~\"value_9\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-wc-url)\"~g" $FILEPATH/config.json
sed -i "s~\"value_10\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-build_env)\"~g" $FILEPATH/config.json
sed -i "s~\"value_11\"~\"$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-aws_s3_bucket)\"~g" $FILEPATH/config.json
cat $FILEPATH/config.json

cat >$FILEPATH/instance_name << 'EOL'
instance_name
EOL

sed -i "s~instance_name~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-name)~g" $FILEPATH/instance_name

WEB_CONTROLLER_URL=$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-wc-url)

curl -L ${HOST_AGENT_INSTALL_SCRIPT_URL} | sudo bash -s -- -v ${SERVICE_CONNECTOR_VERSION} -u ${WEB_CONTROLLER_URL} -t ${INSTALL_MONITORING_TOOLS}
host-agent-cli start
