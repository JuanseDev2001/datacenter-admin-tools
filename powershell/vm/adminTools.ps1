function Show-Menu {
    Clear-Host
    Write-Host "===== Herramienta Administrativa (PowerShell) ====="
    Write-Host "1. Listar procesos"
    Write-Host "2. 5 procesos que mas consumen CPU"
    Write-Host "3. 5 procesos que mas consumen memoria"
    Write-Host "4. Terminar un proceso"
    Write-Host "5. Listar usuarios"
    Write-Host "6. Usuarios segun vejez de password"
    Write-Host "7. Cambiar password de usuario"
    Write-Host "8. Backup de usuarios"
    Write-Host "9. Apagar equipo"
    Write-Host "0. Salir"
}

function Listar-Procesos { Get-Process | Sort-Object Name }

function Top-CPU {
    Get-Process | Sort-Object CPU -Descending | Select-Object -First 5 |
    Select-Object Id, ProcessName, CPU, WorkingSet, StartTime, Threads, Handles, Responding | Format-Table -AutoSize
}

function Top-Memoria {
    Get-Process | Sort-Object PrivateMemorySize64 -Descending | Select-Object -First 5 | 
    Select-Object Id, ProcessName, CPU, 
        @{Name='MemoriaMB';Expression={[math]::Round($_.PrivateMemorySize64 / 1MB, 2)}}, 
        StartTime, Threads, Handles, Responding |
    Format-Table -AutoSize
}


function Terminar-Proceso {
    $processId = Read-Host "PID del proceso a terminar"
    Stop-Process -Id $processId -Force
}

function Listar-Usuarios {
    Get-LocalUser
}

function Usuarios-Vejez-Contraseña {
    Get-LocalUser | Select-Object Name, PasswordLastSet
}

function Cambiar-Contraseña {
    $user = Read-Host "Usuario"
    $pass = Read-Host "Nueva contraseña" -AsSecureString
    Set-LocalUser -Name $user -Password $pass
}

function Backup-Usuarios {
    $fecha = Get-Date -Format "yyyy-MM-dd"
    $destino = "C:\Backups"
    if (-not (Test-Path $destino)) { New-Item -ItemType Directory -Path $destino }
    $archivo = "$destino\usuarios-$fecha.zip"
    Compress-Archive -Path "C:\Users\*" -DestinationPath $archivo
    Write-Host "Backup creado en $archivo"
}

function Apagar {
    Stop-Computer
}



function Ver-Backups {
    $destino = "C:\Backups"
    if (-Not (Test-Path $destino)) {
        Write-Host "No existe la carpeta de backups ($destino)."
        return
    }
    $backups = Get-ChildItem -Path $destino -Filter *.zip | 
               Select-Object Name, @{Name="FechaCreacion";Expression={$_.CreationTime}} |
               Sort-Object FechaCreacion -Descending
    if ($backups.Count -eq 0) {
        Write-Host "No se encontraron backups en $destino."
    } else {
        $backups | Format-Table -AutoSize
    }
}

function Show-Menu {
    Clear-Host
    Write-Host "===== Herramienta Administrativa (PowerShell) ====="
    Write-Host "1. Listar procesos"
    Write-Host "2. 5 procesos que mas consumen CPU"
    Write-Host "3. 5 procesos que mas consumen memoria"
    Write-Host "4. Terminar un proceso"
    Write-Host "5. Listar usuarios"
    Write-Host "6. Usuarios segun vejez de password"
    Write-Host "7. Cambiar password de usuario"
    Write-Host "8. Backup de usuarios"
    Write-Host "9. Apagar equipo"
    Write-Host "10. Ver backups de usuarios"
    Write-Host "0. Salir"
}

do {
    Show-Menu
    $op = Read-Host "Selecciona una opcion"
    switch ($op) {
        "1" { Listar-Procesos }
        "2" { Top-CPU }
        "3" { Top-Memoria }
        "4" { Terminar-Proceso }
        "5" { Listar-Usuarios }
        "6" { Usuarios-Vejez-Contraseña }
        "7" { Cambiar-Contraseña }
        "8" { Backup-Usuarios }
        "9" { Apagar }
        "10" { Ver-Backups }
    }
    Pause
} while ($op -ne "0")
