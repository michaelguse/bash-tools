#!/bin/bash

curl -sH 'X-Papertrail-Token: VxaeIfIpA0WtPgpzVkk' https://papertrailapp.com/api/v1/archives.json | \
grep -o '"filename":"[^"]*"' | egrep -o '[0-9-]+' | \
awk '$0 >= "2020-09-03" && $0 < "2020-09-04" {
  print "output " $0 ".tsv.gz"
  print "url https://papertrailapp.com/api/v1/archives/" $0 "/download"
}' | curl --progress-bar -fLH 'X-Papertrail-Token: VxaeIfIpA0WtPgpzVkk' -K-
