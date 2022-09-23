import patoolib, glob, sys

# Usage: python uncompress.py PATH
# Example: python uncompress.py /path/to/folder/compressed.zip

rootFolder = sys.argv[1]
# List of compressed files
# Need unzip and unrar installed
types = ["zip", "rar"]

for type in types:
  # Get all compressed files inside the folder
  path = rootFolder + '/*.'+ type
  files = glob.glob(path)

  # Uncompress all files found at the folder
  for i in files:
    # Uncompress each file in same dir, without showing any info and overwrite if already uncompressed
    patoolib.extract_archive(i, outdir=rootFolder, verbosity=-1, interactive=False)
