#!/bin/zsh

local numRelRcds="4"                    #default
local search="eventStatusCanceled"      #default
local positional=()
# local debug="false"
local usage=(
    "sfTrustIssues_Ananlysis.sh [-h|--help] [-d|--debug] [-n|--numRelRcds <number of release records|default('4')>] [-s|--search <search string|default('eventStatusCanceled')>]"
)

opterr() { echo >&2 "optparsing_demo: Unknown option '$1'" }

while (( $# )); do
    case $1 in
        --)                 shift; positional+=("${@[@]}"); break  ;;
        -h|--help)          printf "%s\n" $usage && return         ;;
#         -d|--debug)         debug="true"                           ;;
        -n|--numRelRcds)    shift; numRelRcds=$1                   ;;
        -s|--search)        shift; search=$1                       ;;
        -*)                 opterr $1 && return 2                  ;;
        *)                  positional+=("${@[@]}"); break         ;;
    esac
    shift
done

#if [[ $debug == "true" ]] 
#then
    echo "Debug Info"
    echo "--------------------------------"
    echo "# of Rel Rcds: ${numRelRcds}"
    echo "Search string: ${search}"
    echo '\nResult is sorted and shows unique occurrences.\nPress any key to continue...'; read -k1 -s
#fi

pcre2grep -B 6 -A 0 -M ".*Upc.*:\n(.*202.*\n){${numRelRcds}}\n\/---" sfTrustIssues.log \
| grep ${search} \
| cut -f 12 -d " " \
| sort \
| uniq -c \
|awk '{print; count++} END {print "\nCount: " count}'