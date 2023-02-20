#!/bin/bash
  
echo '/-------------------------------------------/'
echo
echo "   Salesforce Maintenance Lookup    "
echo
echo "   Input: "$@
echo
echo "   `date "+%Y-%m-%d %H:%M:%S %Z"`"
echo
echo '/-------------------------------------------/'
echo

for var in $@; do
    # translate input variable to uppercase
    VARIN=$(echo "${var}" | awk '{print toupper($0)}')

    # Search for domain match for input variable on SF Trust site via REST API
    INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | select(.aliasType == "domain") | [ .instanceKey ] | @tsv'`
    # printf "INST(domain): $INST\n"

    # if no domain match, search for direct instance name matches
    if [ -z ${INST} ]; then 
      INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | [ .key ] | @tsv'`
      # printf "INST(doc): $INST\n"
    fi
    
    if [ ! -z ${INST} ]; then

        if [ ${VARIN} != ${INST} ]; then 
          printf "MyDomain:    \"${VARIN}\"\n"
        fi

        # Lookup maintenance status details from SF Trust REST API
        curl -sS "https://api.status.salesforce.com/v1/maintenances?instance=${INST}" -o sfMaintFile 

        if [ -s sfMaintFile ]; then
            printf "Instance:    \"$(echo "$INST" | awk '{print toupper($0)}')\"\n"
            printf "Upcoming Releases:\n"
            jq -f sf-maint.jq < sfMaintFile
        else
            printf "Instance $(echo "$INST" | awk '{print toupper($0)}') is not an active instance.\n"
        fi

    else
        printf "Could not find ${VARIN} on Salesforce Trust website .\n"
    fi
    
  test -f sfMaintFile && rm sfMaintFile

  echo
  echo '/---------------------------/'
  echo

done