#!/bin/sh

set -ex

STARTUP="/cygdrive/c/Users/Administrator/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"

ABSOLUTE_PATH=$(cd $(dirname $0); pwd)
cp "$ABSOLUTE_PATH/bootstrap-ssh.sh" ~
cp "$ABSOLUTE_PATH/bootstrap-ssh.cmd" "$STARTUP"
