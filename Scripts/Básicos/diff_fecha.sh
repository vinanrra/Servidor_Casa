#!/bin/bash
curr_date=`date +%s`
date=`date +%s -d "2020-05-24"`
((diff_sec=date-curr_date))
echo $diff_sec
if [[ "diff_sec" -lt "1" ]]; then
    echo "Borrar"
else
    echo "Mantener"
fi