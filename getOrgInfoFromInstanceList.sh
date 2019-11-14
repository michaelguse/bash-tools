#!/bin/bash

IFS=$'\n' read -ra arr -d '' <input.txt
source getOrgInfobyInstance.sh "${arr[@]}"