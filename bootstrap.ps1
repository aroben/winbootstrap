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
  net start sshd
}

Install-Cygwin
Register-Sshd
