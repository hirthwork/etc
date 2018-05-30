#!/bin/sh
set -e
folder=$1
file=$2
md5sum=$(find $folder -type f  -exec realpath '{}' \; -exec getfattr --absolute-names -d '{}' \; -exec cat '{}' \; | md5sum | cut -d' ' -f1)
last=/root/$file.last.md5
test "$md5sum" = "$(cat $last)" && exit 0 || true

target=$file.$(date +%FT%T).tar.xz

archive=$(mktemp --suffix=.$target)
function cleanup() {
    rm -f $archive
}
trap cleanup EXIT

log=$(mktemp --suffix=.$target.log)
XZ_OPT=-9 tar --xattrs --create --xz --file=$archive $folder
code=$(curl -s -m 300 -w '%{http_code}' -o $log -T $archive -H "Authorization: $(cat /root/auth)" https://webdav.yandex.ru/backup/$file/$target)
if [ "$code" = 201 ]
then
    rm -f $archive $log
    echo $md5sum > $last
    exit 0
else
    exit 1
fi

