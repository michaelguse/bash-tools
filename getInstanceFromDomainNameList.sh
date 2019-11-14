#!/bin/bash

IFS=$'\n' read -ra arr -d '' <input.txt
source getInstanceFromDomainNames.sh "${arr[@]}"