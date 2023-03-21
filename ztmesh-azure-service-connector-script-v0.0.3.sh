#!/bin/bash

INSTANCE_NAME=$1
VAULT_NAME=$2
SERVICE_CONNECTOR_VERSION=$3
HOST_AGENT_INSTALL_SCRIPT_URL=$4
INSTALL_MONITORING_TOOLS=$5
LOG_LEVEL=$6

FILEPATH=/root/.host-agent

apt update -y
apt install jq -y

# Get access token for Azure Vault audience
access_token=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r '.access_token')

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


sed -i "s~\"value_1\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_2\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/name?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_3\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/access-key-id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_4\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/secret-access-key?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_5\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/relay-attach?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_6\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/relay-address?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_7\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/site-id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_8\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/relay-id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_9\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/wc-url?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value10\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/build-env?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json
sed -i "s~\"value_11\"~\"$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/aws-s3-bucket?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')\"~g" $FILEPATH/config.json

cat $FILEPATH/config.json

cat >$FILEPATH/instance_name << 'EOL'
instance_name
EOL

sed -i "s~instance_name~${INSTANCE_NAME}~g" $FILEPATH/instance_name

WEB_CONTROLLER_URL=$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/wc-urld?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')

curl -L ${HOST_AGENT_INSTALL_SCRIPT_URL} | sudo bash -s ${SERVICE_CONNECTOR_VERSION} ${WEB_CONTROLLER_URL} ${INSTALL_MONITORING_TOOLS}
host-agent-cli start
