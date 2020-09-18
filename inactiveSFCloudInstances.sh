#!/bin/bash

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r '.[] | select(.isActive == false) | select(.releaseNumber == "") | [.isActive, .key, .releaseNumber, .status, .location] | @csv'