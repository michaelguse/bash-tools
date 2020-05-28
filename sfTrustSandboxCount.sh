#!/bin/bash

echo "List of active sandboxes from Salesforce Trust:"
echo 
echo "Count#, Instance, Release Version, Location, Status"

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r -f countAllInst.jq | nl -ba -s ','

