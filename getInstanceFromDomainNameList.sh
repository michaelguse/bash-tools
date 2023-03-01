#!/bin/bash

IFS=$'\n' read -ra arr -d '' <$1
source getInstanceFromDomainNames.sh "${arr[@]}"

# sample processing scripts for resulting output
#
# less test11.log | grep "has incorrect" | cut -f 1 -d " " > tworecs.log
# ./getInstanceFromDomainNameList.sh tworecs.log > tworecs-details
# less tworecs-details | grep "\- Summer" | cut -c 1-16 | sort | uniq