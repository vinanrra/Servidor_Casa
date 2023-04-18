import patoolib
import glob
import sys
import shutil
import os

# Usage: python uncompress.py PATH
# Example: python uncompress.py /path/to/folder/compressed.zip

rootFolder = sys.argv[1]
tempFolder = "/tmp"
# List of compressed files
# Need unzip and unrar installed
types = ["zip", "rar"]

for type in types:
  # Get all compressed files inside the folder
  path = rootFolder + '/*.'+ type
  files = glob.glob(path)

  # Uncompress all files found at the folder
  for i in files:
    # Uncompress each file in the same dir, without showing any info and overwrite if already uncompressed
    patoolib.extract_archive(i, outdir=tempFolder, verbosity=-1, interactive=False)

  # Move all uncompressed files to the root folder
  for file in glob.glob(tempFolder + "/*.mkv"):
    shutil.move(file, os.path.join(rootFolder, os.path.basename(file)))

print(f"[SCRIPT] Uncompressed {rootFolder}")
