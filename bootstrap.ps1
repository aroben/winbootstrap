Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Create-TempDirectory {
  $path = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName())
  New-Item $path -Type Directory
}

function Create-ShellFolder($path) {
  (New-Object -COM Shell.Application).NameSpace($path)
}

function Unzip-Files($zipPath, $destinationPath) {
  $zipPackage = Create-ShellFolder $zipPath
  $destination = Create-ShellFolder $destinationPath
  $destination.CopyHere($zipPackage.Items(), 0x10)
}

$tempDir = Create-TempDirectory
$client = New-Object Net.WebClient
$zip = Join-Path $tempDir.FullName winbootstrap.zip
$client.DownloadFile("https://github.com/aroben/winbootstrap/zipball/master", $zip)
Unzip-Files $zip $tempDir.FullName
Start-Sleep -Seconds 1
$install = (Resolve-Path (Join-Path $tempDir.FullName "*\install.ps1")).Path
powershell -ExecutionPolicy Bypass -File $install > C:\Users\Administrator\winbootstrap.log 2>&1
