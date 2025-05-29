# startVm.ps1

$vmIP = "52.255.237.235"
$port = 3389
$pollingUrl = "http://localhost:3000/api/azure"

Write-Host "Verificando conexión RDP (${vmIP}:${port})..."

$result = Test-NetConnection -ComputerName $vmIP -Port $port

if ($result.TcpTestSucceeded) {
    Write-Host "La VM está encendida. Puede conectarse por RDP."
} else {
    Write-Host "La VM no responde en el puerto ${port}."
    Write-Host "Esperando a que el backend indique que la VM ha sido encendida..."

    while ($true) {
        try {
            $response = Invoke-RestMethod -Uri $pollingUrl -Method GET
            if ($response -eq "VM was stopped and has been started") {
                Write-Host "La VM está encendida. Puede conectarse por RDP."
                break
            } else {
                Write-Host "Aún no se ha iniciado la VM. Reintentando en 5 segundos..."
            }
        } catch {
            Write-Host "Error al consultar el endpoint. Reintentando en 5 segundos..."
        }
        Start-Sleep -Seconds 5
    }
}
