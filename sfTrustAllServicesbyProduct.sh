#!/bin/zsh
clear

if test -f srv-prd-info.new; then
  mv srv-prd-info.new srv-prd-info.old
fi

l_procDateTime=`date "+%Y-%m-%d %H:%M:%S %Z"`

echo
echo '/--------------------------------------------------/'
echo "/                                                  /"
echo "/  JOB: List all Services by Products              /"
echo "/                                                  /"
echo "/  AUTHOR: Michael Guse - mguse@salesforce.com     /"
echo "/                                                  /"
echo "/  RUN DATE: ${l_procDateTime}               /"
echo "/                                                  /"
echo '/--------------------------------------------------/'
echo

curl -sS -X GET "https://api.status.salesforce.com/v1/services" -H "accept: application/json" -o srv-prd-info.new

if test -s srv-prd-info.new; then
  echo "Service and Product Statistics:"
  echo "  # of unique SF products: `jq '.[]|.Products[]|.key' srv-prd-info.new |sort|uniq|wc -l`"
  echo "  # of unique SF services: `jq '.[]|.key' srv-prd-info.new |sort|uniq|wc -l`"
  echo
fi

diff srv-prd-info.old srv-prd-info.new > srvprd_hasChanged

if test -s srvprd_hasChanged; then
  echo "==> Detected changes since last run! <=="
  echo 
  jq 'map(. as $in | .Products[].key | . as $p | {product:$p, service:$in.key}) | group_by(.product) | map({product:.[0].product, services: map(.service)})' srv-prd-info.new
  echo
else
  echo "No changes detected since last run!"
  echo
fi

exit 0