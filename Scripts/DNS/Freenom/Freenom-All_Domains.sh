#!/bin/bash

# SUBDOMAINS
subdomains=(
  SUBDOMAIN
  SUBDOMAIN2
)

# Path to store IP
pathFile=/tmp/freenom_ip_tmp.txt

#THE FILE EXIST?
if [ ! -e "$pathFile" ]; then
    echo "We don't have ip" > $pathFile
fi

#READ THE IP FROM FILE
oldip="$(cat $pathFile)"

#GET THE CURRENT IP WAN
newip="$(dig +short myip.opendns.com @resolver1.opendns.com)"

#IN CASE IT DOESN'T WORK TRY WITH THIS
while ! [[ $newip =~ ^[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+$ ]] #CAN CHANGE FOR AN IF
do
        echo "DIG have a problem"
        newip=$(dig TXT +short o-o.myaddr.l.google.com @ns1.google.com | awk -F'"' '{ print $2}')
done

echo ----------------------------------------------------------
echo "Checking if the have changed IP..."
echo "OLD = $oldip"
echo "NEW = $newip"
echo -e "$(date '+%Y/%m/%d %H:%M:%S') \n"

#NEED TO BE UPDATED?
if [ "$oldip" == "$newip" ]
then
        #NO
        echo -e "IPs are equal, the update isnt need it.\n"
else
        #YES
        echo -e "Ips not equal, changing.\n"

        #SAVE IP TO FILE
        echo "${newip}" > $pathFile

        #UPDATE ALL DOMAIN NAME
        for domain in $(freenom-dns list | grep '\.' | awk '{print $1}')
        do
                echo "domain name= ${domain}"
                freenom-dns set www.${domain} A $newip #You could save the result and with an if look if it gave an error, but it is not necessary
                #sleep 1m
                freenom-dns set ${domain} A $newip
                # UNCOMMENT IF U WANT TO CHECK SUBDOMAINS
                #for index in ${!subdomains[*]}; do 
                #sleep 1m
                #freenom-dns set ${subdomains[$index]}.${domain} A $myip
                #done
        done
        echo -e "\n $(date '+%Y/%m/%d %H:%M:%S')"
fi
echo ----------------------------------------------------------