Set-StrictMode -Version Latest

function Start-Sshd {
  # First we generate new keys in case we're launching on a new VM.
  C:\cygwin\bin\bash.exe --login -- /usr/bin/ssh-host-config --yes

  Set-Service sshd -StartupType Automatic
  net start sshd
}

function Uninstall-StartupScripts {
  reg delete /f "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Group Policy\State\Machine\Scripts\Startup\0\0"
}

Start-Sshd
Uninstall-StartupScripts
