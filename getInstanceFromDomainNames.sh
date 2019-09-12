#!/bin/bash
  
clear
echo '/*********************************************/'
echo '/*   Salesforce Instance lookup by MyDomain  */'
echo '/*********************************************/'

echo 

for var in $@; do
    printf "Domain/Instance: ${var} / "
    nslookup ${var}.my.salesforce.com|egrep '^[cs|na|ap|eu]+\d+\.'|cut -d . -f 1
done

echo
