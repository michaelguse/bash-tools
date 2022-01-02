#!/bin/bash
  
echo
echo '/--------------------------------------------------/'
echo "/                                                  /"
echo "/  JOB: Monitor JWST temperature points            /"
echo "/                                                  /"
echo "/  AUTHOR: Michael Guse - guse.michael@gmail.com   /"
echo "/                                                  /"
echo "/  RUN DATE: `date "+%Y-%m-%d %H:%M:%S %Z"`               /"
echo "/                                                  /"
echo '/--------------------------------------------------/'
echo

curl -sS https://api.jwst-hub.com/track -o jwstOut

jq -r -f jwstTempCheck.jq jwstOut | awk '{printf("%s\n", $0)}' > jwstTempCheckResult.new

cat jwstTempCheckResult.new

cat jwstTempCheckResult.new >>jwstTempFile.csv
