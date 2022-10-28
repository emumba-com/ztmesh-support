#!/bin/bash

IDENTIFIER=$1
BUILD_ENV=$2
FILEPATH=/root/.host-agent

apt update -y

echo "Creating config.json in path: ${FILEPATH}"

mkdir -p $FILEPATH
cat >$FILEPATH/config.json << 'EOL'
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
  "wc_url": "value_9"
}
EOL


sed -i "s~value_1~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-id)~g" $FILEPATH/config.json
sed -i "s~value_2~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-name)~g" $FILEPATH/config.json
sed -i "s~value_3~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-access-key-id)~g" $FILEPATH/config.json
sed -i "s~value_4~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-secret-access-key)~g" $FILEPATH/config.json
sed -i "s~value_5~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-relay-attach)~g" $FILEPATH/config.json
sed -i "s~value_6~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-relay-address)~g" $FILEPATH/config.json
sed -i "s~value_7~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-site-id)~g" $FILEPATH/config.json
sed -i "s~value_8~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-relay-id)~g" $FILEPATH/config.json
sed -i "s~value_9~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-wc-url)~g" $FILEPATH/config.json
cat $FILEPATH/config.json

cat >$FILEPATH/instance_name << 'EOL'
instance_name
EOL

sed -i "s~instance_name~$(gcloud secrets versions access "latest" --secret=$IDENTIFIER-name)~g" $FILEPATH/instance_name

curl -L bit.ly/hostagent | sudo bash -s ${BUILD_ENV}
host-agent-cli start