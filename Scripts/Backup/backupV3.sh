#!/bin/bash
dir=<PATH_TO_SAVE_BACKUPS>
dirHome=<PATH_FOLDERS_TO_BACKUP>
carpetas=(
  folder1
  folder2
  folder3
)

for index in ${!carpetas[*]}; do 

    if [ ${carpetas[$index]} = Plex ];
    then
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
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
        crontab -l > $dir/${carpetas[$index]}/Crontab.$(date +%m.%d.%H.%M).txt
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
    elif [ ${carpetas[$index]} = Sonarr ]
    then
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
        tar --exclude='Sonarr/config/MediaCover' -C $dirHome -pzvcf $dir/${carpetas[$index]}/${carpetas[$index]}.$(date +%m.%d.%H.%M).tar.gz ${carpetas[$index]}
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
   
    elif [ ${carpetas[$index]} = Radarr ]
    then
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
        tar --exclude='Radarr/config/MediaCover' -C $dirHome -pzvcf $dir/${carpetas[$index]}/${carpetas[$index]}.$(date +%m.%d.%H.%M).tar.gz ${carpetas[$index]}
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} finalizada.

            =======================================================================
            "
   
    else
        echo "
            =======================================================================
            IMPORTANTANTE:
            
            Copia de ${carpetas[$index]} iniciada.

            =======================================================================
            "
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
    find $dir/${carpetas[$index]}/ -mtime +7 -exec rm {} \;
    echo "
            =======================================================================
            IMPORTANTANTE:
            
            Borrado de archivos de mas de 7 dias finalizado de ${carpetas[$index]}.

            =======================================================================
            "

done
