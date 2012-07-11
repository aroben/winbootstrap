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

function Register-Sshd {
  Add-Type -Assembly System.Web
  $password = [Web.Security.Membership]::GeneratePassword(16, 4)
  C:\cygwin\bin\bash.exe --login -- /usr/bin/ssh-host-config --yes --user cyg_server --pwd $password
  netsh advfirewall firewall add rule name=sshd dir=in action=allow program=C:\cygwin\usr\sbin\sshd.exe localport=22 protocol=tcp
  # Don't let sshd start on the next boot until we've had a chance to regenerate the host keys.
  Set-Service sshd -StartupType Disabled
}

function Install-StartupScripts {
  foreach ($script in (Resolve-Path (Join-Path $scriptDirectory "bootstrap-startup*"))) {
    Copy-Item $script.Path C:\cygwin\home\Administrator
  }

  reg import (Join-Path $scriptDirectory bootstrap-startup.reg) 2>$null
  if ($LastExitCode -ne 0) {
    throw "Error installing startup script"
  }
}

Install-Cygwin
Register-Sshd
Install-StartupScripts
