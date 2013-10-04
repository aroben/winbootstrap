Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Install-Cygwin {
  $client = New-Object Net.WebClient
  $cygwinInstaller = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + ".exe")
  
  $client.DownloadFile("http://cygwin.com/setup-x86.exe", $cygwinInstaller)

  $packages = "libintl8,libgcc1,libncursesw10,libiconv2,libattr1,csih,libpcre0,libmpfr4,cygrunsrv,openssh"

  $process = Start-Process -PassThru $cygwinInstaller --quiet-mode, --site, http://mirrors.kernel.org/sourceware/cygwin, --local-package-dir, C:\ProgramData\Cygwin, --packages, $packages
  Wait-Process -InputObject $process
  if ($process.ExitCode -ne 0) {
    throw "Error installing Cygwin"
  }
}

function Create-RootDirectory {
  # Our bootstrapping scripts rely on /root existing in a bash shell.
  New-Item C:\cygwin\root -Type Directory | Out-Null
}

function Register-Sshd {
  Add-Type -Assembly System.Web
  $password = [Web.Security.Membership]::GeneratePassword(16, 4)
  C:\cygwin\bin\bash.exe --login -- /usr/bin/ssh-host-config --yes --user cyg_server --pwd $password
  netsh advfirewall firewall add rule name=sshd dir=in action=allow program=C:\cygwin\usr\sbin\sshd.exe localport=22 protocol=tcp
  net start sshd
}

Install-Cygwin
Create-RootDirectory
Register-Sshd
Restart-Computer
