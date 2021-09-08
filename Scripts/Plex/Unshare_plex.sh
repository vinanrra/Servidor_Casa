#!/bin/bash
# Folder to store logs
dir=/XXX/XXXX/XXXX/

# Save current date to variable
curr_date=$(date +'%d-%m-%Y')
curr_date_S=$(date +%s)

# Array list with users
  lista=(
    #[USER][YYYY-MM-DD] # Example
    #[exampleUser][2020-05-10]
  )

echo Fecha: DD-MM-YYYY >> $dir/Logs/"$curr_date".log
echo Fecha: "$curr_date" >> $dir/Logs/"$curr_date".log

# Bucle with each user
for index in ${!lista[*]}; do 

    # Split content of each option of the array and save into two variables
    # First will save username inside [] into "user" variable
    # Second will save date inside [] into "todate" variable
    if [[ ${lista[$index]} =~ (\[)([^]]+)(\])(\[)(.*)(\]) ]]; then
      user="${BASH_REMATCH[2]}"
      todate="${BASH_REMATCH[5]}"
    fi

    todate_S=$(date +%s -d "$todate")
    ((diff_sec=todate_S-curr_date_S))

      # If current date is the same as "todate" unshare, if not save info to log
      # Using -lt (less than)
    if [[ "diff_sec" -lt "1" ]];
      then
          # Unshare library and save info to log
          python3 $dir/plex_api_share.py --unshare --user "$user" >> $dir/Logs/"$curr_date".log
          echo Eliminando "$user", finalizado: "$todate" >> $dir/Logs/"$curr_date".log
      else
          # Omit user and save info to log
          echo Omitiendo "$user", activo hasta "$todate" >> $dir/Logs/"$curr_date".log
    fi

    # Wait 10 sec to avoid bans
    sleep 10s

done
