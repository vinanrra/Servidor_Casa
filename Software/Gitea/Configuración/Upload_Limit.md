# Cambiar máximo tamaño y máximo número de archivos a los repositorios
Será necesario editar el archivo `app.ini` situado en: `/data/gitea/conf`

Y añadir:

```
[repository.upload]
; Whether repository file uploads are enabled. Defaults to `true`
ENABLED = true
; Path for uploads. Defaults to `data/tmp/uploads` (tmp gets deleted on gitea restart)
TEMP_PATH = data/tmp/uploads
; One or more allowed types, e.g. image/jpeg|image/png. Nothing means any file type
ALLOWED_TYPES =
; Max size of each file in megabytes. Defaults to 3MB
FILE_MAX_SIZE = 3
; Max number of files per upload. Defaults to 5
MAX_FILES = 5
```