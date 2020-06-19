#!/bin/bash
clear

if test -f sfTrustResult.new; then
  mv sfTrustResult.new sfTrustResult.old
fi

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r -f countAllInst.jq | awk '{printf("%s,%d\n", $0, NR)}' > sfTrustResult.new

echo
if test -s sfTrustResult.new; then
  echo "Number of active sandbox Instances: " && wc -l sfTrustResult.new | awk '{print $1}'
fi

diff sfTrustResult.old sfTrustResult.new > hasChanged
diff -y --left-column sfTrustResult.new sfTrustResult.old > diffResult.txt

echo
if test -s hasChanged; then
  echo "Instance,Release Version,Location,Status,Count"
  cat diffResult.txt
else
  echo "No changes detected!"
fi

echo

