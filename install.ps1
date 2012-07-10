Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Install-Cygwin {
  $client = New-Object Net.WebClient
  $cygwinInstaller = [IO.Path]::GetTempFileName()
  $client.DownloadFile("http://cygwin.com/setup.exe", $cygwinInstaller)

  & $cygwinInstaller --quiet-mode --download --local-package-dir C:\ProgramData\Cygwin --packages openssh
  if ($LastExitCode -ne 0) {
    throw "Error installing Cygwin"
  }
}

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

Install-Cygwin
Install-BootstrapSshFiles
Enable-AutoLogOn
