<#
Disk Test/Free Space Wipe 
Place in the folder where you want to make the files
#>
<# Variables #>
$freeSpaceHaltSize = '741,374,182,400' #examples 1,099,511,627,776 1TB, 107,374,182,400 100GB, 10,737,418,240 10GB, 1,073,741,824 1GB, 104,857,600 100MB
$baseFileName = 'DEADBEEF' #file will contain 64kb of "DE AD BE EF" hex
$DevID = "DeviceID='C:'"
$PadFilePath = "C:\!FITPadFiles-doNotDelete"

#Debugging
#$DebugPreference = "Continue"
#Logging feature
#$ErrorActionPreference="SilentlyContinue"
try { Stop-Transcript | out-null } catch { }

#start a transcript file
try { Start-Transcript -path $scriptLog } catch { }

#current script directory
$scriptPath = split-path -parent $MyInvocation.MyCommand.Definition
#current script name
$path = Get-Location
$scriptName = $MyInvocation.MyCommand.Name
$scriptLog = "$scriptPath\log\$scriptName.log"
$filename = (Join-Path $PadFilePath $baseFileName)
$guid =[System.GUID]::NewGuid().ToString().ToUpper()
$newFileName = (Join-path $PadFilePath ($guid + '-' + $baseFileName))
Write-Host Current GUID: $guid

Write-Host Starting...
#Create destination path if it doesn't exist
If (!(Test-Path -Path $PadFilePath)) { 	New-Item -Path $PadFilePath -ItemType Directory -Force }

<# Begin Program #>
$ByteArrayPattern = new-object byte[](1024kb)
[byte[]]$ByteArrayPattern = for ($i=1; $i -le 1024kb; $i++){ 
	if ($i % 4 -eq 0) { 0xDE }
	elseif ($i % 4 -eq 1) { 0xAD }
	elseif ($i % 4 -eq 2) { 0xBE }
	elseif ($i % 4 -eq 3) { 0xEF }
}
Write-Host Starting Disk Object...
$disk = Get-WmiObject Win32_LogicalDisk -Filter $DevID | Select-Object FreeSpace

$freeSpaceHaltSize = $freeSpaceHaltSize -replace ',', ''
Write-Host Current freespace in bytes: $disk.FreeSpace
Write-Host Leaving this many bytes free: $freeSpaceHaltSize
$fillsize = ($disk.FreeSpace - $freeSpaceHaltSize)
Write-Host Filling this many bytes: $fillsize

$Level1 = [int]($fillsize / 1048576 / 10)
$Level2 = [int]($Level1 / 10)
$Level3 = [int]($Level2 / 10)
$Level4 = [int]($Level3 / 10)
Write-Host Number of 1mb loops at each level L1 $Level1, L2 $Level2, L3 $Level3, L4 $Level4


for ($a=1; $a -le 9; $a++) {
	Write-Host Freespace $disk.FreeSpace
	$guid =[System.GUID]::NewGuid().ToString().ToUpper()
	$newFileName = (Join-path $PadFilePath ($guid + '-' + $baseFileName))
	write-host $newFileName
	set-content -value $ByteArrayPattern -encoding byte -path $filename	
	for ($i=1; $i -le $Level1; $i++) {
		add-content -value $ByteArrayPattern -encoding byte -path $filename	
		Write-Host((Get-Item $filename).length/1MB)
	}
	Rename-Item -Path $filename -NewName ($newFileName + $a)
	$disk = Get-WmiObject Win32_LogicalDisk -Filter $DevID | Select-Object FreeSpace
}
	for ($a=1; $a -le 9; $a++) {
	Write-Host Freespace $disk.FreeSpace
	$guid =[System.GUID]::NewGuid().ToString().ToUpper()
	$newFileName = (Join-path $PadFilePath ($guid + '-' + $baseFileName))
	write-host $newFileName
	set-content -value $ByteArrayPattern -encoding byte -path $filename	
	for ($i=1; $i -le $Level2; $i++) {
		add-content -value $ByteArrayPattern -encoding byte -path $filename	
		Write-Host((Get-Item $filename).length/1MB)
	}
	Rename-Item -Path $filename -NewName ($newFileName + $a)
	$disk = Get-WmiObject Win32_LogicalDisk -Filter $DevID | Select-Object FreeSpace
}	
	for ($a=1; $a -le 9; $a++) {
	Write-Host Freespace $disk.FreeSpace
	$guid =[System.GUID]::NewGuid().ToString().ToUpper()
	$newFileName = (Join-path $PadFilePath ($guid + '-' + $baseFileName))
	write-host $newFileName
	set-content -value $ByteArrayPattern -encoding byte -path $filename	
	for ($i=1; $i -le $Level3; $i++) {
		add-content -value $ByteArrayPattern -encoding byte -path $filename	
		Write-Host((Get-Item $filename).length/1MB)
	}
	Rename-Item -Path $filename -NewName ($newFileName + $a)
	$disk = Get-WmiObject Win32_LogicalDisk -Filter $DevID | Select-Object FreeSpace
}	
for ($a=1; $a -le 9; $a++) {
	Write-Host Freespace $disk.FreeSpace
	$guid =[System.GUID]::NewGuid().ToString().ToUpper()
	$newFileName = (Join-path $PadFilePath ($guid + '-' + $baseFileName))
	write-host $newFileName
	set-content -value $ByteArrayPattern -encoding byte -path $filename	
	for ($i=1; $i -le $Level4; $i++) {
		add-content -value $ByteArrayPattern -encoding byte -path $filename	
		Write-Host((Get-Item $filename).length/1MB)
	}
	Rename-Item -Path $filename -NewName $newFileName
	$disk = Get-WmiObject Win32_LogicalDisk -Filter $DevID | Select-Object FreeSpace
}	
Write-Host Done