#!/bin/bash

for var in $@; do

    curl -sS https://api.status.salesforce.com/v1/instances/${var}/status | jq -r '. | [.isActive, .key, .releaseVersion, .status, .location] | @csv'

done