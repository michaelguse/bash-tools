#!/bin/bash
clear

echo "|======================================================================"
echo "|=="
echo "|==   Lookup of listed Salesforce Sandbox instances"
echo "|=="
echo "|==   Input: $@"
echo "|=="
echo "|==   Run Date: `date "+%Y-%m-%d %H:%M:%S %Z"`"
echo "|=="
echo "|======================================================================"
echo 
echo "isActive?, orgKey, releaseNumber, status, location"

for var in $@; do

    curl -sS https://api.status.salesforce.com/v1/instances/${var}/status | jq -r '. | [.isActive, .key, .releaseVersion, .status, .location] | @csv'

done