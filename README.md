To run:

```powershell
(New-Object Net.WebClient).DownloadString("https://raw.github.com/aroben/winbootstrap/master/bootstrap.ps1") | Invoke-Expression
```

The computer will reboot, and `sshd` will now be running.
