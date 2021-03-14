# Servidor
## Índice

### [Configuraciones iniciales](Config_Inicial)
* **[Swap](Config_Inicial/Swap)**
    * [Cambiar swap](Config_Inicial/Swap/Cambiar_Swap.md)
* **[Red](Config_Inicial/Red)**
    * [IP Estática](Config_Inicial/Red/IP_Estatica.md)
* **[Discos Duros](Config_Inicial/Discos_Duros)**
    * [Montar disco duro](Config_Inicial/Discos_Duros/Mount_Disk.md)
    * [MergerFS - Fusionar discos](Config_Inicial/Discos_Duros/Mergerfs_Unir_Discos.md)

## [Docker](Docker)
* **[General](Docker)**
    * [Docker Compose](Docker/docker-compose.yml)
    * [Variables (Environments)](Docker/Environments)
* **Configuración especial**
    * [Smartmontools](Docker/smartmontools)
## [Scripts](Scripts)
* **[Copias de seguridad](Scripts/Backup)**
    * **[Docker](Scripts/Docker)**
        * [Backup Contenedores y Bases de datos](Scripts/Backup/backupV3.sh)
* **[Básicos](Scripts/Básicos)**
    * [Iniciar/Parar GUI](Scripts/Básicos/gui.sh)
* **[DNS](Scripts/DNS)**
    * [Freenom](Scripts/DNS/Freenom)
        * [Actualizar DNS - Manual](Scripts/DNS/Freenom/Freenom-manual.sh)
        * [Actualizar DNS - Todos los dominios](Scripts/DNS/Freenom/Freenom-All_Domains.sh)
* **[Minecraft](Scripts/Minecraft)**
    * [RaspberryPi Minecraft Server](Scripts/Minecraft/RaspberryPiMinecraft)
* **[Monitorización](Scripts/Monitorización)**
    * **[Precios](Scripts/Precios)**
        * [Monitorización de precios en PCComponentes y Redcoon (Desactualizado)](Scripts/Monitorización/Precios/priceTracker.py)

## [Software](Software)
* **[Gitea](Software/Gitea)**
    * [Configuración](Software/Gitea/Configuración)
        * [Configuración por defecto Gitea](Software/Gitea/Configuración/app.ini.sample)
        * [Configurar limitación de máximo número de archivos y tamaño](Software/Gitea/Configuración/Upload_Limit.md)
    * [Markdown Gitea](Software/Gitea/markdown-cheatsheet-online.pdf)
    * [Link issue Gitea](Software/Gitea/Link_issue_gitea.pdf)
* **[Grafana](Software/Grafana)**
    * [Paneles](Software/Grafana/Dashboards)
        * [General](Software/Grafana/Dashboards/Plex.json)
        * [Plex](Software/Grafana/Dashboards/General.json)
* **[Mailu](Software/Mailu)**
    * [Reverse-Proxy](Software/Mailu/Reverse-Proxy)
        * [Sub-dominio](Software/Mailu/Reverse-Proxy/mailu.subdomain.conf.sample)
        * [Sub-carpeta](Software/Mailu/Reverse-Proxy/mailu.subfolder.conf.sample)
* **[Nginx](Software/Nginx)**
    * [Temas para webs](Software/Nginx/Temas)
        * [Theme Park](Software/Nginx/Temas/theme.park)
* **[Pi-Hole](Software/Pi-Hole)**
    * [Tutoriales](Software/Pi-Hole/Tutoriales)
        * [Dos Pi-Hole HA (High Availability) y sincronización](Software/Pi-Hole/Tutoriales/2_Pi-Hole_Servers.md)
* **[Telegraf](Software/Nginx)**
    * [Configuración](Software/Telegraf/Config)
        * [Pre-activado y configurado](Software/Telegraf/Config/telegraf.conf)
