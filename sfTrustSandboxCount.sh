#!/bin/bash

echo "List of active sandboxes from Salesforce Trust:"
echo 
echo "Instance,Release Version,Location,Status,Count"

if test -f sfTrustResult.new; then
  mv sfTrustResult.new sfTrustResult.old
fi

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r -f countAllInst.jq | awk '{printf("%s,%d\n", $0, NR)}' > sfTrustResult.new

cat sfTrustResult.new

echo
echo "Difference between current and last run results:"
diff sfTrustResult.new sfTrustResult.old

