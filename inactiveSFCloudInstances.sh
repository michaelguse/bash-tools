#!/bin/bash

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r 'sort_by(.location, .key) | .[] | select(.isActive == false) | select(.releaseNumber == "") | [.isActive, .key, .releaseNumber, .status, .location, .Tags[].InstanceTag.createdAt] | @csv'