# Paso 1: Comprobación de la información de intercambio del sistema
Antes de empezar, podemos verificar si el sistema ya cuenta con un espacio de intercambio disponible. Es posible tener varios archivos de intercambio o intercambiar particiones, pero en general, debería bastar con una.

Podemos ver si el sistema cuenta con algún intercambio configurado al ingresar lo siguiente:
```bash
sudo swapon --show
```
Si no obtiene ningún resultado, esto significa que su sistema no tiene espacio de intercambio disponible actualmente.

Puede verificar que no haya intercambio activo con la utilidad `free`:
```bash
free -h
```

Si existe un archivo swap, será necesario eliminarlo siguiendo los siguientes comandos:
```bash
sudo swapoff -v /swap.img
sudo rm -rf /swap.img
```
# Paso 2: Comprobación de espacio disponible en la partición de la unidad de disco duro
Antes de crear nuestro archivo de intercambio, comprobaremos la utilización actual de nuestro disco para asegurarnos de tener espacio suficiente. Realice esto ingresando:
```bash
df -h
```
# Paso 3: Creación de un archivo de intercambio
Ahora que conocemos nuestro espacio de disco duro disponible, podemos crear un archivo de intercambio en nuestro sistema de archivos. Asignaremos un archivo del tamaño de intercambio que deseamos al que llamaremos `swapfile` en nuestro directorio root (/).

La mejor manera de crear un archivo de intercambio es con el programa `fallocate`. Este comando crea instantáneamente un archivo del tamaño especificado.

Dado que el servidor de nuestro ejemplo tiene 8G de RAM, crearemos un archivo de 1 G en esta guía. Ajuste esto para satisfacer las necesidades de su propio servidor:
```bash
sudo fallocate -l 8G /swap.img
```
Podemos verificar que la cantidad correcta de espacio estaba reservada al ingresar lo siguiente:
```bash
ls -lh /swap.img
```

# Paso 4: Habilitación del archivo de intercambio
Ahora que tenemos un archivo del tamaño correcto disponible, debemos convertir esto en espacio de intercambio.

Primero, debemos restringir los permisos del archivo para que solo los usuarios con **privilegios** de root puedan leer el contenido. Esto impide que usuarios comunes puedan acceder al archivo, lo que tendría implicaciones de seguridad significativas.

Haga que el archivo solo sea accesible para **root** al ingresar lo siguiente:
```bash
sudo chmod 600 /swap.img
```
Verifique el cambio de permisos al ingresar lo siguiente:
```bash
ls -lh /swap.img
```
Resultado:
```
-rw------- 1 root root 8.0G Apr 25 11:14 /swap.img
```
Como puede ver, solo el usuario root tiene las banderas de lectura y escritura habilitadas.

Ahora podemos marcar el archivo como espacio de intercambio al ingresar lo siguiente:
```bash
sudo mkswap /swap.img
```
```
Setting up swapspace version 1, size = 7629 MiB (XXXXXXXXXXXX bytes)
no label, UUID=6e965805-2ab9-450f-aed6-577e74089dbf
```
Tras marcar el archivo, podemos habilitar el archivo de intercambio, lo que permite que nuestro sistema empiece a utilizarlo:
```bash
sudo swapon /swap.img
```
Verifique que el intercambio esté disponible al ingresar lo siguiente:

```bash
sudo swapon --show
```
Podemos verificar los resultados de la utilidad free de nuevo para corroborar nuestros hallazgos:
```bash
free -h
```

# Paso 5: Lograr que el archivo de intercambio sea permanente
Nuestros cambios recientes han habilitado el archivo de intercambio para la sesión en curso. Sin embargo, si reiniciamos, el servidor no conservará los ajustes de intercambio de forma automática. Podemos cambiar esto al añadir el archivo de intercambio en nuestro archivo `/etc/fstab`.

Respalde el archivo `/etc/fstab` en caso de que algún imprevisto:
```bash
sudo cp /etc/fstab /etc/fstab.bak
```
Edite el archivo `/etc/fstab` mediante el comando:
```bash
nano /etc/fstab
```
Y añada:
> /swap.img       none    swap    sw      0       0

# Paso 6: Afinación de sus ajustes de intercambio
Existen algunas opciones que puede configurar y que tendrán un impacto en el rendimiento de su sistema al lidiar con un intercambio.

## Ajuste de la propiedad de swappiness
El parámetro de swappiness configura con qué frecuencia su sistema intercambia datos de la RAM al espacio de intercambio. Este es un valor entre 0 y 100 que representa un porcentaje.

Con valores cercanos a cero, el núcleo no intercambiará datos en el disco a menos que sea absolutamente necesario. Recuerde, las interacciones con el archivo de intercambio son “extensas” puesto que tardan mucho más que las interacciones con la RAM y pueden causar una reducción significativa en el rendimiento. Indicar al sistema que no dependa del intercambio en demasía hará que su sistema sea más rápido.

Los valores cercanos a 100 intentarán poner más datos en un esfuerzo por mantener más espacio de RAM libre. Dependiendo del perfil de memoria de sus aplicaciones o para qué está utilizando su servidor, esto podría ser mejor en algunos casos.

Podemos ver el valor de intercambiabilidad actual al ingresar lo siguiente:
```bash
cat /proc/sys/vm/swappiness
```
Resultado:
> 60

Para un escritorio, un ajuste de intercambiabilidad de 60 no es un mal valor. Para un servidor, podría querer desplazarlo más cerca de 0.

Podemos establecer la intercambiabilidad en un valor diferente al utilizar el comando `sysctl`.

Por ejemplo, para establecer la intercambiabilidad en 10, podríamos ingresar lo siguiente:
```bash
sudo sysctl vm.swappiness=10
```
Resultado:
> vm.swappiness = 10

Esta configuración persistirá hasta el próximo reinicio. Podemos establecer este valor automáticamente al reiniciar añadiendo la línea en nuestro archivo `/etc/sysctl.conf`:
```bash
sudo nano /etc/sysctl.conf
```
En la parte inferior, puede añadir:
> vm.swappiness=10
Guarde y cierre el archivo cuando haya terminado.

## Ajustar configuración de presión de Cache

Otro valor relacionado que podría querer modificar es el `vfs_cache_pressure`. Esta ajuste determina en qué medida el sistema elegirá almacenar en caché información de inodos y entradas de directorio en lugar de otros datos.

Básicamente, estos son datos de acceso sobre el sistema de archivos. Generalmente, esto resulta muy costoso de consultar y con mucha frecuencia se le solicita, por lo que es algo excelente para el almacenamiento caché de su sistema. Puede ver el valor actual al consultar el sistema de archivos de `proc` nuevamente:
```bash
cat /proc/sys/vm/vfs_cache_pressure
```
Resultado:
> 100

Dado que está configurado actualmente, nuestro sistema elimina la información de inodo de la memoria caché demasiado rápido. Podemos establecer esto en un parámetro más conservador como 50 al ingresar:
```bash
sudo sysctl vm.vfs_cache_pressure=50
```
Resultado:
> vm.vfs_cache_pressure = 50

Una vez más, esto solo es válido para nuestra sesión actual. Podemos cambiar eso al añadirlo en nuestro archivo de configuración como hicimos con nuestro ajuste de intercambiabilidad:
```bash
sudo nano /etc/sysctl.conf
```
En la parte inferior, añada la línea que especifique su nuevo valor:
> vm.vfs_cache_pressure=50