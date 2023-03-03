#!/bin/bash

IFS=$'\n' read -ra arr -d '' <$1
source getInstanceFromDomainNames.sh "${arr[@]}"
