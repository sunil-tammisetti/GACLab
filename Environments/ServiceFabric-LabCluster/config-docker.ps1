# Create disk partition
$disk = get-disk | ? { $_.PartitionStyle -eq "RAW" }
Initialize-Disk -Number $disk.Number -PartitionStyle MBR
New-Partition -DiskNumber $disk.Number -UseMaximumSize -DriveLetter F
Format-Volume -DriveLetter F -FileSystem NTFS
# Update docker settings
New-Item -Path "F:\DockerRoot" -Type Directory
Set-Content "C:\ProgramData\docker\config\daemon.json" '{"data-root": "F:\\DockerRoot"}'
Stop-Process -ProcessName dockerd -Force
Start-Sleep -s 1
Remove-Item -Path "C:\ProgramData\docker\docker.pid"
Start-Sleep -s 1
Start-Service -DisplayName "Docker"
Start-Sleep -s 1