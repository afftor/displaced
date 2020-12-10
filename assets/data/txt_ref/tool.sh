#!/bin/sh

[ "$1" = "port" ] && ./tool.sh main_ref.txt "^[[:alnum:]|()?]* -" " -" && exit 0
[ "$1" = "bg" ] && ./tool.sh main_ref.txt "^=BG .*=$" "=" && exit 0
[ "$1" = "abg" ] && ./tool.sh main_ref.txt "^=ABG .*=$" "=" && exit 0
[ "$1" = "sprt" ] && ./tool.sh main_ref.txt "^=SPRITE .*=$" "=" && exit 0
[ "$1" = "sound" ] && ./tool.sh main_ref.txt "^=SOUND .*=$" "=" && exit 0
[ "$1" = "music" ] && ./tool.sh main_ref.txt "^=MUSIC .*=$" "=" && exit 0
[ "$1" = "tags" ] && ./tool.sh main_ref.txt "^=.*=$" "=" && exit 0
[ "$1" = "json" ] && ./tool.sh main_ref.txt "^{.*},$" "" && exit 0
[ "$1" = "scenes" ] && grep "^\*\*\ .*\ \*\*" main_ref.txt | sed -E "s/\*\*//g" | tr -d ' ' > scenes && exit 0

cat $1 | grep -o "$2" | sort -r | tr -d "$3" |uniq -c
