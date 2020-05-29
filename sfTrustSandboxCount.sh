#!/bin/bash
clear

echo "List of active sandboxes from Salesforce Trust:"
echo 
echo "Instance,Release Version,Location,Status,Count"

if test -f sfTrustResult.new; then
  mv sfTrustResult.new sfTrustResult.old
fi

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r -f countAllInst.jq | awk '{printf("%s,%d\n", $0, NR)}' > sfTrustResult.new

cat sfTrustResult.new

diff sfTrustResult.new sfTrustResult.old > diffResult.txt

echo
if test -s diffResult.txt; then
  echo "Difference between current and last run results:"
  cat diffResult.txt
else
  echo "No changes detected!"
fi
echo

