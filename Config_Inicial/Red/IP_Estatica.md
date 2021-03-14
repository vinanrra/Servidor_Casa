# Establecer dirección IP estática en Ubuntu 18.04

Primero será necesario listar las interfaces de red activas mediante el comando:

```bash
ifconfig -a
```
Habrá que identificar la red a modificar y apuntarla, una vez se obtenga el nombre, en este caso se llamará *enp0s8*
Una vez se haya obtenido el nombre de la red habrá que desplazarse hacia la carpeta */etc/netplan/* y comprobar los archivos existentes mediante el comando:
```bash
cd /etc/netplan/ && ls
```
> Si no existe ningún archivo será necesario generalo mediante el comando 
```bash
sudo netplan generate 
```
> Además, los archivos generados automáticamente pueden tener diferentes nombres de archivo en el escritorio, servidores, instancias en la nube, etc. (por ejemplo, 01-network-manager-all.yaml o 01-netcfg.yaml), pero todos los archivos en /etc/netplan/*.yaml serán leído por netplan.

En este caso nos encontraremos con el archivo *50-cloud-init.yaml*, el cual contiene:
```yaml
 network:
    ethernets:
        enp8s0:
            dhcp4: yes
```

Será necesario editarlo, quedando:
```yaml
 network:
    ethernets:
        enp8s0:
            dhcp4: no
            addresses:
              - 192.168.1.45/24
            gateway4: 192.168.1.1
            nameservers:
                addresses: [8.8.8.8, 1.1.1.1]
    version: 2
```
Una vez editado el archivo, será necesario aplicar los cambios mediante el comando
```bash
sudo netplan apply
```
Se podrá comprobar el estado de la red mediante
```bash
ifconfig -a
```