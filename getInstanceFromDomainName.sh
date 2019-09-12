#!/bin/bash

clear
echo '/*********************************************/'
echo '/*   Salesforce Instance lookup by MyDomain  */'
echo '/*********************************************/'

while :
do
    echo
    printf 'Domain: '
    read domain_name
    printf 'Instance: '
    nslookup ${domain_name}.my.salesforce.com|egrep '^[cs|na|ap|eu]+\d+\.'|cut -d . -f 1
    echo
    read -n 1 -p "Press key to lookup another domain (q to quit)" key
    echo
    
    if [[ $key = q ]]
    then
        printf '\n\n'
        break
    fi
    
done