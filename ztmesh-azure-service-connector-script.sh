#!/bin/bash

INSTANCE_NAME=$1
VAULT_NAME=$2
BUILD_ENV=$3
FILEPATH=/root/.host-agent

apt update -y
apt install jq -y

# Get access token for Azure Vault audience
access_token=$(curl -s 'http://169.254.169.254/metadata/identity/oauth2/token?api-version=2018-02-01&resource=https://vault.azure.net' -H Metadata:true | jq -r '.access_token')
RELAY_ATTACH=$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/relay-attach?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')

mkdir -p $FILEPATH
if [[ ${RELAY_ATTACH} == "y" ]]; then
  cat >$FILEPATH/config.json << 'EOL'
{
  "id": "value_1",
  "name": "value_2",
  "login_config": {
    "access_key_id": "value_3",
    "secret_access_key": "value_4"
  },
  "relay_config": {
    "relay": "y",
    "relay_address": "value_5"
  },
  "site_config": null
}
EOL

  sed -i "s~value_1~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_2~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/name?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_3~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/access-key-id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_4~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/secret-access-key?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_5~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/relay-address?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json

elif [[ ${RELAY_ATTACH} == "n" ]]; then
  cat >$FILEPATH/config.json << 'EOL'
{
  "id": "value_1",
  "name": "value_2",
  "login_config": {
    "access_key_id": "value_3",
    "secret_access_key": "value_4"
  },
  "relay_config": {
    "relay": "n",
    "relay_address": ""
  },
  "site_config": {
    "id": "value_5"
  }
}
EOL

  sed -i "s~value_1~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_2~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/name?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_3~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/access-key-id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_4~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/secret-access-key?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json
  sed -i "s~value_5~$(curl -s "https://${VAULT_NAME}.vault.azure.net/secrets/site-id?api-version=2016-10-01" -H "Authorization: Bearer $access_token" | jq -r '.value')~g" $FILEPATH/config.json

fi

cat >$FILEPATH/instance_name << 'EOL'
instance_name
EOL

sed -i "s~instance_name~${INSTANCE_NAME}~g" $FILEPATH/instance_name

curl -L bit.ly/hostagent | sudo bash -s ${BUILD_ENV}
host-agent-cli start
