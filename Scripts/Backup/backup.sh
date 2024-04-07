#!/bin/bash

# Specify the directory containing the folders to backup
backup_dir="/path/to/folder"

# Check if the backup directory exists
if [ ! -d "$backup_dir" ]; then
    echo "Source directory does not exist."
    exit 1
fi

# Create a backup directory if it doesn't exist
backup_dest="/path/to/store"
mkdir -p "$backup_dest"

# Get current date and time
timestamp=$(date +"%Y-%m-%d_%H-%M-%S")

# Specify the names of folders to ignore (space-separated list)
ignore_folders=("noBackups")

# Set hashed password for the archive
password="CHANGE_ME"

# Loop through each folder in the source directory
for folder in "$backup_dir"/*; do
    # Check if the item is a directory
    if [ -d "$folder" ]; then
        # Extract folder name from full path
        folder_name=$(basename "$folder")

        # Check if the folder name is not in the list of folders to ignore
        if [[ ! " ${ignore_folders[@]} " =~ " $folder_name " ]]; then
            # Create a backup tar.gz file with timestamp
            backup_file="$backup_dest/${folder_name}_${timestamp}.7z"
            echo "Creating backup for $folder_name in $backup_file"
            # tar -czf "$backup_file" -C "$backup_dir" "$folder_name" -xFolderOrSubfoldersToIgnore
            7z a -p$password -r "$backup_file" "$folder" -x!*/config/MediaCover/*
            if [ $? -eq 0 ]; then
                echo "Backup created successfully."
            else
                echo "Failed to create backup."
            fi
        else
            echo "Ignoring folder $folder_name"
        fi
    fi
done

echo "All backups completed."

# Delete backups older than 7 days
echo "Deleting backups older than 7 days..."
find "$backup_dest" -type f -name "*.7z" -mtime +7 -delete
echo "Deletion complete"
