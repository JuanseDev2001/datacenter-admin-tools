$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "-File C:\Users\so\autobackup.ps1"
$trigger = New-ScheduledTaskTrigger -Daily -At 3am 
Register-ScheduledTask -TaskName "EjecutarScript3AM" -Action $action -Trigger $trigger -RunLevel Highest -User "SYSTEM"