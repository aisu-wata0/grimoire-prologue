#!/bin/bash
while read LINE; do
	COUNT=$(echo "$LINE" | wc -c) ;
	if [ "$COUNT" -gt "30" ]; then
		echo "$COUNT: $LINE" ;
	fi ;
done < ./FILE