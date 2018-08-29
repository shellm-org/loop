## \brief Control the loops within your scripts (pause/stop them).
## \desc The loop.sh library provides functions to control loops within shells scripts.
## When used, it allows to control the execution of already running loops from whatever
## location or terminal. It is therefore possible to pause a script from another terminal
## without hitting Control-Z in the shell process running the script.
##
## This execution control mechanism can even allow to control several loops and inner loops
## (nested loops) at the same time, or make different scripts dependents on each other.

## \example In a script:
## \example-code bash
##   #!/bin/bash
##   source $(shellm-core-path)
##   shellm-source shellm/loop
##
##   loop init "script.loop"
##
##   i=0
##   while true; do
##
##     loop control "script.loop"
##
##     echo "$i"
##     (( i++ ))
##     sleep 1
##   done

## \example Then, from another terminal:
## \example-code console
##   $ loop pause "script.loop"
##   $ loop resume "script.loop"
##   $ loop stop "script.loop"

loop_alive() {
  loop_exists "$1" && ! loop_paused "$1"
}

loop_control() {
  if loop_paused "$1"; then
    loop_wait "$1"
  elif loop_dead "$1"; then
    # shellcheck disable=SC2104
    break
  fi
}

loop_dead() {
  ! loop_exists "$1"
}

loop_exists() {
  [ -f "${__loop_datadir}/$1" ]
}

loop_init() {
  if ! loop_exists "$1"; then
    touch "${__loop_datadir}/$1"
  else
    return 1
  fi
}

loop_pause() {
  if loop_exists "$1"; then
    echo "paused" > "${__loop_datadir}/$1"
  else
    return 1
  fi
}

loop_paused() {
  if ! grep -q paused "${__loop_datadir}/$1" 2>/dev/null; then
    return 1
  fi
}

loop_resume() {
  if loop_exists "$1"; then
    echo "" > "${__loop_datadir}/$1"
  else
    return 1
  fi
}

loop_stop() {
  rm "${__loop_datadir}/$1" 2>/dev/null
}

loop_wait() {
  while loop_paused "$1"; do
    sleep 1;
  done
}

## \fn loop
## \brief Pause (resume), stop or check that a loop is alive or dead.
loop() {
  __loop_datadir="/tmp/loop"

  ! [ -d "${__loop_datadir}" ] && mkdir "${__loop_datadir}"

  local loop_command="$1"
  local var="$2"

  ## \param COMMAND
  ## COMMAND can be the following:
  ##
  ##     - `alive`: return True if the loop is alive, False otherwise.
  ##     - `control`: shortcut for loop paused? wait. loop dead? break.
  ##     - `dead`: return True if the loop is dead, False otherwise.
  ##     - `exists`: return True if loop has been initialized, False otherwise.
  ##     - `init`: init a new loop control and start it.
  ##     - `pause`: pause the loop. It will wait until resumed or stopped.
  ##     - `resume`: resume the loop.
  ##     - `stop`: definitely stop the loop.
  ##     - `wait`: wait as long as loop is paused.
  case "${loop_command}" in
    alive) loop_alive "${var}" ;;
    control) loop_control "${var}" ;;
    dead) loop_dead "${var}" ;;
    exists) loop_exists "${var}" ;;
    init) loop_init "${var}" ;;
    pause) loop_pause "${var}" ;;
    paused) loop_paused "${var}" ;;
    resume) loop_resume "${var}" ;;
    stop) loop_stop "${var}" ;;
    wait) loop_wait "${var}" ;;
    *)
      echo "loop: unknow command '${loop_command}'" >&2
      return 1
    ;;
  esac
}
