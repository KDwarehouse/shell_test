#!/bin/bash
time_date=`date +%F\ %T`
echo $time_date
