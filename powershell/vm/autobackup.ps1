$fecha = Get-Date -Format "yyyy-MM-dd"
$destino = "C:\Backups"
if (-not (Test-Path $destino)) { New-Item -ItemType Directory -Path $destino }
$archivo = "$destino\usuarios-$fecha.zip"
Compress-Archive -Path "C:\Users\*" -DestinationPath $archivo
Write-Host "Backup creado en $archivo"