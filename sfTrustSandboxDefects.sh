#!/bin/bash
  
echo
echo '/--------------------------------------------------/'
echo "/                                                  /"
echo "/  JOB: Sandbox Major Release defects on Trust     /"
echo "/                                                  /"
echo "/  AUTHOR: Michael Guse - mguse@salesforce.com     /"
echo "/                                                  /"
echo "/  RUN DATE: `date "+%Y-%m-%d %H:%M:%S %Z"`               /"
echo "/                                                  /"
echo '/--------------------------------------------------/'
echo

IFS=$'\n' read -ra arr -d '' <$1

let "il=0"
let "ol=0"

for var in ${arr[@]}; do
    # translate input variable to uppercase
    VARIN=$(echo "${var}" | awk '{print toupper($0)}')

    # Search for domain match for input variable on SF Trust site via REST API
    INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | select(.aliasType == "domain") | [ .instanceKey ] | @tsv'`
    #printf "INST(domain): $INST\n"

    # if no domain match, search for direct instance name matches
    if [ -z ${INST} ]; then 
      INST=`curl -sS "https://api.status.salesforce.com/v1/search/${VARIN}" | jq -r '.[] | select(.type == "doc") | [ .key ] | @tsv'`
      #printf "INST(doc): $INST\n"
    fi
    
    # Lookup instance status details from SF Trust REST API
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o sfTrustFile

    jq '. | select(.isActive == true)' sfTrustFile > activeInstance

    if [ -s activeInstance ]; then

      ((ol++))

      l_instance=$(echo "$INST" | awk '{print toupper($0)}')
      l_location=`jq .location activeInstance`
      l_status=`jq .status activeInstance`
      l_currRel=`jq .releaseVersion activeInstance`
      # printf "${l_instance}, ${l_location}, ${l_status}, ${l_currRel}\n"

      jq -f sfMRDefects.jq activeInstance > relFile1 
      jq -s '.' < relFile1 > relFile2
      jq '. |= sort_by(.start)' relFile2 > relFile
      
      len=`jq '. | length' relFile` 
      # printf "len: $len \n"
 
      if [ $len != 3 ]; then

        ((il++))
        
        printf "$(echo "$INST" | awk '{print toupper($0)}') has incorrect number (${len}) of Major Release records!\n\n"

        if [ ${VARIN} != ${INST} ]; then 
            printf "  MyDomain:    \"${VARIN}\"\n"
        fi
        printf "  Instance:    \"${l_instance}\"\n"
        printf "  Location:    ${l_location} \n" 
        printf "  Status:      ${l_status} \n"
        printf "  Current Release:  ${l_currRel} \n\n"
        printf "  Upcoming Releases:\n"
        for ((i=0; i<len; i++)); do
          # printf " i = $i \n"
          printf "    `jq -r --arg ij "$i" .[' $ij|tonumber '].start relFile` - `jq -r --arg ij "$i" .[' $ij|tonumber '].name relFile` \n"
        done

        echo
        echo '/---------------------------/'
        echo

      fi

      test -f relFile1 && rm relFile1
      test -f relFile2 && rm relFile2
      test -f relFile && rm relFile

    # else

      # printf "Instance $(echo "$INST" | awk '{print toupper($0)}') is not an active instance.\n"

    fi

  test -f sfTrustFile && rm sfTrustFile
  test -f activeInstance && rm activeInstance

done

printf "SUMMARY: ${il} / ${ol} instance(s) with major release record issues.\n"
