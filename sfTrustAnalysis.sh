#!/bin/bash

if [ $# -eq 0 ]; then
    >&2 echo "No arguments provided"
    >&2 echo 
    >&2 echo "Usage: sfTrustAnanlysis.sh [1-5]"
    exit 1
fi

echo '/-------------------------------------------/'
echo
echo "   Salesforce Trust ISsues - Analysis"
echo
echo "   Input: "$@
echo
echo "   `date "+%Y-%m-%d %H:%M:%S %Z"`"
echo
echo '/-------------------------------------------/'
echo


for numerrors in $@; do

    less sfTrustIssues.log | grep "has incorrect number (${numerrors})" | cut -f 1 -d " " > sfTrustErrors.tmp

    if test -s sfTrustErrors.tmp; then
        echo "Instances with ${numerrors} major release records:"
        echo 
        ./getInstanceFromDomainNameList.sh sfTrustErrors.tmp > details-${numerrors}-errors.tmp
        
        if test -s details-${numerrors}-errors.tmp; then
            echo "Summer '23 release errors"
            less details-${numerrors}-errors.tmp | grep "\- Summer '23" | cut -c 1-16 | sort | uniq -c
            echo
        fi
    fi

    test -f sfTrustErrors.tmp && rm sfTrustErrors.tmp
    test -f details-${numerrors}-errors.tmp && rm details-${numerrors}-errors.tmp

done

exit 0