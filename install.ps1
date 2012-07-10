Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Install-BootstrapSshFiles {
  $directory = Split-Path $MyInvocation.MyCommand.Path
  Copy-Item (Join-Path $directory bootstrap-ssh.sh) C:\cygwin\home\Administrator
  Copy-Item (Join-Path $directory bootstrap-ssh.cmd) [Environment]::GetFolderPath("Startup")
}

function Read-HostMasked([string]$prompt="Password") {
  $password = Read-Host -AsSecureString $prompt;
  $BSTR = [System.Runtime.InteropServices.marshal]::SecureStringToBSTR($password);
  $password = [System.Runtime.InteropServices.marshal]::PtrToStringAuto($BSTR);
  [System.Runtime.InteropServices.Marshal]::ZeroFreeBSTR($BSTR);
  return $password;
}

function Enable-AutoLogOn {
  $password = Read-HostMasked
  Push-Location "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon"
  Set-ItemProperty . DefaultUserName Administrator
  Set-ItemProperty . DefaultPassword $password
  Set-ItemProperty . AutoAdminLogon 1
  Pop-Location
}

Install-BootstrapSshFiles
Enable-AutoLogOn
