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
.\adminTools.ps1
```