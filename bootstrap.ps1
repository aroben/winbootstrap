Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

function Install-Cygwin {
  $client = New-Object Net.WebClient
  $cygwinInstaller = Join-Path ([IO.Path]::GetTempPath()) ([IO.Path]::GetRandomFileName() + ".exe")
  
  $client.DownloadFile("http://cygwin.com/setup-x86.exe", $cygwinInstaller)
  
  $packages = @(
    'libintl8',
    'libgcc1',
    'libncursesw10',
    'libiconv2',
    'libattr1',
    'csih',
    'libpcre0',
    'libmpfr4',
    'cygrunsrv',
    'diffutils',
    'libgmp3',
    'libgmp10',
    'libwrap0',
    'libkrb5_26',
    'libkafs0',
    'libgssapi3',
    'libopenssl100',
    'crypt',
    'libssp0',
    'libheimntlm0',
    'libcom_err2',
    'libheimbase1',
    'libasn1_8',
    'libwind0',
    'libhx509_5',
    'libsqlite3_0',
    'libroken18',
    'openssh'
  )

  $process = Start-Process -PassThru $cygwinInstaller --quiet-mode, --site, http://mirrors.kernel.org/sourceware/cygwin, --local-package-dir, C:\ProgramData\Cygwin, --packages, ($packages -join ",")
  Wait-Process -InputObject $process
  if ($process.ExitCode -ne 0) {
    throw "Error installing Cygwin"
  }
}

function Create-RootDirectory {
  # Our bootstrapping scripts rely on /root existing in a bash shell.
  New-Item C:\cygwin\root -Type Directory | Out-Null
}

function Rebase {
  c:\cygwin\bin\dash.exe -c '/usr/bin/rebaseall'
}

function Register-Sshd {
  Add-Type -Assembly System.Web
  $password = [Web.Security.Membership]::GeneratePassword(16, 4)
  C:\cygwin\bin\bash.exe --login -- /usr/bin/ssh-host-config --yes --user cyg_server --pwd $password
  netsh advfirewall firewall add rule name=sshd dir=in action=allow program=C:\cygwin\usr\sbin\sshd.exe localport=22 protocol=tcp
  net start sshd
}

Install-Cygwin
Rebase
Create-RootDirectory
Register-Sshd
Restart-Computer
