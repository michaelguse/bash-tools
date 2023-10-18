#!/bin/zsh
grep 'active sandboxes' sfSandboxCount.log |cut -f 7 -w |awk '{printf("%d,%s\n",NR, $0)}' |sed -e '1i\
day, active_sb_count
'