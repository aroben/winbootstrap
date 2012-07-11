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
  $zipPackage = Create-ShellFolder $zipFile
  $destination = Create-ShellFolder $destinationPath
  $destination.CopyHere($zipPackage.Items(), 0x10)
}

$client = New-Object Net.WebClient
$zip = Join-Path $tempDir.FullName winbootstrap.zip
$client.DownloadFile("https://github.com/aroben/winbootstrap/zipball/master", $zipFile)
Unzip-Files $zip $tempDir.FullName
$install = Join-Path $tempDir.FullName install.cmd
& $install
