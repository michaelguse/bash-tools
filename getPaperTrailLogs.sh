#!/bin/bash

curl -sH 'X-Papertrail-Token: XPayAjsRI5kbOuueHdV' https://papertrailapp.com/api/v1/archives.json | \
grep -o '"filename":"[^"]*"' | egrep -o '[0-9-]+' | \
awk '$0 >= "2020-01-01" && $0 < "2020-09-03" {
  print "output " $0 ".tsv.gz"
  print "url https://papertrailapp.com/api/v1/archives/" $0 "/download"
}' | \
curl --progress-bar -fLH 'X-Papertrail-Token: XPayAjsRI5kbOuueHdV' -K-
