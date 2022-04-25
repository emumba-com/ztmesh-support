#!/bin/bash

VAR=$1

sed -i "s~my_key~$(gcloud secrets versions access "latest" --secret=my-$name)~g" /home/ubuntu/test.sh
echo $VAR > test2.txt
