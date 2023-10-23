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

      printf "Instance:    \"$(echo "$INST" | awk '{print toupper($0)}')\"\n"
      printf "Location:    `jq .location activeInstance` \n" 
      printf "Status:      `jq .status activeInstance` \n\n"
      printf "Current Release:  `jq .releaseVersion activeInstance` \n"
      jq -f sf-trust.jq activeInstance > relFile1 
      jq -s '.' < relFile1 > relFile2
      jq '. |= sort_by(.start)' relFile2 > relFile
      
      printf "Upcoming Releases:\n"
      
      len=`jq '. | length' relFile` 
      # printf "len: $len \n"

      for ((i=0; i<len; i++)); do
          # printf " i = $i \n"

        l_relStart=`jq -r --arg ij "$i" .[' $ij|tonumber '].start relFile`
        l_relName=`jq -r --arg ij "$i" .[' $ij|tonumber '].name relFile`
        l_relMaintId=`jq -r --arg ij "$i" .[' $ij|tonumber '].maintId relFile`
        l_relMaintStatus=`jq -r --arg ij "$i" .[' $ij|tonumber '].maintStatus relFile`

        printf "    $l_relStart - $l_relName (Id: $l_relMaintId, Status: $l_relMaintStatus) \n"

        # printf "`jq -r --arg ij "$i" .[' $ij|tonumber '].start relFile` - `jq -r --arg ij "$i" .[' $ij|tonumber '].name relFile` \n"
      done

      test -f relFile1 && rm relFile1
      test -f relFile2 && rm relFile2
      test -f relFile && rm relFile

    else

      printf "Instance $(echo "$INST" | awk '{print toupper($0)}') is not an active instance.\n"

    fi

  test -f sfTrustFile && rm sfTrustFile
  test -f activeInstance && rm activeInstance

  echo
  echo '/---------------------------/'
  echo

done
