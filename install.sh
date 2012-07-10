#!/bin/sh

set -ex

copy_files() {
  STARTUP="/cygdrive/c/Users/Administrator/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

  ABSOLUTE_PATH=$(cd $(dirname $0); pwd)
  cp "$ABSOLUTE_PATH/bootstrap-ssh.sh" ~
  cp "$ABSOLUTE_PATH/bootstrap-ssh.cmd" "$STARTUP"
}

enable_auto_log_on() {
  stty -echo
  read -p "Password: " PASSWORD
  stty echo

  reg add '\\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' /v DefaultUserName /d Administrator /f
  reg add '\\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' /v DefaultPassword /d "$PASSWORD" /f
  reg add '\\HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon' /v AutoAdminLogon /d 1 /f
}

copy_files
enable_auto_log_on
