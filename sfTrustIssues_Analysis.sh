#!/bin/zsh

local numRelRcds=()         #default
local search=", Status: "   #default
local field="14"            #default [Maintenance Id Status]
local positional=()
# local debug="false"
local usage=(
    "sfTrustIssues_Ananlysis.sh [-h|--help] [-d|--debug] [-n|--numRelRcds <number of release records|default('4')>] [-s|--search <search string|default('eventStatusCanceled')>] [-f|--field <field string|default('12')>]"
)

opterr() { echo >&2 "optparsing_demo: Unknown option '$1'" }

while (( $# )); do
    case $1 in
        --)                 shift; positional+=("${@[@]}"); break  ;;
        -h|--help)          printf "%s\n" $usage && return         ;;
#         -d|--debug)         debug="true"                          ;;
        -n|--numRelRcds)    shift; numRelRcds=$1                   ;;
        -s|--search)        shift; search=$1                       ;;
        -f|--field)         shift; field=$1                        ;;
        -*)                 opterr $1 && return 2                  ;;
        *)                  positional+=("${@[@]}"); break         ;;
    esac
    shift
done

echo "Run Info"
echo "--------------------------------"
echo "Number of Rel Rcds: ${numRelRcds}"
echo "Search string: ${search}"
echo "Field: ${field}"
echo "\nResult is sorted and shows unique occurrences."
echo '\nPress any key to continue...\n'; read -k1 -s

if [[ -z ${numRelRcds[@]} ]] 
then 
    numRelRcds=(0 1 2 3 4 5 6)
    # echo "numRelRcds: ${numRelRcds}\n"
fi

for var in ${numRelRcds}; do

    echo "\nRelease Record Count: $var"
    echo "--------------------------------"

    pcre2grep -B 6 -A 0 -M ".*Upc.*:\n(.*202.*\n){${var}}\n\/---" sfTrustIssues.log \
    | grep ${search} \
    | cut -f ${field} -d " " \
    | sort \
    | uniq -c \
    | awk '{print; count++} END {print "\nCount: " count}'

done
