#!/bin/sh

# http://tldp.org/LDP/abs/html/contributed-scripts.html
#  Random password generator for Bash 2.x +
#+ by Antek Sawicki <tenox@tenox.tc>,
#+ who generously gave usage permission to the ABS Guide author.
#
# ==> Comments added by document author ==>
random_password() {
  MATRIX=0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz
  # ==> Password will consist of alphanumeric characters.
  LENGTH=16
  # ==> May change 'LENGTH' for longer password.


  while [ "${n:=1}" -le "$LENGTH" ]
  # ==> Recall that := is "default substitution" operator.
  # ==> So, if 'n' has not been initialized, set it to 1.
  do
          PASS="$PASS${MATRIX:$(($RANDOM%${#MATRIX})):1}"
          # ==> Very clever, but tricky.

          # ==> Starting from the innermost nesting...
          # ==> ${#MATRIX} returns length of array MATRIX.

          # ==> $RANDOM%${#MATRIX} returns random number between 1
          # ==> and [length of MATRIX] - 1.

          # ==> ${MATRIX:$(($RANDOM%${#MATRIX})):1}
          # ==> returns expansion of MATRIX at random position, by length 1. 
          # ==> See {var:pos:len} parameter substitution in Chapter 9.
          # ==> and the associated examples.

          # ==> PASS=... simply pastes this result onto previous PASS (concatenation).

          # ==> To visualize this more clearly, uncomment the following line
          #                 echo "$PASS"
          # ==> to see PASS being built up,
          # ==> one character at a time, each iteration of the loop.

          let n+=1
          # ==> Increment 'n' for next pass.
  done

  echo "$PASS"      # ==> Or, redirect to a file, as desired.
}

start_sshd() {
  ssh-host-config --yes --user cyg_server --pwd $(random_password)
  net start sshd
}

clean_up() {
  STARTUP="/cygdrive/c/Users/Administrator/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup"
  rm "$0"
  rm "$STARTUP/bootstrap-ssh.cmd"
}

start_sshd
clean_up
