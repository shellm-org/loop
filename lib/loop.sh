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
##   shellm source shellm/loop
##
##   loop init "script.loop"
##
##   i=0
##   while true; do
##
##     loop control "script.loop" || break
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

## \function loop_alive <NAME>
## \function-brief Check if the loop is alive (exists and not paused).
## \function-argument NAME The name of the loop to check.
## \function-return 0 The loop is alive.
## \function-return 1 The loop is not alive.
loop_alive() {
  loop_exists "$1" && ! loop_paused "$1"
}

## \function loop_control <NAME>
## \function-brief Wait as long as the loop is paused, return 1 when it's dead.
## Use this function like this: `loop_control $NAME || break`
## This function is a shortcut for:
##   if loop_paused $NAME; then
##     loop_wait $NAME
##   elif loop_dead $NAME; then
##     break
##   fi
## \function-argument NAME The name of the loop to control.
loop_control() {
  if loop_paused "$1"; then
    loop_wait "$1"
  elif loop_dead "$1"; then
    return 1
  fi
}

## \function loop_dead <NAME>
## \function-brief Check if the loop is dead.
## \function-argument NAME The name of the loop to check.
## \function-return 0 The loop is dead.
## \function-return 1 The loop is not dead.
loop_dead() {
  ! loop_exists "$1"
}

## \function loop_exists <NAME>
## \function-brief Check if the loop exists.
## \function-argument NAME The name of the loop to check.
## \function-return 0 The loop exists.
## \function-return 1 The loop does not exist.
loop_exists() {
  [ -f "${__loop_datadir}/$1" ]
}

## \function loop_init <NAME>
## \function-brief Initialize a loop.
## \function-argument NAME The name of the loop to initialize.
## \function-return 0 The loop was correctly initialized.
## \function-return 1 The loop was already initialized.
## \function-stderr A warning when the loop was already initialized.
loop_init() {
  if ! loop_exists "$1"; then
    touch "${__loop_datadir}/$1"
  else
    echo "loop: '$1' already initialized" >&2
    return 1
  fi
}

## \function loop_pause <NAME>
## \function-brief Pause a loop.
## \function-argument NAME The name of the loop to pause.
## \function-return 0 The loop existed and was paused.
## \function-return 1 The loop did not exist.
loop_pause() {
  if loop_exists "$1"; then
    echo "paused" > "${__loop_datadir}/$1"
  else
    return 1
  fi
}

## \function loop_paused <NAME>
## \function-brief Check if the loop is paused.
## \function-argument NAME The name of the loop to check.
## \function-return 0 The loop is paused.
## \function-return 1 The loop is not paused.
loop_paused() {
  if ! grep -q paused "${__loop_datadir}/$1" 2>/dev/null; then
    return 1
  fi
}

## \function loop_resume <NAME>
## \function-brief Resume a loop.
## \function-argument NAME The name of the loop to resume.
## \function-return 0 The loop existed and was resumed.
## \function-return 1 The loop did not exist.
loop_resume() {
  if loop_exists "$1"; then
    echo "" > "${__loop_datadir}/$1"
  else
    return 1
  fi
}

## \function loop_stop <NAME>
## \function-brief Stop a loop.
## \function-argument NAME The name of the loop to stop.
## \function-return 0 The loop existed and was stopped.
## \function-return 1 The loop did not exist.
loop_stop() {
  rm "${__loop_datadir}/$1" 2>/dev/null
}

## \function loop_wait <NAME>
## \function-brief Wait as long as a loop is paused.
## \function-argument NAME The name of the loop to wait.
loop_wait() {
  while loop_paused "$1"; do
    sleep 1;
  done
}

## \function loop_list
## \function-brief List the currently existing loops.
## \function-stdout The existing loops.
loop_list() {
  local loop_file
  find "${__loop_datadir}" -type f | while read -r loop_file; do
    echo "${loop_file##*/}"
  done
}

## \function loop <COMMAND> <NAME>
## \function-brief Main wrapper function accepting subcommands.
## COMMAND can be the following:
##
##   - `alive`: return True if the loop is alive, False otherwise.
##   - `control`: shortcut for loop paused? wait. loop dead? break.
##   - `dead`: return True if the loop is dead, False otherwise.
##   - `exists`: return True if loop has been initialized, False otherwise.
##   - `init`: init a new loop control and start it.
##   - `pause`: pause the loop. It will wait until resumed or stopped.
##   - `resume`: resume the loop.
##   - `stop`: definitely stop the loop.
##   - `wait`: wait as long as loop is paused.
## \function-argument COMMAND The subcommand to run.
## \function-argument NAME The name of the loop on which to act.
## \function-return ? The return code of the subcommand.
## \function-return 1 When the subcommand is unknown.
## \function-stderr Warning when unknown subcommmand.
loop() {
  __loop_datadir="/tmp/loop"

  ! [ -d "${__loop_datadir}" ] && mkdir "${__loop_datadir}"

  local loop_command="$1"
  local var="$2"

  case "${loop_command}" in
    alive) loop_alive "${var}" ;;
    control) loop_control "${var}" ;;
    dead) loop_dead "${var}" ;;
    exists) loop_exists "${var}" ;;
    init) loop_init "${var}" ;;
    list) loop_list ;;
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
