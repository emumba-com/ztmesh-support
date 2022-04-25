#!/bin/bash

sed -i "s~my_key~$(gcloud secrets versions access "latest" --secret=my-$name)~g" /home/ubuntu/test.sh
