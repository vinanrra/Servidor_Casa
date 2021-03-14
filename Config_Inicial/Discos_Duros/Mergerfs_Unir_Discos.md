# Mergerfs
mergerfs es un sistema de archivos de unión orientado a simplificar el almacenamiento y la administración de archivos en numerosos dispositivos de almacenamiento de productos básicos. Es similar a mhddfs, unionfs y aufs.

## Cómo funciona
mergerfs combina lógicamente múltiples rutas juntas. Piensa en una unión de conjuntos. El/los archivo/s o directorio/s actuado o presentado a través de fusiones se basan en la política elegida para esa acción en particular. Lea más sobre las políticas a continuación.
```
A         +      B        =       C
/disk1           /disk2           /merged
|                |                |
+-- /dir1        +-- /dir1        +-- /dir1
|   |            |   |            |   |
|   +-- file1    |   +-- file2    |   +-- file1
|                |   +-- file3    |   +-- file2
+-- /dir2        |                |   +-- file3
|   |            +-- /dir3        |
|   +-- file4        |            +-- /dir2
|                     +-- file5   |   |
+-- file6                         |   +-- file4
                                  |
                                  +-- /dir3
                                  |   |
                                  |   +-- file5
                                  |
                                  +-- file6
```

## Opciones
### Opciones de montado

* **allow_other**: A libfuse option which allows users besides the one which ran mergerfs to see the filesystem. This is required for most use-cases.
* **minfreespace=SIZE**: The minimum space value used for creation policies. Understands 'K', 'M', and 'G' to represent kilobyte, megabyte, and gigabyte respectively. (default: 4G)
* **moveonenospc=BOOL**: When enabled if a **write** fails with **ENOSPC** or **EDQUOT** a scan of all drives will be done looking for the drive with the most free space which is at least the size of the file plus the amount which failed to write. An attempt to move the file to that drive will occur (keeping all metadata possible) and if successful the original is unlinked and the write retried. (default: false)
* **use_ino**: Causes mergerfs to supply file/directory inodes rather than libfuse. While not a default it is recommended it be enabled so that linked files share the same inode value.
* **dropcacheonclose=BOOL**: When a file is requested to be closed call `posix_fadvise` on it first to instruct the kernel that we no longer need the data and it can drop its cache. Recommended when **cache.files=partial|full|auto-full** to limit double caching. (default: false)
* **symlinkify=BOOL**: When enabled and a file is not writable and its mtime or ctime is older than **symlinkify_timeout** files will be reported as symlinks to the original files. Please read more below before using. (default: false)
* **symlinkify_timeout=INT**: Time to wait, in seconds, to activate the **symlinkify** behavior. (default: 3600)
* **nullrw=BOOL**: Turns reads and writes into no-ops. The request will succeed but do nothing. Useful for benchmarking mergerfs. (default: false)
* **ignorepponrename=BOOL**: Ignore path preserving on rename. Typically rename and link act differently depending on the policy of `create` (read below). Enabling this will cause rename and link to always use the non-path preserving behavior. This means files, when renamed or linked, will stay on the same drive. (default: false)
* **security_capability=BOOL**: If false return ENOATTR when xattr security.capability is queried. (default: true)
* **xattr=passthrough|noattr|nosys**: Runtime control of xattrs. Default is to passthrough xattr requests. 'noattr' will short circuit as if nothing exists. 'nosys' will respond with ENOSYS as if xattrs are not supported or disabled. (default: passthrough)
* **link_cow=BOOL**: When enabled if a regular file is opened which has a link count > 1 it will copy the file to a temporary file and rename over the original. Breaking the link and providing a basic copy-on-write function similar to cow-shell. (default: false)
* **statfs=base|full**: Controls how statfs works. 'base' means it will always use all branches in statfs calculations. 'full' is in effect path preserving and only includes drives where the path exists. (default: base)
* **statfs_ignore=none|ro|nc**: 'ro' will cause statfs calculations to ignore available space for branches mounted or tagged as 'read-only' or 'no create'. 'nc' will ignore available space for branches tagged as 'no create'. (default: none)
* **posix_acl=BOOL**: Enable POSIX ACL support (if supported by kernel and underlying filesystem). (default: false)
* **async_read=BOOL**: Perform reads asynchronously. If disabled or unavailable the kernel will ensure there is at most one pending read request per file handle and will attempt to order requests by offset. (default: true)
* **fuse_msg_size=INT**: Set the max number of pages per FUSE message. Only available on Linux >= 4.20 and ignored otherwise. (min: 1; max: 256; default: 256)
* **threads=INT**: Number of threads to use in multithreaded mode. When set to zero it will attempt to discover and use the number of logical cores. If the lookup fails it will fall back to using 4. If the thread count is set negative it will look up the number of cores then divide by the absolute value. ie. threads=-2 on an 8 core machine will result in 8 / 2 = 4 threads. There will always be at least 1 thread. NOTE: higher number of threads increases parallelism but usually decreases throughput. (default: 0)
* **fsname=STR**: Sets the name of the filesystem as seen in **mount**, **df**, etc. Defaults to a list of the source paths concatenated together with the longest common prefix removed.
* **func.FUNC=POLICY**: Sets the specific FUSE function's policy. See below for the list of value types. Example: **func.getattr=newest**
* **category.CATEGORY=POLICY**: Sets policy of all FUSE functions in the provided category. See POLICIES section for defaults. Example: **category.create=mfs**
* **cache.open=INT**: 'open' policy cache timeout in seconds. (default: 0)
* **cache.statfs=INT**: 'statfs' cache timeout in seconds. (default: 0)
* **cache.attr=INT**: File attribute cache timeout in seconds. (default: 1)
* **cache.entry=INT**: File name lookup cache timeout in seconds. (default: 1)
* **cache.negative_entry=INT**: Negative file name lookup cache timeout in seconds. (default: 0)
* **cache.files=libfuse|off|partial|full|auto-full**: File page caching mode (default: libfuse)
* **cache.writeback=BOOL**: Enable kernel writeback caching (default: false)
* **cache.symlinks=BOOL**: Cache symlinks (if supported by kernel) (default: false)
* **cache.readdir=BOOL**: Cache readdir (if supported by kernel) (default: false)
* **direct_io**: deprecated - Bypass page cache. Use `cache.files=off` instead. (default: false)
* **kernel_cache**: deprecated - Do not invalidate data cache on file open. Use `cache.files=full` instead. (default: false)
* **auto_cache**: deprecated - Invalidate data cache if file mtime or size change. Use `cache.files=auto-full` instead. (default: false)
* **async_read**: deprecated - Perform reads asynchronously. Use `async_read=true` instead.
* **sync_read**: deprecated - Perform reads synchronously. Use `async_read=false` instead.

**NOTE:** Options are evaluated in the order listed so if the options are **func.rmdir=rand,category.action=ff** the **action** category setting will override the **rmdir** setting.

#### Tipos de valores

* BOOL = 'true' | 'false'
* INT = [0,MAX_INT]
* SIZE = 'NNM'; NN = INT, M = 'K' | 'M' | 'G' | 'T'
* STR = string
* FUNC = FUSE function
* CATEGORY = FUSE function category
* POLICY = mergerfs function policy

## Instalación
Para instalar mergerfs será necesario ejecutar el siguiente comando:
```
sudo apt update && sudo apt install mergerfs -y
```
Una vez instalado mrgerfs, será necesario crear una carpeta en la cual se unirán todos los discos duros, en este caso se usará
```bash
sudo mkdir /media/storage
```
Ahora será necesario indicarle a mergerfs que discos duros debe unir y donde montarlos, en este caso serán los discos `DISK1` y `DISK2`, que han sido montados anteriormente, y con que permisos, mediante el comando:
```bash
sudo mergerfs -o allow_other,use_ino /mnt/FOLDER:/mnt/FOLDER /mnt/storage/
```
> Se recomienda usar una carpeta vacía.

### Montar discos automáticamente en la carpeta
Con la configuración actual, los discos duros no se montarán automáticamente, por ello será necesario editar el archivo `/etc/fstab`, añadiendo para el caso anterior:
```
/mnt/FOLDER:/mnt/FOLDER/ /media/storage  fuse.mergerfs  allow_other,use_ino,nonempty   0       0
```
Sintaxis:
```
[DISCOS_DUROS] [CARPETA_DONDE_MONTAR]  fuse.mergerfs  [OPCIONES]   0       0
```