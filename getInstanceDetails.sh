#!/bin/bash
  
echo '/-------------------------------------------/'
echo
echo "   Salesforce Instance Lookup    "
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
    #printf "INST(domain): $INST\n"

    # if no domain match, search for direct instance name matches
    if [ -z ${INST} ]; then 
      INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | [ .key ] | @tsv'`
      #printf "INST(doc): $INST\n"
    fi
    
    if [ ${VARIN} != ${INST} ]; then 
      printf "MyDomain:    \"${VARIN}\"\n"
    fi
    
    # Lookup instance status details from SF Trust REST API
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o sfTrustFile

    jq '. | select(.isActive == true)' sfTrustFile > activeInstance

    if [ -s activeInstance ]; then

      jq . activeInstance
      
    else

      printf "Instance $(echo "$INST" | awk '{print toupper($0)}') is not an active instance.\n"

    fi

  test -f sfTrustFile && rm sfTrustFile
  test -f activeInstance && rm activeInstance

  echo
  echo '/---------------------------/'
  echo

done
