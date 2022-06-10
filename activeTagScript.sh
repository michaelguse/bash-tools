#!/bin/bash

PROD='production'

curl -sS https://api.status.salesforce.com/v1/instances/ -o tmpFile

jq -r --arg envType "$PROD" -f activeTags.jq tmpFile > activeTagMap.log

# printf "\nCount of active [$PROD] Cloud Instances:\n\n"

len=`jq '. | length' activeTagMap.log` 

for ((i=0; i<len; i++)); do
    printf "\t`jq -r --arg ij "$i" .[' $ij|tonumber '].Count activeTagMap.log`\t- `jq -r --arg ij "$i" .[' $ij|tonumber '].TypeName activeTagMap.log`\n"
done

echo

exit 0