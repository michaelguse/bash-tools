#!/bin/bash

l_procDateTime=`date "+%Y-%m-%d %H:%M:%S %Z"`

echo "Run Date: ${l_procDateTime}" > maintDiffOutput.log
echo >> maintDiffOutput.log

echo
echo '/--------------------------------------------------/'
echo "/                                                  /"
echo "/  JOB: Major Release defects on Trust             /"
echo "/                                                  /"
echo "/  AUTHOR: Michael Guse - mguse@salesforce.com     /"
echo "/                                                  /"
echo "/  RUN DATE: ${l_procDateTime}               /"
echo "/                                                  /"
echo '/--------------------------------------------------/'
echo

if [ -z "$1" ]
then
  curl -sS https://api.status.salesforce.com/v1/instances/ -o tmpFile
  jq -r -f listAllInst.jq tmpFile > sb-prod-list.txt
  IFS=$'\n' read -r -d '' -a arr  < sb-prod-list.txt
else
  arr=($@)
fi

let "ol=0"     # initialize instance counter
let "dupl=0"   # initialize duplicate counter

for var in ${arr[@]}; do
    # translate input variable to uppercase
    INST=$(echo "${var}" | awk '{print toupper($0)}')

    # Lookup instance status details from SF Trust REST API
    curl -sS "https://api.status.salesforce.com/v1/instances/${INST}/status?childProducts=false" -o sfTrustFile
    jq '. | select(.isActive == true)' sfTrustFile > activeInstance

    if [ -s activeInstance ]; then

      ((ol++))

      l_instance=$(echo "$INST" | awk '{print toupper($0)}')
      l_location=`jq .location activeInstance`
      l_status=`jq .status activeInstance`
      l_currRel=`jq .releaseVersion activeInstance`
      # Debug statement
      # printf "${l_instance}, ${l_location}, ${l_status}, ${l_currRel}\n"

      jq -f sfMRDefects.jq activeInstance > relFile1 
      jq -s '.' < relFile1 > relFile2
      jq '. |= sort_by(.start)' relFile2 > relFile
      
      len=`jq '. | length' relFile` 
      
      printf "$(echo "$INST" | awk '{print toupper($0)}') has (${len}) Major Release record(s)!\n\n"

      printf "  Instance:    \"${l_instance}\"\n"
      printf "  Location:    ${l_location} \n" 
      printf "  Status:      ${l_status} \n"
      printf "  Current Release:  ${l_currRel} \n\n"
      printf "  Upcoming Releases:\n"

      # Initialize compare variables for duplicate logic
      l_name_compare=""
      l_status_compare=""
      l_relStart_compare=""

      for ((i=0; i<len; i++)); do

        l_relStart=`jq -r --arg ij "$i" .[' $ij|tonumber '].start relFile`
        l_relName=`jq -r --arg ij "$i" .[' $ij|tonumber '].name relFile`
        l_relMaintId=`jq -r --arg ij "$i" .[' $ij|tonumber '].maintId relFile`
        l_relMaintStatus=`jq -r --arg ij "$i" .[' $ij|tonumber '].maintStatus relFile`

        printf "    $l_relStart - $l_relName (Id: $l_relMaintId, Status: $l_relMaintStatus)"
        
        # check for duplicate release entry        
        if [[ $l_relName == $l_name_compare && $l_relMaintStatus == $l_status_compare && $l_relStart == $l_relStart_compare ]]
        then
          printf "  <-- duplicate entry\n" 
          ((dupl++))
        else
          printf "\n"
        fi
        
        #Debug statements
        #printf "\nDebug Info:"
        #printf "\n  Before Name: $l_name_compare"
        #printf "\n  Before Status: $l_status_compare"
        #printf "\n"
        #printf "\n  After Name: $l_relName"
        #printf "\n  After Status: $l_relMaintStatus"

        l_name_compare=$l_relName
        l_status_compare=$l_relMaintStatus
        l_relStart_compare=$l_relStart

      done

      echo
      echo '/---------------------------/'
      echo

      if [ $len == 0 ]; then
        ((c0++))
      elif [ $len == 1 ]; then
        ((c1++))
      elif [ $len == 2 ]; then
        ((c2++))
      elif [ $len == 3 ]; then
        ((c3++))
      elif [ $len == 4 ]; then
        ((c4++))
      elif [ $len == 5 ]; then
        ((c5++))
      elif [ $len > 5 ]; then
        ((c5gt++))
      fi

      test -f relFile1 && rm relFile1
      test -f relFile2 && rm relFile2
      test -f relFile && rm relFile

    else

      printf "Instance $(echo "$INST" | awk '{print toupper($0)}') is not an active instance.\n"

    fi

  test -f sfTrustFile && rm sfTrustFile
  test -f activeInstance && rm activeInstance

done

printf "SUMMARY - ${l_procDateTime}\n"
printf "${ol} active instance(s) were checked for major release record issues.\n"
printf "${dupl} duplicate major release record entries were found.\n"
printf "\nDetails:\n"

if [ $c0 > 0 ]; then 
  printf "    ${c0} / ${ol} instance(s) with zero release records.\n"
fi
if [ $c1 > 0 ]; then 
  printf "    ${c1} / ${ol} instance(s) with one release record.\n"
fi
if [ $c2 > 0 ]; then 
  printf "    ${c2} / ${ol} instance(s) with two release records.\n"
fi
if [ $c3 > 0 ]; then 
  printf "    ${c3} / ${ol} instance(s) with three release records.\n"
fi
if [ $c4 > 0 ]; then 
  printf "    ${c4} / ${ol} instance(s) with four release records.\n"
fi
if [ $c5 > 0 ]; then 
  printf "    ${c5} / ${ol} instance(s) with five release records.\n"
fi
if [ $c5gt > 0 ]; then 
  printf "    ${c5gt} / ${ol} instance(s) with more than five release records.\n"
fi

printf "\n"

