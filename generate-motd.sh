#!/bin/sh
export TERM=linux
echo
uptime -p | sed "s/^up /$(tput setaf 2)Uptime:$(tput sgr0) /;s/,[^,]\+$//"
uptime | sed "s/.*load average: /$(tput setaf 2)Load average:$(tput sgr0) /"
echo -n "$(tput setaf 2)Last backup:$(tput sgr0) "
ls -lt --time-style="+%F %T" /root/last.successful.backup | awk '{print $6" "$7;}'
find /root/last.successful.backup -cmin +65|read x && echo "$(tput setaf 1)Last backup was more than hour ago!$(tput sgr0)"
echo
users=$(who)
if [ -n "$users" ]
then
    echo "$(tput setaf 2)Users:$(tput sgr0)"
    echo "$users"
    echo
fi
