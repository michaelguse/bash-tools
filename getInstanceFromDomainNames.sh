#!/bin/bash
  
echo
echo '/*************************************************************/'
echo '/*  Salesforce Instance lookup by MyDomain or Instance Name  */'
echo '/*************************************************************/'
echo 

for var in $@; do

    INST=`nslookup ${var}.my.salesforce.com | egrep -i '^[cs|na|ap|eu]+\d+\.'|cut -d . -f 1`

    if ( ${var} <> ${INST} ) then 
      printf "Domain Name: \"$(echo "${var}" | awk '{print toupper($0)}')\"\n"
    
    printf "Instance:    \"$(echo "$INST" | awk '{print toupper($0)}')\"\n"
    
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o sfTrustFile
    
    printf "Location:    `jq .location sfTrustFile` \n" 
    printf "Status:      `jq .status sfTrustFile` \n\n"
    printf "Current Release:  `jq .releaseVersion sfTrustFile` \n"
    jq -f ~/Desktop/sf-trust.jq sfTrustFile > relFile1 
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

    test -f sfTrustFile && rm sfTrustFile
    test -f relFile1 && rm relFile1
    test -f relFile2 && rm relFile2
    test -f relFile && rm relFile

done
