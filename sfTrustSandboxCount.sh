#!/bin/bash
clear

if test -f sfTrustResult.new; then
  mv sfTrustResult.new sfTrustResult.old
  if test -f newDate; then
    mv newDate oldDate
  fi
fi

CURR_REL=$'Spring \'20'
NEXT_REL=$'Summer \'20'

echo
echo "|======================================================================|"
echo "|==                                                                  ==|"
echo "|==   Lookup of current active Salesforce Sandbox instances          ==|"
echo "|==                                                                  ==|"
echo "|==   Current Release (Non-Preview): ${CURR_REL}                      ==|"
echo "|==      Next Release (Preview)    : ${NEXT_REL}                      ==|"
echo "|==                                                                  ==|"

date "+%Y-%m-%d %H:%M:%S %Z" > newDate

curl -sS https://api.status.salesforce.com/v1/instances/ | jq -r -f countAllInst.jq | awk '{printf("%s,%d\n", $0, NR)}' > sfTrustResult.new
sed -e '1i\
Instance,Release Version,Location,Status,Count
' <sfTrustResult.new >listOfActiveSandboxes.csv

if test -s sfTrustResult.new; then
  echo "|==   Current run: `cat newDate`                           ==|"
  echo "|==      Last run: `cat oldDate`                           ==|"
  echo "|==                                                                  ==|"
  echo "|======================================================================|"
  echo
  echo "  Active Sandbox Statistics:"
  echo "    # of Non-Preview (${CURR_REL}) sandboxes:`less sfTrustResult.new | grep -F "${CURR_REL}" | wc -l`"
  echo "    # of Preview (${NEXT_REL}) sandboxes:    `less sfTrustResult.new | grep -F "${NEXT_REL}" | wc -l`"
  echo "    # of all active sandboxes:              `less sfTrustResult.new | wc -l`"
  echo
fi

diff sfTrustResult.old sfTrustResult.new > hasChanged
diff -y --left-column sfTrustResult.new sfTrustResult.old > diffResult.txt

if test -s hasChanged; then
  echo "  ==> Detected changes since last run! <=="
  echo

  read -n 1 -s -r -p "  Press any key to see more details or q to quit " key
  if [[ $key = q ]]; then
    echo
  else
    echo
    echo 
    echo "CURRENT (NEW)                                                 ( PREVIOUS (OLD)                                 "
    echo "--------------------------------------------------------------(------------------------------------------------"
    cat diffResult.txt
  fi
else
  echo "  No changes detected since last run!"
  echo

  read -n 1 -s -r -p "  Press any key to see more details or q to quit  " key
  if [[ $key = q ]]; then
    echo
  else
    echo 
    echo
    cat listOfActiveSandboxes.csv
  fi
fi