# Montar disco duro
Para montar un disco duro será necesario crear una carpeta en la cual se montará, en este caso se usará la carpeta `/mnt/DISK1`, la crearemos mediante el comando:
```
sudo mkdir /mnt/2TB
```
Una vez haya sido creada la carpeta, será necesario encontrar el disco duro a montar, por ello listaremos los discos duros mediante:
```
sudo fdisk -l
```
Una vez listados, será necesario apuntar la ruta del disco duro, en este caso `/dev/sdb1`, y lo montaremos mediante el comando:
```
sudo mount /dev/sdb1 /mnt/DISK1/
```
Con ello ya estaría montado el disco duro en la carpeta `/mnt/DISK1`, pudiendo comprobalo mediante:
```
ls /mnt/DISK1
```
# Montar discos duros al iniciar el sistema
Se volverá a listar los discos duros mediante `sudo fdisk -l` y apuntar:

* Device, la carpeta

Una vez identificado el disco será también necesario obtener el UUID, para ello ejecutaremos el comando:
```
ls -l /dev/disk/by-uuid/
```

Con lo mostrado anteriormente, los discos duro no se montarán automáticamente, por ello deberemos añadir al archivo `/etc/fstab` las siguientes líneas:
```
UUID=XXXXXXXXXXXXXXXXXXXXXXXXXXXXX /mnt/2TB/ ext4 defaults 0 0
```
