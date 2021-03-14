#!/bin/bash

# Backup folder
dir=XXXXXXXXXXXX

# Folder where are the folders to backup
dirHome=XXXXXXXXXXXX

# Folders to backup, case-sensitive
carpetas=(
  XXXXXXXXXXXX
  XXXXXXXXXXXX
)

# Start a bucle with each folder and finish when no more folders
for index in ${!carpetas[*]}; do 

	# Create folders if not exist
    if [ -d $dir/${carpetas[$index]} ]
    then
        echo ${carpetas[$index]} - La carpeta ya existe
    else
        # Create folder and parent folders
        mkdir -p $dir/${carpetas[$index]}
    fi

    # Exception, if folder is Plex
    if [ ${carpetas[$index]} = Plex ];
    then
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
        # Create a copy of the sqlite database and add current date to file 
        echo ".dump metadata_item_settings" | sqlite3 $dirHome/Plex/config/Library/Application\ Support/Plex\ Media\ Server/Plug-in\ Support/Databases/com.plexapp.plugins.library.db | grep -v TABLE | grep -v INDEX > $dir/Plex/$(date +%m.%d.%H.%M)PlexDatabase.sql
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
    
    elif [ ${carpetas[$index]} = Kanboard ]
    then
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
        # Create a copy of the sqlite database and add current date to file 
        sqlite3 $dirHome/Nginx_SSL/config/www/Kanboard/data/db.sqlite ".backup $dir/Kanboard/Kanboard.$(date +%m.%d.%H.%M).data.sqlite"
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
    
    elif [ ${carpetas[$index]} = Crontab ]
    then
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
        # Export crontab list to file and add current date.
        crontab -l > $dir/${carpetas[$index]}/Crontab.$(date +%m.%d.%H.%M).txt
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
    # If is not an exception backup folders inside folder called with software name
    else
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
        # Backup in tar.gz with current date
        tar -C $dirHome -pzvcf $dir/${carpetas[$index]}/${carpetas[$index]}.$(date +%m.%d.%H.%M).tar.gz ${carpetas[$index]}
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
    fi

    echo "
            =======================================================================
            IMPORTANTANTE:
            
            Borrado de archivos de mas de 7 dias iniciado de ${carpetas[$index]}.

            =======================================================================
         "
    # Remove files which are 7 days old
    find $dir/${carpetas[$index]}/ -mtime +7 -exec rm {} \;
    echo "
            =======================================================================
            IMPORTANTANTE:
            
            Borrado de archivos de mas de 7 dias finalizado de ${carpetas[$index]}.

            =======================================================================
            "

done
