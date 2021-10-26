#!/bin/bash

j=0

while :
do

    clear

    j=$((j+1))

    echo '///------------------------------------------------///'
    echo
    printf "   Salesforce Interactive Instance Lookup #$j \n"
    echo
    printf '   Name: '
    read var
    echo

    ./getInstanceFromDomainNames.sh ${var}

    printf "\n"

    read -n 1 -s -r -p "Press any key to continue or q to quit " key

    if [[ $key = q ]]
    then
        clear
        break
    fi

done