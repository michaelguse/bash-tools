#!/bin/bash

l_procDateTime=`date "+%Y-%m-%d %H:%M:%S %Z"`

echo "Run Date: ${l_procDateTime}" > maintDiffOutput.log
echo >> maintDiffOutput.log

echo
echo '/--------------------------------------------------/'
echo "/                                                  /"
echo "/  JOB: Maintenance Compare on Trust               /"
echo "/                                                  /"
echo "/  AUTHOR: Michael Guse - mguse@salesforce.com     /"
echo "/                                                  /"
echo "/  RUN DATE: ${l_procDateTime}               /"
echo "/                                                  /"
echo '/--------------------------------------------------/'
echo

_in=""

if [ -z "$1" ]
then
  curl -sS https://api.status.salesforce.com/v1/instances/ -o tmpFile
  jq -r -f listAllInst.jq tmpFile > sb-prod-list.txt
  IFS=$'\n' read -r -d '' -a arr  < sb-prod-list.txt
else
  arr=($1)
fi

for var in ${arr[@]}; do
    # translate input variable to uppercase
    VARIN=$(echo "${var}" | awk '{print toupper($0)}')

    # Search for domain match for input variable on SF Trust site via REST API
    INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | select(.aliasType == "domain") | [ .instanceKey ] | @tsv'`
    #printf "INST(domain): $INST\n"

    # if no domain match, search for direct instance name matches
    if [ -z ${INST} ]; then 
      INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | select(.isActive == true) | [ .key ] | @tsv'`
      #printf "INST(pod): $INST\n"
    fi

    # Lookup instance status details from SF Trust REST API
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o sfTrustFile

    jq '. | select(.isActive == true)' sfTrustFile > activeInstance
    jq '.Maintenances|sort_by(.id)' sfTrustFile > inst.sorted

    curl -sS "https://api.status.salesforce.com/v1/maintenances?instance=${INST}&limit=1000&offset=0" -o sfMaintFile

    jq '.|sort_by(.id)' sfMaintFile > maint.sorted
    
    diff maint.sorted inst.sorted > diffMaint

    if test -s diffMaint; then
      echo "==> $INST: Detected Maintenance differences between maintenance and instance route <==" >> maintDiffOutput.log
      echo  >> maintDiffOutput.log
      less diffMaint >> maintDiffOutput.log
      echo >> maintDiffOutput.log
    else
      echo "==> $INST: No maintenance differences detected between maintenance and instance route!" >> maintDiffOutput.log
    fi

    test -f activeInstance && rm activeInstance
    test -f sfTrustFile && rm sfTrustFile
    test -f sfMaintFile && rm sfMaintFile
    test -f inst.sorted && rm inst.sorted
    test -f maint.sorted && rm maint.sorted
    test -f diffMaint && rm diffMaint

done