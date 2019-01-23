#!/bin/bash
Njob=15
for i in `seq ${Njob}`
do
	echo "$i"
	sleep 3
done
echo -e "time-consuming: $SECONDS seconds"
