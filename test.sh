#!/bin/bash

name=$1
VAR=$2

sed -i "s~my_key~$(gcloud secrets versions access "latest" --secret=my-$name)~g" /home/ubuntu/test99.sh
echo $VAR > /etc/test2.txt
