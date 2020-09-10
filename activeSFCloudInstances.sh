#!/bin/bash

PROD='production'
SB='sandbox'

curl -sS https://api.status.salesforce.com/v1/instances/ -o tmpFile

jq -r --arg envType "$PROD" -f activeCountByEnvType.jq tmpFile > activeInst.log

printf "\nCount of active [$PROD] Cloud Instances:\n\n"

len=`jq '. | length' activeInst.log` 

for ((i=0; i<len; i++)); do
    printf "\t`jq -r --arg ij "$i" .[' $ij|tonumber '].Count activeInst.log`\t- `jq -r --arg ij "$i" .[' $ij|tonumber '].ProductCloud activeInst.log`\n"
done

echo

jq -r --arg envType "$SB" -f activeCountByEnvType.jq tmpFile > activeInst.log

printf "\nCount of active [$SB] Cloud Instances:\n\n"

len=`jq '. | length' activeInst.log` 

for ((i=0; i<len; i++)); do
    printf "\t`jq -r --arg ij "$i" .[' $ij|tonumber '].Count activeInst.log`\t- `jq -r --arg ij "$i" .[' $ij|tonumber '].ProductCloud activeInst.log`\n"
done

echo

exit 0