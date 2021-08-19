#!/bin/bash

while true
do
	# index dir
	ls -l /volume1/movie |awk '/^d/ {print $NF}' > /volume1/movie/dir.tmp.txt
	dir_now=$(awk 'END{print NR}' /volume1/movie/dir.tmp.txt)
	dir_last=$(awk 'END{print NR}' /volume1/movie/dir.txt)
	if [ $dir_now -ne $dir_last ];then
		cat /volume1/movie/dir.tmp.txt | while read dir_line
		do
			echo $dir_line | grep -q "\["
			if [ $? -eq 0 ];then
				dir_line=$(echo $dir_line | sed 's/\]/\\\]/g' | sed 's/\[/\\\[/g')
			fi
			grep -q "${dir_line}" dir.txt
			if [ $? -ne 0 ];then
				echo "index dir ->  " $dir_line
				synoindex -A "${dir_line}"
			fi
		done
		mv /volume1/movie/dir.tmp.txt /volume1/movie/dir.txt
	fi

	# index file
	find /volume1/movie -regex ".*\.mkv\|.*\.mp4\|.*\.MP4\|.*\.MKV" > /volume1/movie/name.tmp.txt
	now=$(awk 'END{print NR}' /volume1/movie/name.tmp.txt)
	last=$(awk 'END{print NR}' /volume1/movie/name.txt)
	if [ $now -ne $last ];then
		cat name.tmp.txt | while read line
		do
			echo $line | grep -q "\["
			if [ $? -eq 0 ];then
				line=$(echo $line | sed 's/\]/\\\]/g' | sed 's/\[/\\\[/g')
			fi
			grep -q "${line}" name.txt
			if [ $? -ne 0 ];then
				echo "index ->  " $line
				synoindex -a "${line}"
			fi
		done
		mv /volume1/movie/name.tmp.txt /volume1/movie/name.txt
	fi
	sleep 3m
done
