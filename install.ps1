Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$scriptDirectory = Split-Path $MyInvocation.MyCommand.Path

function Install-Cygwin {
  $client = New-Object Net.WebClient
  $cygwinInstaller = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + ".exe")
  $client.DownloadFile("http://cygwin.com/setup.exe", $cygwinInstaller)

  $process = Start-Process -PassThru $cygwinInstaller --quiet-mode, --site, http://mirrors.kernel.org/sourceware/cygwin, --local-package-dir, C:\ProgramData\Cygwin, --packages, openssh
  Wait-Process -InputObject $process
  if ($process.ExitCode -ne 0) {
    throw "Error installing Cygwin"
  }
}

function Install-BootstrapSshFiles {
  Copy-Item (Join-Path $scriptDirectory bootstrap-ssh.sh) C:\cygwin\home\Administrator
  Copy-Item (Join-Path $scriptDirectory bootstrap-ssh.cmd) ([Environment]::GetFolderPath("Startup"))
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
