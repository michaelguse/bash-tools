#!/bin/bash

j=0

while :
do

    clear

    j=$((j+1))

    echo '/-------------------------------------------/'
    echo
    printf "  Salesforce Instance Lookup #$j \n"
    echo
    echo "  `date "+%Y-%m-%d %H:%M:%S %Z"`"

    echo
    printf '  Name: '
    read var
    echo
    echo '/-------------------------------------------/'
    echo
    
    INST=`nslookup ${var}.my.salesforce.com | egrep -i '^[cs|na|ap|eu|um]+\d+\.'|cut -d . -f 1`

    if [ ${var} != ${INST} ] 
    then 
      printf "MyDomain:    \"$(echo "${var}" | awk '{print toupper($0)}')\"\n"
    fi
    
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o sfTrustFile

    jq '. | select(.isActive == true)' sfTrustFile > activeInstance

    if [ -s activeInstance ]; then

      printf "Instance:    \"$(echo "$INST" | awk '{print toupper($0)}')\"\n"
    
      printf "Location:    `jq .location activeInstance` \n" 
      printf "Status:      `jq .status activeInstance` \n\n"
      printf "Current Release:  `jq .releaseVersion activeInstance` \n"
      jq -f ~/Desktop/sf-trust.jq activeInstance > relFile1 
      jq -s '.' < relFile1 > relFile2
      jq '. |= sort_by(.start)' relFile2 > relFile
      
      printf "\nUpcoming Releases:\n"
      
      len=`jq '. | length' relFile` 
      # printf "len: $len \n"

      for ((i=0; i<len; i++)); do
          # printf " i = $i \n"
          printf "`jq -r --arg ij "$i" .[' $ij|tonumber '].start relFile` - `jq -r --arg ij "$i" .[' $ij|tonumber '].name relFile` \n"
      done

      test -f sfTrustFile && rm sfTrustFile
      test -f activeInstance && rm activeInstance
      test -f relFile1 && rm relFile1
      test -f relFile2 && rm relFile2
      test -f relFile && rm relFile

    else

      printf "Instance:    \"$(echo "$INST" | awk '{print toupper($0)}')\" is not an active instance.\n"

    fi

    printf "\n"

    read -n 1 -s -r -p "Press any key to continue or q to quit " key

    if [[ $key = q ]]
    then
        clear
        break
    fi

done