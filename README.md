1. Download and install [Cygwin](http://cygwin.com/setup.exe)
   * Use `C:\ProgramData\Cygwin` as the local packages directory
   * Install `openssh` in addition to all the default packages
2. Download and extract [this repo's scripts](https://github.com/aroben/winbootstrap/zipball/master)
3. Double-click `install.cmd`

On the next boot of this machine, `sshd` will get configured with new host
keys. You can save a disk image of the machine at this point to enable quick
setup of additional machines, or just reboot and go on your way.
