#!/bin/bash

pathFile=./freenom-updater/ip.txt

# Github
# https://github.com/vinanrra/Scripts-Linux

### LOG

exec 3>&1 4>&2
trap 'exec 2>&4 1>&3' 0 1 2 3
mkdir -p ./freenom-updater/logs
exec 1>>./freenom-updater/logs/freenom.log 2>&1

# Everything below will go to the file 'freenom-log.log':
### LOG

# Store date to variable
now=$(date)

# Load IP from ip.txt to a variable, if not exist will create a dummy IP
if [ ! -e "$pathFile" ]; then
    echo ----------------------------------------------------------
    echo "We don't have ip, creating dummy file"
    echo "111.111.111.11" > $pathFile
fi

myip="$(cat $pathFile)"

# Get actual IP from myip.opendns.com
newip="$(dig +short myip.opendns.com @resolver1.opendns.com)"

# Print info with OLD and NEW IP that will be store to log

echo ----------------------------------------------------------
echo "Checking if the have changed IP..."
echo "NEW = $newip"
echo "OLD = $myip"

# Check IPs if they are equal stop script
# if they are different will update DNS
if [ "$myip" == "$newip" ];then

   echo ----------------------------------------------------------
   echo FECHA:
   echo $now
   echo ----------------------------------------------------------
   echo IPs are equal, the update isnt need it.

else

   echo ----------------------------------------------------------
   echo FECHA:
   echo $now
   echo ----------------------------------------------------------
   # Get IP and store to file
   dig +short myip.opendns.com @resolver1.opendns.com > $pathFile
   
   # Execute freenom-dns to update DNS with new IP
   # You can change commands to others if you dont use freenom-dns
   # https://github.com/dabendan2/freenom-dns
   
   freenom-dns set www.vfguerra.tk A $newip
   sleep 30s
   freenom-dns set .vfguerra.tk A $newip
   
fi

# Get log size
file_size=`du -b ./freenom-updater/logs/freenom.log | tr -s '\t' ' ' | cut -d' ' -f1`

# Check log size and if its bigget than 10MB move to freenom-logs
# If folder doesnt exist it will be created.
MaxFileSize=10240
if [ $file_size -gt $MaxFileSize ];then
    timestamp=`date +%s`
    mv ./freenom-updater/logs/freenom.log ./freenom-updater/logs/freenom.log.$(date +%m_%d_%H_%Y)
    touch ./freenom-updater/logs/freenom.log
fi
