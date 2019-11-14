#!/bin/bash
  
echo
echo '/*********************************************/'
echo '/*   Salesforce Instance lookup by MyDomain  */'
echo '/*********************************************/'
echo 

for var in $@; do

    printf "Domain Name: \"$(echo "${var}" | awk '{print toupper($0)}')\"\n"
    INST=`nslookup ${var}.my.salesforce.com|egrep '^[cs|na|ap|eu]+\d+\.'|cut -d . -f 1`
    printf "Instance:    \"$(echo "$INST" | awk '{print toupper($0)}')\"\n"
    
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o tmpFile
    
    printf "Location:    `jq .location tmpFile` \n" 
    printf "Status:      `jq .status tmpFile` \n\n"
    printf "Current Release:  `jq .releaseVersion tmpFile` \n"
    jq -f ~/Desktop/sf-trust.jq tmpFile > relFile1 
    jq -s '.' < relFile1 > relFile2
    jq '. |= sort_by(.start)' relFile2 > relFile
    
    printf "Upcoming Releases:\n"
    
    len=`jq '. | length' relFile` 
    # printf "len: $len \n"

    for ((i=0; i<len; i++)); do
        # printf " i = $i \n"
        printf "   "
        jq --arg ij "$i" .[' $ij|tonumber '].name relFile
        printf "   "
        jq --arg ij "$i" .[' $ij|tonumber '].start relFile
        printf "\n"
    done
    
    printf "\n"

    test -f tmpFile && rm tmpFile
    test -f relFile1 && rm relFile1
    test -f relFile2 && rm relFile2
    test -f relFile && rm relFile

done
