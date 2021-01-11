#!/bin/bash
clear

echo "|======================================================================"
echo "|==                                                                  "
echo "|==   Lookup of inactive Salesforce Sandbox instances                "
echo "|==                                                                  "
echo "|==   Run Date: `date "+%Y-%m-%d %H:%M:%S %Z"`                       "
echo "|==                                                                  "
echo "|======================================================================"
echo 
echo "isActive?, orgKey, releaseNumber, status, location, [createdAtDate]"

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r 'sort_by(.location, .key) | .[] | select(.isActive == false) | [.isActive, .key, .releaseNumber, .status, .location, .Tags[].InstanceTag.createdAt] | @csv'