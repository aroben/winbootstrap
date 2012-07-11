To run:

```powershell
(New-Object Net.WebClient).DownloadString("https://raw.github.com/aroben/winbootstrap/master/bootstrap.ps1") | Invoke-Expression
```

On the next boot of this machine, `sshd` will get configured with new host
keys. You can save a disk image of the machine at this point to enable quick
setup of additional machines, or just reboot and go on your way.
