$destdriveltr = J:

#Create the array of the size you want
$out = New-Object Byte[] 4096
#Fill the array using a System.Random object
(New-Object Random).NextBytes($out)
#Write the array to a file with System.IO.File
[IO.File]::WriteAllBytes('filename', $out)

$i = 0 
while($i -lt 99999)
{
	$i++
	$randomnum = Get-Random -Minimum 2 -Maximum 8
	$dest = "J:\X"+ $randomnum + $i
	Copy-Item "E:\downloads" $dest -Recurse
	Write-Host "Finished " +  $dest + " Copy"	
}
Write-Host "Count completed to $i"