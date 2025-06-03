# datacenter-admin-tools

### Como conectarse a las maquinas virtuales

#### Linux

Una vez estes en la raiz del proyecto dirigete a /bash con el comando

```sh
cd bash
```

Si esta la primera vez que abres el proyecto, tienes que darle permisos de ejecución al script con

```sh
sudo apt update
sudo apt install curl
chmod 600 linuxvm.perm
chmod +x connect.sh
```

Ahora ejecuta el script para la conexión a la vm

```sh
./connect.sh
```


# Script de Administración Básica para Linux

```bash
#!/bin/bash
# Script de administración básica para sistemas Linux
# Autor: [Tu nombre]
# Fecha: [Fecha actual]
```



### Windows

Una vez estes en la raiz del proyecto dirigete a /powershell con el comando

```sh
cd powershell
```

Si es tu primera vez ejecutando un script tienes que modificar la política de ejecución de tu maquina para poder ejecutarlo, puedes hacerlo con:

```sh
Set-ExecutionPolicy Unrestricted -Scope CurrentUser
```

> **Nota:** ⚠️ Este comando puede llevar a consecuencias de seguridad graves, después de ejecutar el script recomendamos volver a la configuración anterior con
>
> ```sh
> Set-ExecutionPolicy Restricted -Scope CurrentUser
> ```

Ahora ejecuta el script ```startVm.ps1``` con:

```sh
.\startVm.ps1
```
Ingresa a tu proveedor de rdp y puedes loguearte con estas credenciales
```SH
IP: 52.255.237.235
Usuario: so
Contraseña: Soperativos!
```

Una vez conectado, si la maquina estaba apagada, te aparecerá un panel de administración como este:

```
WARNING: To stop SConfig from launching at sign-in, type "Set-SConfig -AutoLaunch $false"

  ================================================================================
              Welcome to Windows Server 2022 Datacenter Azure Edition
  ================================================================================

    1)  Domain/workgroup:                   Workgroup: WORKGROUP
    2)  Computer name:                      windowsVM
    3)  Add local administrator
    4)  Remote management:                  Enabled

    5)  Update setting:                     Manual
    6)  Install updates
    7)  Remote desktop:                     Enabled (more secure clients)

    8)  Network settings
    9)  Date and time
    10) Telemetry setting:                  Required
    11) Windows activation

    12) Log off user
    13) Restart server
    14) Shut down server
    15) Exit to command line (PowerShell)

  Enter number to select an option:
```

Aqui debes escribir 15 y presionar enter para poder acceder a la consola

```sh
Enter number to select an option: 15
```

Ahora ya puedes correr el script de administración con

```sh
.\vim\adminTools.ps1
```



# Script de Administración Básica para Linux

```bash
#!/bin/bash
# Script de administración básica para sistemas Linux
# Autor: [Tu nombre]
# Fecha: [Fecha actual]
```

# Funciones Principales

## `mostrar_menu()`

**Propósito:**  
Muestra el menú interactivo con todas las opciones disponibles.

**Estructura del menú:**

Listar procesos

Top 5 procesos por CPU

Top 5 procesos por Memoria

Terminar proceso

Listar usuarios

Usuarios según vejez de contraseña

Cambiar contraseña de usuario

Realizar backup del directorio /home

Ver backups en /home/ubuntu/backup

Apagar el equipo

Salir



## `listar_procesos()`

**Comando principal:**
```bash
ps aux | less
```

Muestra todos los procesos activos

Usa less para navegación interactiva

Incluye información detallada: usuario, PID, %CPU, %MEM, comando


## ``procesos_top_cpu()``
```bash
Comando: ps -eo pid,comm,%cpu --sort=-%cpu | head -n 6
```
Muestra los 5 procesos que más CPU consumen

Campos mostrados:

PID: ID del proceso

COMMAND: Nombre del proceso

%CPU: Porcentaje de uso de CPU

## ``procesos_top_mem()``

```bash
Comando: ps -eo pid,comm,%mem --sort=-%mem | head -n 6
```

Muestra los 5 procesos que más memoria consumen

Campos mostrados:

PID: ID del proceso

COMMAND: Nombre del proceso

%MEM: Porcentaje de uso de memoria

## ``terminar_proceso()``

Flujo:

Solicita PID: read -p "Ingrese el PID..."

Intenta terminar proceso: kill "$pid"

Maneja errores: 2>/dev/null

Mensajes:

Éxito: "Proceso $pid terminado correctamente"

Error: "No se pudo terminar el proceso"

## ``listar_usuarios()``
```bash
Comando: cut -d: -f1 /etc/passwd
```
Lista todos los usuarios del sistema

Extrae solo los nombres de usuario del archivo /etc/passwd


## ``vejez_contrasena()``
Técnica:

```bash
awk -F: '$3 >= 1000 { print $1 }' /etc/passwd | while read -r user; do
    chage -l "$user" | grep "Last password change"
done
```
Filtra solo usuarios reales (UID >= 1000)

Muestra fecha del último cambio de contraseña

Usa chage -l para información de caducidad

## ``cambiar_contrasena()``
```bash
Comando: sudo passwd "$usuario"
```

Solicita nombre de usuario

Ejecuta passwd con privilegios sudo

El sistema pedirá la nueva contraseña interactivamente

## ``realizar_backup()``
Características:

Detecta usuario real: ${SUDO_USER:-$USER}

Crea archivo comprimido: tar -czf

Nombre con fecha: backup_home_YYYYMMDD.tar.gz

Ruta de backup: ~/backup/

Comando completo:

```bash
tar -czf "$backup_dir/backup_home_$fecha.tar.gz" "$home_dir"
```

## ``ver_backups()``
Funcionalidad:

Lista backups en formato legible:

```bash
ls -lh --time-style=long-iso | awk '{printf "Archivo: %-40s  Fecha: %s %s\n", $9, $6, $7}'
```
Maneja casos cuando:

No existe el directorio

No hay archivos de backup

## ``apagar_equipo()``
```bash
Comando: sudo shutdown now
```
Apaga el sistema inmediatamente

Requiere privilegios sudo


# Herramienta de Administración PowerShell

## Descripción
Script interactivo para gestión de procesos, usuarios y mantenimiento en Windows Server, con menú de opciones numeradas.

## Funcionalidades

### 1. Listar Procesos (`Listar-Procesos`)
**Propósito:**  
Muestra todos los procesos en ejecución ordenados alfabéticamente.

**Detalles técnicos:**
- Usa `Get-Process` para obtener la lista de procesos
- Ordena por nombre con `Sort-Object Name`
- Muestra información básica como PID, nombre y consumo de recursos

## Top 5 Procesos en CPU (`Top-CPU`)

### Propósito
Identifica y muestra los **5 procesos más demandantes de CPU** en tiempo real, permitiendo detectar posibles cuellos de botella en el sistema.

### Detalles Técnicos
```powershell
Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 | Select-Object Id, ProcessName, CPU, WorkingSet, StartTime, Threads, Handles, Responding | Format-Table -AutoSize
```

## 3. Top 5 Procesos en Memoria (`Top-Memoria`)

### Propósito
Identifica y muestra los 5 procesos que están consumiendo mayor cantidad de memoria RAM en el sistema.

### Detalles Técnicos

**Ordenamiento:**  
Los procesos se ordenan descendentemente por su consumo de memoria privada (`PrivateMemorySize64`).

**Conversión de unidades:**  
La memoria se convierte de bytes a megabytes (MB) para una mejor legibilidad, redondeando a 2 decimales.

**Campos mostrados:**
```powershell
Id, 
ProcessName, 
CPU, 
@{Name='MemoriaMB';Expression={[math]::Round($_.PrivateMemorySize64 / 1MB, 2)}},
StartTime, 
Threads, 
Handles, 
Responding
```

# 4. Terminar Proceso (`Terminar-Proceso`)

### Propósito
Finaliza un proceso específico por su ID de proceso (PID).

### Flujo de Ejecución
1. **Solicitud de PID**:
   ```powershell
   $processId = Read-Host "PID del proceso a terminar"
   Stop-Process -Id $processId -Force
   ```

## Precauciones importantes
No requiere confirmación: El proceso se termina inmediatamente sin preguntar

Uso del parámetro -Force: Termina el proceso de manera forzosa


### 5. Listar Usuarios Locales (`Listar-Usuarios`)

**Propósito:**  
Muestra todos los usuarios locales del sistema.

**Detalles técnicos:**
- Utiliza el cmdlet nativo de PowerShell `Get-LocalUser`
- Proporciona información básica de cada cuenta de usuario local:
  - Nombre de usuario
  - Estado (habilitado/deshabilitado)
  - Descripción (si está configurada)
  - Fecha de última modificación

**Comando base:**
```powershell
Get-LocalUser
```

## 6. Vejez de Contraseñas (`Usuarios-Vejez-Contraseña`)

**Propósito:**  
Muestra cuándo fue cambiada por última vez la contraseña de cada usuario local del sistema.

**Detalles técnicos:**
- Utiliza el cmdlet `Get-LocalUser` para obtener la lista de usuarios
- Selecciona específicamente los campos:
  ```powershell
  Name              # Nombre del usuario
  PasswordLastSet   # Fecha/hora del último cambio de contraseña
  ```
### 7. Cambiar Contraseña (`Cambiar-Contraseña`)

**Propósito:**  
Permite cambiar la contraseña de un usuario local de forma segura.

**Flujo de ejecución:**  
1. Solicita el nombre de usuario
2. Pide la nueva contraseña en modo seguro (no visible)
3. Actualiza las credenciales del usuario

**Código PowerShell:**
```powershell
$user = Read-Host "Usuario"
$pass = Read-Host "Nueva contraseña" -AsSecureString
Set-LocalUser -Name $user -Password $pass
```

### 8. Backup de Usuarios (Backup-Usuarios)
Estructura:

C:\Backups\
  └── usuarios-YYYY-MM-DD.zip
Comandos clave:

```powershell
Compress-Archive -Path "C:\Users\*" -DestinationPath $archivo 

```
### 9. Apagar Equipo (Apagar)
Comando:

```powershell
Stop-Computer
```

## 10. Ver Backups (`Ver-Backups`)

**Propósito:**  
Muestra un listado organizado de todos los archivos de backup disponibles en el sistema.

**Características principales:**
- 📂 **Ubicación de backups:**  
  Busca automáticamente en `C:\Backups\` todos los archivos con extensión `.zip`
  
- 🕒 **Ordenamiento inteligente:**  
  Ordena los resultados por fecha de creación descendente (los más recientes primero)

- ⚠️ **Manejo de errores:**  
  - Detecta si no existe la carpeta de backups
  - Informa cuando no se encuentran archivos de backup

**Detalles técnicos:**
```powershell
$backups = Get-ChildItem -Path $destino -Filter *.zip | 
           Select-Object Name, @{Name="FechaCreacion";Expression={$_.CreationTime}} |
           Sort-Object FechaCreacion -Descending
```