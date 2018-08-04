shellm-source shellm/home

## \brief Control the loops within your scripts (pause/stop them).
## \desc The loop.sh library provides functions to control loops within shells scripts.
## When used, it allows to control the execution of already running loops from whatever
## location or terminal. It is therefore possible to pause a script from another terminal
## without hitting Control-Z in the shell process running the script.
##
## Here is an example of usage in a script called "my-script":
##
##     #!/bin/bash
##     source $(shellm-core-path)
##     shellm-source shellm/loop
##
##     loop init "my-loop"
##
##     i=0
##     while true; do
##
##       loop control "my-loop"
##
##       echo "$i"
##       (( i++ ))
##       sleep 1
##     done
##
## And the commands used in another shell to control the execution of "my-loop":
##
##     $ loop pause "my-script" "my-loop"
##     $ loop resume "my-script" "my-loop"
##     $ loop stop "my-script" "my-loop"
##
## This execution control mechanism can even allow to control several loops and inner loops
## (nested loops) at the same time, or make different scripts dependents from each other.

loop_alive() {
  loop_exists "$1" "$2" && ! loop_paused "$1" "$2"
}

loop_control() {
  if loop_paused "$1" "$2"; then
    loop_wait "$1" "$2"
  elif loop_dead "$1" "$2"; then
    # shellcheck disable=SC2104
    break
  fi
}

loop_dead() {
  ! loop_exists "$1" "$2"
}

loop_exists() {
  [ -f "${__loop_datadir}/$1_$2" ]
}

loop_init() {
  if ! loop_exists "$1" "$2"; then
    touch "${__loop_datadir}/$1_$2"
  else
    return 1
  fi
}

loop_pause() {
  if loop_exists "$1" "$2"; then
    echo "paused" > "${__loop_datadir}/$1_$2"
  else
    return 1
  fi
}

loop_paused() {
  if ! grep -q paused "${__loop_datadir}/$1_$2" 2>/dev/null; then
    return 1
  fi
}

loop_resume() {
  if loop_exists "$1" "$2"; then
    echo "" > "${__loop_datadir}/$1_$2"
  else
    return 1
  fi
}

loop_stop() {
  rm "${__loop_datadir}/$1_$2" 2>/dev/null
}

loop_wait() {
  while loop_paused "$1" "$2"; do
    sleep 1;
  done
}

## \fn loop
## \brief Pause (resume), stop or check that a loop is alive or dead.
loop() {
  __loop_datadir="${__loop_datadir:-$(home-data loop)}"

  local loop_command="$1"
  shift

  local arg0 var

  if [[ $# -eq 2 && -n "$2" ]]; then
    arg0="$1"
    var="$2"
  else
    arg0="$(basename "$0")"
    var="$1"
  fi

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
    alive) loop_alive "${arg0}" "${var}" ;;
    control) loop_control "${arg0}" "${var}" ;;
    dead) loop_dead "${arg0}" "${var}" ;;
    exists) loop_exists "${arg0}" "${var}" ;;
    init) loop_init "${arg0}" "${var}" ;;
    pause) loop_pause "${arg0}" "${var}" ;;
    paused) loop_paused "${arg0}" "${var}" ;;
    resume) loop_resume "${arg0}" "${var}" ;;
    stop) loop_stop "${arg0}" "${var}" ;;
    wait) loop_wait "${arg0}" "${var}" ;;
  esac
}
