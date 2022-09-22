import patoolib, glob, sys

rootFolder = sys.argv[1]
types = ["zip", "rar"]

for type in types:
  # Get all compressed files
  path = rootFolder + '/*.'+ type
  files = glob.glob(path)

  # Uncompress files
  for i in files:
    patoolib.extract_archive(i, outdir=rootFolder, verbosity=-1, interactive=False)
