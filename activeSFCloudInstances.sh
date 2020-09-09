#!/bin/bash

if [[ $# -eq 0 ]] ; then
    echo
    echo "This command expects one argument."
    echo 
    echo "Usage:   $0 production|sandbox"
    echo
    exit 1
fi

curl -sS https://api.status.salesforce.com/v1/instances/ -o tmpFile

jq -r --arg envType "$1" -f activeCountByEnvType.jq tmpFile > activeInst.log

printf "\nCount of active [$1] Cloud Instances:\n\n"

len=`jq '. | length' activeInst.log` 

for ((i=0; i<len; i++)); do
    printf "\t`jq -r --arg ij "$i" .[' $ij|tonumber '].Count activeInst.log`\t- `jq -r --arg ij "$i" .[' $ij|tonumber '].ProductCloud activeInst.log`\n"
done

echo
